#!/usr/bin/env python3
"""Install script for Nix dotfiles.
Usage:
    python3 install.py                        # Full install
    python3 install.py --shell fish           # Use fish as default shell
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

RST = "\033[0m"
BOLD = "\033[1m"
RED = "\033[31m"
GRN = "\033[32m"
YEL = "\033[33m"
BLU = "\033[34m"
CYN = "\033[36m"
_msg_count = 0


def _print(color: str, icon: str, msg: str, **kwargs) -> None:
    print(f"{color}{icon}{RST} {msg}", **kwargs)


def info(msg: str) -> None:
    _print(BLU, "→", msg)


def ok(msg: str) -> None:
    _print(GRN, "✓", msg)


def warn(msg: str) -> None:
    _print(YEL, "!", msg)


def fail(msg: str) -> None:
    _print(RED, "✗", msg, file=sys.stderr)


def step(msg: str) -> None:
    global _msg_count
    _msg_count += 1
    print(f"\n{BOLD}{CYN}[{_msg_count}]{RST} {BOLD}{msg}{RST}")


def run(cmd: str, *, dry_run: bool = False) -> None:
    info(f"$ {cmd}")
    if dry_run:
        return
    try:
        subprocess.run(cmd, shell=True, check=True)
    except subprocess.CalledProcessError:
        fail(f"Command failed: {cmd}")
        sys.exit(1)


def has(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def get_user() -> str:
    return (
        os.getenv("USER")
        or os.getenv("LOGNAME")
        or subprocess.run(
            ["whoami"], capture_output=True, text=True, check=True
        ).stdout.strip()
    )


def is_systemd() -> bool:
    return Path("/run/systemd/system").exists()


def nix_daemon_running() -> bool:
    socket = Path("/nix/var/nix/daemon-socket/socket")
    if socket.exists():
        try:
            if stat.S_ISSOCK(socket.stat().st_mode):
                return True
        except OSError:
            pass
    return (
        subprocess.run(
            "pgrep -x nix-daemon", shell=True, capture_output=True
        ).returncode
        == 0
    )


DEPS = {
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
}
DISTRO_MAP = {"pop": "ubuntu"}


def detect_distro() -> str:
    os_release = Path("/etc/os-release")
    if not os_release.exists():
        fail("Cannot detect distro: /etc/os-release not found")
        sys.exit(1)
    for line in os_release.read_text().splitlines():
        if line.startswith("ID="):
            raw = line.split("=", 1)[1].strip().strip('"')
            name = DISTRO_MAP.get(raw, raw)
            if name in DEPS:
                return name
            fail(f"Unsupported distro: {raw} (supported: {', '.join(DEPS)})")
            sys.exit(1)
    fail("Cannot detect distro: ID not found in /etc/os-release")
    sys.exit(1)


def install_deps(distro: str, dry_run: bool = False) -> None:
    deps = " ".join(DEPS[distro])
    if distro == "ubuntu":
        run("sudo apt-get update -qq", dry_run=dry_run)
        run(f"sudo apt-get install -yqq {deps}", dry_run=dry_run)
    elif distro == "fedora":
        run(f"sudo dnf install -yq {deps}", dry_run=dry_run)
    ok("System dependencies installed")


def install_nix(dry_run: bool = False) -> None:
    if has("nix"):
        ok("Nix already installed")
        return
    info("Installing Nix via Determinate Systems installer...")
    init = "" if is_systemd() else "linux --init none"
    run(
        "curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix -o /tmp/nix-installer",
        dry_run=dry_run,
    )
    run("chmod +x /tmp/nix-installer", dry_run=dry_run)
    run(f"/tmp/nix-installer install {init} --no-confirm", dry_run=dry_run)
    run("rm -f /tmp/nix-installer", dry_run=dry_run)
    nix_bin = "/nix/var/nix/profiles/default/bin"
    if Path(nix_bin).exists():
        os.environ["PATH"] = f"{nix_bin}:{os.environ['PATH']}"
    ok("Nix installed")


def merge_nix_conf(conf: Path, lines: list[str]) -> None:
    """Merge key=value lines into nix.conf, updating existing keys."""
    existing = conf.read_text().splitlines() if conf.exists() else []
    keys = {}
    for i, line in enumerate(existing):
        s = line.strip()
        if s and not s.startswith("#"):
            key = s.split("=")[0].strip() if "=" in s else s.split()[0]
            keys[key] = i
    for new in lines:
        key = new.split("=")[0].strip() if "=" in new else new.split()[0]
        if key in keys:
            existing[keys[key]] = new
        else:
            existing.append(new)
    conf.parent.mkdir(parents=True, exist_ok=True)
    conf.write_text("\n".join(existing) + "\n")
    info(f"Updated {conf}")


def configure_nix_daemon(user: str, dry_run: bool = False) -> None:
    conf = Path("/etc/nix/nix.conf")
    if not dry_run:
        merge_nix_conf(
            conf,
            [
                f"trusted-users = root {user}",
                "experimental-features = nix-command flakes",
            ],
        )
    if not dry_run and nix_daemon_running():
        ok("nix-daemon already running")
        return
    run("sudo /nix/var/nix/profiles/default/bin/nix-daemon &", dry_run=dry_run)
    socket = "/nix/var/nix/daemon-socket/socket"
    info("Waiting for nix-daemon...")
    if not dry_run:
        for i in range(1, 31):
            if os.path.exists(socket):
                try:
                    if stat.S_ISSOCK(os.stat(socket).st_mode):
                        ok("nix-daemon is running")
                        return
                except OSError:
                    pass
            time.sleep(1)
        fail("nix-daemon did not start after 30s")
        sys.exit(1)


def apply_home_manager(user: str, repo: Path, dry_run: bool = False) -> None:
    info(f"Applying Home Manager for '{user}'...")
    run(
        f"USER={user} nix shell nixpkgs#home-manager -c home-manager switch --flake {repo}#{user}",
        dry_run=dry_run,
    )
    ok("Home Manager applied")


def setup_shell(shell: str, user: str, dry_run: bool = False) -> None:
    paths = {
        "bash": "/bin/bash",
        "zsh": f"{Path.home()}/.nix-profile/bin/zsh",
        "fish": f"{Path.home()}/.nix-profile/bin/fish",
    }
    sh_path = paths.get(shell)
    if not sh_path:
        fail(f"Unknown shell: {shell}")
        return
    if not dry_run:
        try:
            shells = Path("/etc/shells").read_text()
        except PermissionError:
            fail("Cannot read /etc/shells (try with sudo)")
            return
        if sh_path not in shells:
            info(f"Adding '{sh_path}' to /etc/shells")
            run(f"echo '{sh_path}' | sudo tee -a /etc/shells", dry_run=dry_run)
    if os.environ.get("SHELL") != sh_path:
        info(f"Setting {shell} as default shell")
        run(f"sudo usermod -s '{sh_path}' {user}", dry_run=dry_run)
    else:
        info(f"{shell} is already the default shell")


def install_fisher(dry_run: bool = False) -> None:
    info("Installing Fisher...")
    run(
        'fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; fisher install jorgebucaran/fisher"',
        dry_run=dry_run,
    )
    run('fish -c "fisher install kidonng/zoxide.fish"', dry_run=dry_run)


def install_starship(dry_run: bool = False) -> None:
    info("Installing Starship...")
    run(
        "curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null",
        dry_run=dry_run,
    )
    config = Path.home() / ".config" / "starship.toml"
    config.parent.mkdir(parents=True, exist_ok=True)
    run(
        f"PATH={Path.home()}/.nix-profile/bin:$PATH starship preset nerd-font-symbols -o {config}",
        dry_run=dry_run,
    )


def configure_rust() -> None:
    if not has("rustup"):
        warn("rustup not found, skipping")
        return
    info("Setting Rust to stable...")
    run("rustup default stable")
    ok("Rust set to stable")


def install_neovim(dry_run: bool = False) -> None:
    nvim = Path("/usr/local/bin/nvim")
    if nvim.exists() and not dry_run:
        try:
            r = subprocess.run(
                [str(nvim), "--version"], capture_output=True, text=True, timeout=5
            )
            if r.returncode == 0:
                ok(f"Neovim installed: {r.stdout.splitlines()[0]}")
                return
        except (subprocess.TimeoutExpired, FileNotFoundError, IndexError):
            pass
    info("Installing Neovim...")
    if nvim.exists():
        run(f"sudo rm -f {nvim}", dry_run=dry_run)
    run(
        f"sudo curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage -o {nvim}",
        dry_run=dry_run,
    )
    run(f"sudo chmod +x {nvim}", dry_run=dry_run)
    ok("Neovim installed")


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Install Nix dotfiles environment")
    p.add_argument(
        "--shell",
        choices=["bash", "zsh", "fish"],
        default="fish",
        help="Default shell (default: fish)",
    )
    p.add_argument("--skip-nix", action="store_true", help="Skip Nix installation")
    p.add_argument(
        "--skip-deps", action="store_true", help="Skip system dependency installation"
    )
    p.add_argument("--install-neovim", action="store_true", help="Also install Neovim")
    p.add_argument(
        "--dry-run", action="store_true", help="Preview without making changes"
    )
    return p.parse_args()


def main() -> None:
    args = parse_args()
    user = get_user()
    repo = Path(__file__).parent.resolve()
    systemd = is_systemd()
    print(f"\n{BOLD}{'=' * 50}{RST}")
    print(f"{BOLD}  Nix Dotfiles Installer{RST}")
    print(f"{BOLD}{'=' * 50}{RST}")
    print(f"  User:    {user}")
    print(f"  Shell:   {args.shell}")
    print(f"  Systemd: {'yes' if systemd else 'no'}")
    if args.dry_run:
        print(f"  {YEL}DRY RUN — no changes will be made{RST}")
    print(f"{BOLD}{'=' * 50}{RST}\n")
    step("Detecting distribution")
    distro = detect_distro()
    ok(f"Detected: {distro}")
    if not args.skip_deps:
        step("Installing system dependencies")
        install_deps(distro, dry_run=args.dry_run)
    if not args.skip_nix:
        step("Installing Nix")
        install_nix(dry_run=args.dry_run)
        if not systemd:
            step("Configuring Nix daemon")
            configure_nix_daemon(user, dry_run=args.dry_run)
    step("Applying Home Manager")
    apply_home_manager(user, repo, dry_run=args.dry_run)
    step(f"Setting default shell ({args.shell})")
    setup_shell(args.shell, user, dry_run=args.dry_run)
    if args.shell == "fish":
        install_fisher(dry_run=args.dry_run)
    install_starship(dry_run=args.dry_run)
    step("Configuring Rust")
    configure_rust()
    if args.install_neovim:
        step("Installing Neovim")
        install_neovim(dry_run=args.dry_run)
    print(f"\n{BOLD}{GRN}{'=' * 50}{RST}")
    print(f"{BOLD}{GRN}  ✓ Installation complete!{RST}")
    print(f"{BOLD}{GRN}{'=' * 50}{RST}")
    print(
        f"\n  {YEL}Note:{RST} You may need to log out and back in for all changes to take effect.\n"
    )


if __name__ == "__main__":
    main()
