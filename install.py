#!/usr/bin/env python3
"""Install script for Nix dotfiles.

Detects distro, installs Nix, applies Home Manager, and configures the environment.

Usage:
    python3 install.py                        # Full install (fish as default shell)
    python3 install.py --shell fish           # Use fish instead
    python3 install.py --skip-nix             # Skip Nix installation
    python3 install.py --skip-deps            # Skip system dependency installation
    python3 install.py --install-neovim       # Also install latest stable Neovim
    python3 install.py --dry-run              # Show what would be done
"""

import argparse
import os
import shutil
import stat
import subprocess
import sys
import time
from pathlib import Path

# ─── Colors ──────────────────────────────────────────────────────────────────

RESET = "\033[0m"
BOLD = "\033[1m"
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
CYAN = "\033[36m"


def info(msg: str) -> None:
    print(f"{BLUE}→{RESET} {msg}")


def success(msg: str) -> None:
    print(f"{GREEN}✓{RESET} {msg}")


def warn(msg: str) -> None:
    print(f"{YELLOW}!{RESET} {msg}")


def error(msg: str) -> None:
    print(f"{RED}✗{RESET} {msg}", file=sys.stderr)


def step(num: int, total: int, msg: str) -> None:
    print(f"\n{BOLD}{CYAN}[{num}/{total}]{RESET} {BOLD}{msg}{RESET}")


# ─── Helpers ─────────────────────────────────────────────────────────────────


def run(cmd: str, *, dry_run: bool = False) -> None:
    """Run a shell command with consistent output."""
    info(f"$ {cmd}")
    if dry_run:
        return
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError:
        error(f"Command failed: {cmd}")
        sys.exit(1)


def cmd_exists(name: str) -> bool:
    return shutil.which(name) is not None


def nix_daemon_running() -> bool:
    """Check if nix-daemon is already running."""
    socket = Path("/nix/var/nix/daemon-socket/socket")
    if socket.exists():
        try:
            if stat.S_ISSOCK(socket.stat().st_mode):
                return True
        except OSError:
            pass
    result = subprocess.run("pgrep -x nix-daemon", shell=True, capture_output=True)
    return result.returncode == 0


def merge_nix_conf(nix_conf: Path, required_lines: list[str]) -> None:
    """Merge required lines into nix.conf by key without overwriting."""
    existing = nix_conf.read_text().splitlines() if nix_conf.exists() else []

    # Build map of key -> line index
    key_map: dict[str, int] = {}
    for i, line in enumerate(existing):
        stripped = line.strip()
        if stripped and not stripped.startswith("#"):
            key = (
                stripped.split("=")[0].strip()
                if "=" in stripped
                else stripped.split()[0]
            )
            key_map[key] = i

    for new_line in required_lines:
        key = new_line.split("=")[0].strip() if "=" in new_line else new_line.split()[0]
        if key in key_map:
            existing[key_map[key]] = new_line
        else:
            existing.append(new_line)

    nix_conf.parent.mkdir(parents=True, exist_ok=True)
    nix_conf.write_text("\n".join(existing) + "\n")
    info(f"Updated {nix_conf}")


# ─── Distro Detection ───────────────────────────────────────────────────────

DISTRO_DEPS: dict[str, list[str]] = {
    "ubuntu": [
        "git",
        "curl",
        "python3-venv",
        "vim",
        "wl-clipboard",
        "meson",
        "ninja-build",
        "pkg-config",
        "build-essential",
        "libwayland-dev",
        "libwayland-bin",
        "wayland-protocols",
        "libpixman-1-dev",
        "libxkbcommon-dev",
        "libfontconfig1-dev",
        "libutf8proc-dev",
        "libtllist-dev",
        "scdoc",
    ],
    "debian": [
        "git",
        "curl",
        "python3-venv",
        "vim",
        "wl-clipboard",
        "meson",
        "ninja-build",
        "pkg-config",
        "build-essential",
        "libwayland-dev",
        "libwayland-bin",
        "wayland-protocols",
        "libpixman-1-dev",
        "libxkbcommon-dev",
        "libfontconfig1-dev",
        "libutf8proc-dev",
        "libtllist-dev",
        "scdoc",
    ],
    "fedora": [
        "git",
        "curl",
        "python3",
        "vim",
        "wl-clipboard",
        "meson",
        "ninja-build",
        "wayland-devel",
        "wayland-protocols-devel",
        "pixman-devel",
        "libxkbcommon-devel",
        "scdoc",
        "pkgconf-pkg-config",
        "gcc",
    ],
    "arch": [
        "git",
        "curl",
        "python",
        "vim",
        "wl-clipboard",
        "meson",
        "ninja",
        "wayland",
        "wayland-protocols",
        "pixman",
        "libxkbcommon",
        "scdoc",
        "pkgconf",
        "base-devel",
    ],
}

DISTRO_MAP = {
    "ubuntu": "ubuntu",
    "debian": "debian",
    "pop": "ubuntu",
    "fedora": "fedora",
    "arch": "arch",
    "manjaro": "arch",
}


def detect_distro() -> str:
    """Detect Linux distribution from /etc/os-release."""
    os_release = Path("/etc/os-release")
    if not os_release.exists():
        error("Cannot detect distro: /etc/os-release not found")
        sys.exit(1)

    for line in os_release.read_text().splitlines():
        if line.startswith("ID="):
            distro_id = line.split("=", 1)[1].strip().strip('"')
            canonical = DISTRO_MAP.get(distro_id, distro_id)
            if canonical in DISTRO_DEPS:
                return canonical
            error(f"Unsupported distro: {distro_id}")
            error(f"Supported: {', '.join(DISTRO_DEPS)}")
            sys.exit(1)

    error("Cannot detect distro: ID not found in /etc/os-release")
    sys.exit(1)


# ─── Install Steps ───────────────────────────────────────────────────────────


def install_system_deps(distro: str, dry_run: bool = False) -> None:
    """Install system dependencies based on distro."""
    deps = DISTRO_DEPS[distro]
    deps_str = " ".join(deps)

    if distro in ("ubuntu", "debian"):
        run("sudo apt-get update", dry_run=dry_run)
        run(f"sudo apt-get install -y {deps_str}", dry_run=dry_run)
    elif distro == "fedora":
        run(f"sudo dnf install -y -q {deps_str}", dry_run=dry_run)
    elif distro == "arch":
        run(f"sudo pacman -Syu --noconfirm {deps_str}", dry_run=dry_run)

    success("System dependencies installed")


def install_nix(is_systemd: bool, dry_run: bool = False) -> None:
    """Install Nix package manager using the Determinate Systems installer."""
    if cmd_exists("nix"):
        success("Nix already installed, skipping")
        return

    info("Installing Nix via Determinate Systems installer...")

    init_flag = "" if is_systemd else "linux --init none"
    run(
        "curl --proto '=https' --tlsv1.2 -sSf -L "
        "https://install.determinate.systems/nix -o /tmp/nix-installer",
        dry_run=dry_run,
    )
    run("chmod +x /tmp/nix-installer", dry_run=dry_run)
    run(f"/tmp/nix-installer install {init_flag} --no-confirm", dry_run=dry_run)
    run("rm -f /tmp/nix-installer", dry_run=dry_run)

    # Add nix to PATH for this session
    nix_profile = "/nix/var/nix/profiles/default/bin"
    if Path(nix_profile).exists():
        os.environ["PATH"] = f"{nix_profile}:{os.environ['PATH']}"

    success("Nix installed")


def configure_nix_daemon(user: str, dry_run: bool = False) -> None:
    """Configure and start nix-daemon for non-systemd environments."""
    nix_conf = Path("/etc/nix/nix.conf")
    required_lines = [
        f"trusted-users = root {user}",
        "experimental-features = nix-command flakes",
    ]
    if not dry_run:
        merge_nix_conf(nix_conf, required_lines)

    if not dry_run and nix_daemon_running():
        success("nix-daemon is already running")
        return

    daemon_bin = "/nix/var/nix/profiles/default/bin/nix-daemon"
    run(f"sudo {daemon_bin} &", dry_run=dry_run)

    # Wait for socket
    socket_path = "/nix/var/nix/daemon-socket/socket"
    info("Waiting for nix-daemon to start...")
    if not dry_run:
        for attempt in range(1, 31):
            if os.path.exists(socket_path):
                try:
                    if stat.S_ISSOCK(os.stat(socket_path).st_mode):
                        success("nix-daemon is running")
                        return
                except OSError:
                    pass
            info(f"Waiting for socket ({attempt}/30)...")
            time.sleep(1)
        error("nix-daemon socket did not appear after 30 seconds")
        sys.exit(1)

    success("nix-daemon is running")


def apply_home_manager(user: str, repo_dir: Path, dry_run: bool = False) -> None:
    """Apply Home Manager configuration."""
    info(f"Applying Home Manager config for user '{user}'...")
    run(
        f"USER={user} nix shell nixpkgs#home-manager "
        f"-c home-manager switch --flake {repo_dir}#{user}",
        dry_run=dry_run,
    )
    success("Home Manager configuration applied")


def setup_shell(shell: str, user: str, dry_run: bool = False) -> None:
    """Configure default shell and install shell tools."""
    home = Path.home()
    shell_paths = {
        "bash": "/bin/bash",
        "zsh": f"{home}/.nix-profile/bin/zsh",
        "fish": f"{home}/.nix-profile/bin/fish",
    }

    shell_path = shell_paths.get(shell)
    if not shell_path:
        error(f"Unknown shell: {shell}")
        return

    # Add to /etc/shells if not present
    if not dry_run:
        try:
            shells = Path("/etc/shells").read_text()
        except PermissionError:
            error("Cannot read /etc/shells (try with sudo)")
            return

        if shell_path not in shells:
            info(f"Adding '{shell_path}' to /etc/shells")
            run(f"echo '{shell_path}' | sudo tee -a /etc/shells", dry_run=dry_run)

    # Set as default
    current_shell = os.environ.get("SHELL", "")
    if current_shell != shell_path:
        info(f"Setting {shell} as default shell for {user}")
        run(f"sudo usermod -s '{shell_path}' {user}", dry_run=dry_run)
    else:
        info(f"{shell} is already the default shell")

    # Install Fisher for fish
    if shell == "fish":
        info("Installing Fisher for fish...")
        run(
            'fish -c "curl -sL https://raw.githubusercontent.com/'
            "jorgebucaran/fisher/main/functions/fisher.fish | source; "
            'fisher install jorgebucaran/fisher"',
            dry_run=dry_run,
        )
        run('fish -c "fisher install kidonng/zoxide.fish"', dry_run=dry_run)

    # Install Starship
    info("Installing Starship prompt...")
    run(
        "curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null",
        dry_run=dry_run,
    )

    # Configure Starship with nerd-font symbols
    starship_config = home / ".config" / "starship.toml"
    starship_config.parent.mkdir(parents=True, exist_ok=True)
    nix_profile_bin = f"{home}/.nix-profile/bin"
    run(
        f"PATH={nix_profile_bin}:$PATH starship preset nerd-font-symbols "
        f"-o {starship_config}",
        dry_run=dry_run,
    )

    success(f"Default shell set to {shell}")


def configure_rust() -> None:
    """Configure Rust toolchain to use stable."""
    if not cmd_exists("rustup"):
        warn("rustup not found, skipping Rust configuration")
        return

    info("Setting Rust default toolchain to 'stable'...")
    run("rustup default stable")
    success("Rust toolchain set to stable")


def install_neovim(dry_run: bool = False) -> None:
    """Install latest stable Neovim as AppImage."""
    nvim_path = Path("/usr/local/bin/nvim")

    # Check if already installed
    if nvim_path.exists() and not dry_run:
        try:
            result = subprocess.run(
                [str(nvim_path), "--version"],
                capture_output=True,
                text=True,
                timeout=5,
            )
            if result.returncode == 0:
                success(f"Neovim already installed: {result.stdout.splitlines()[0]}")
                return
        except (subprocess.TimeoutExpired, FileNotFoundError, IndexError):
            pass

    info("Installing Neovim (latest stable)...")
    if nvim_path.exists():
        run(f"sudo rm -f {nvim_path}", dry_run=dry_run)

    run(
        f"sudo curl -fL https://github.com/neovim/neovim/releases/latest/download/"
        f"nvim-linux-x86_64.appimage -o {nvim_path}",
        dry_run=dry_run,
    )
    run(f"sudo chmod +x {nvim_path}", dry_run=dry_run)
    success("Neovim installed")


# ─── Main ────────────────────────────────────────────────────────────────────


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Install Nix dotfiles environment",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                      Full install with fish
  %(prog)s --shell fish         Use fish as default shell
  %(prog)s --skip-nix           Skip Nix installation
  %(prog)s --dry-run            Preview without making changes
        """,
    )
    parser.add_argument(
        "--shell",
        choices=["bash", "zsh", "fish"],
        default="fish",
        help="Default shell to configure (default: fish)",
    )
    parser.add_argument(
        "--skip-nix",
        action="store_true",
        help="Skip Nix installation (if already installed)",
    )
    parser.add_argument(
        "--skip-deps",
        action="store_true",
        help="Skip system dependency installation",
    )
    parser.add_argument(
        "--install-neovim",
        action="store_true",
        help="Also install latest stable Neovim",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes",
    )
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    user = (
        os.getenv("USER")
        or os.getenv("LOGNAME")
        or subprocess.run(
            ["whoami"], capture_output=True, text=True, check=True
        ).stdout.strip()
    )
    is_systemd = Path("/run/systemd/system").exists()
    repo_dir = Path(__file__).parent.resolve()

    # Count steps
    steps = 4  # detect + home-manager + shell + rust
    if not args.skip_deps:
        steps += 1
    if not args.skip_nix:
        steps += 1
        if not is_systemd:
            steps += 1
    if args.install_neovim:
        steps += 1

    print(f"\n{BOLD}{'=' * 50}{RESET}")
    print(f"{BOLD}  Nix Dotfiles Installer{RESET}")
    print(f"{BOLD}{'=' * 50}{RESET}")
    print(f"  User:    {user}")
    print(f"  Shell:   {args.shell}")
    print(f"  Systemd: {'yes' if is_systemd else 'no'}")
    if args.dry_run:
        print(f"  {YELLOW}DRY RUN — no changes will be made{RESET}")
    print(f"{BOLD}{'=' * 50}{RESET}\n")

    current = 0

    # 1. Detect distro
    current += 1
    step(current, steps, "Detecting distribution")
    distro = detect_distro()
    success(f"Detected: {distro}")

    # 2. Install system deps
    if not args.skip_deps:
        current += 1
        step(current, steps, "Installing system dependencies")
        install_system_deps(distro, dry_run=args.dry_run)

    # 3. Install Nix
    if not args.skip_nix:
        current += 1
        step(current, steps, "Installing Nix")
        install_nix(is_systemd, dry_run=args.dry_run)

        # 4. Configure daemon (if needed)
        if not is_systemd:
            current += 1
            step(current, steps, "Configuring Nix daemon")
            configure_nix_daemon(user, dry_run=args.dry_run)

    # 5. Apply Home Manager
    current += 1
    step(current, steps, "Applying Home Manager")
    apply_home_manager(user, repo_dir, dry_run=args.dry_run)

    # 6. Set shell
    current += 1
    step(current, steps, f"Setting default shell ({args.shell})")
    setup_shell(args.shell, user, dry_run=args.dry_run)

    # 7. Configure Rust
    current += 1
    step(current, steps, "Configuring Rust")
    configure_rust()

    # 8. Install Neovim (optional)
    if args.install_neovim:
        current += 1
        step(current, steps, "Installing Neovim")
        install_neovim(dry_run=args.dry_run)

    print(f"\n{BOLD}{GREEN}{'=' * 50}{RESET}")
    print(f"{BOLD}{GREEN}  ✓ Installation complete!{RESET}")
    print(f"{BOLD}{GREEN}{'=' * 50}{RESET}")
    print(f"\n  {YELLOW}Note:{RESET} You may need to log out and back in for")
    print("  all changes to take effect.\n")


if __name__ == "__main__":
    main()
