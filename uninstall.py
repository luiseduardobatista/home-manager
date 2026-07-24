#!/usr/bin/env python3
"""Uninstall script for Nix dotfiles.
Reverts changes made by install.py.

Usage:
    python3 uninstall.py                    # Full uninstall (dry-run by default removed, use --dry-run)
    python3 uninstall.py --dry-run          # Preview without making changes
    python3 uninstall.py --remove-deps      # Also remove system dependencies
"""

import argparse
import os
import shutil
import subprocess
import sys
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


def check_sudo() -> None:
    """Check if sudo is available (non-interactive)."""
    result = subprocess.run(
        ["sudo", "-n", "true"], capture_output=True
    )
    if result.returncode != 0:
        fail("This script requires sudo. Please run with sudo or configure sudoers.")
        sys.exit(1)


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


def remove_neovim(dry_run: bool = False) -> None:
    """Remove Neovim AppImage if installed."""
    nvim = Path("/usr/local/bin/nvim")
    if not nvim.exists():
        info("Neovim AppImage not found, skipping")
        return
    info(f"Removing Neovim AppImage: {nvim}")
    run(f"sudo rm -f {nvim}", dry_run=dry_run)
    ok("Neovim removed")


def remove_fisher(dry_run: bool = False) -> None:
    """Remove Fisher and its plugins."""
    fish_config = Path.home() / ".config" / "fish"
    fisher_config = Path.home() / ".config" / "fisher"
    fisher_data = Path.home() / ".local" / "share" / "fisher"
    fisher_func = fish_config / "functions" / "fisher.fish"
    fish_plugins = fish_config / "fish_plugins"

    if not any(
        p.exists() for p in [fisher_func, fish_plugins, fisher_config, fisher_data]
    ):
        info("Fisher not found, skipping")
        return

    info("Removing Fisher and plugins...")
    # Remove fisher function and plugin list
    if fisher_func.exists():
        run(f"rm -f {fisher_func}", dry_run=dry_run)
    if fish_plugins.exists():
        run(f"rm -f {fish_plugins}", dry_run=dry_run)
    # Remove fisher config and data directories
    if fisher_config.exists():
        run(f"rm -rf {fisher_config}", dry_run=dry_run)
    if fisher_data.exists():
        run(f"rm -rf {fisher_data}", dry_run=dry_run)
    ok("Fisher removed")


def remove_starship(dry_run: bool = False) -> None:
    """Remove Starship config and binary."""
    config = Path.home() / ".config" / "starship.toml"
    if config.exists():
        info(f"Removing Starship config: {config}")
        run(f"rm -f {config}", dry_run=dry_run)
        ok("Starship config removed")
    else:
        info("Starship config not found, skipping")

    # Check common install location first, then fallback to which
    starship_bin = Path("/usr/local/bin/starship")
    if not starship_bin.exists():
        which_result = shutil.which("starship")
        if which_result:
            starship_bin = Path(which_result)

    if starship_bin.exists():
        info(f"Removing Starship binary: {starship_bin}")
        run(f"sudo rm -f {starship_bin}", dry_run=dry_run)
        ok("Starship binary removed")
    else:
        info("Starship binary not found, skipping")


def cleanup_home_manager(dry_run: bool = False) -> None:
    """Remove Home Manager artifacts."""
    paths = [
        Path.home() / ".nix-profile",
        Path.home() / ".nix-channels",
        Path.home() / ".nix-defexpr",
        Path.home() / ".config" / "home-manager",
        Path.home() / ".local" / "state" / "nix",
        Path.home() / ".local" / "state" / "home-manager",
    ]

    found = [p for p in paths if p.exists()]
    if not found:
        info("No Home Manager artifacts found, skipping")
        return

    info("Removing Home Manager artifacts...")
    for p in found:
        run(f"rm -rf {p}", dry_run=dry_run)
    ok("Home Manager artifacts removed")


def cleanup_shell(dry_run: bool = False) -> None:
    """Remove nix entries from /etc/shells."""
    shells_file = Path("/etc/shells")
    if not shells_file.exists():
        info("/etc/shells not found, skipping")
        return

    try:
        lines = shells_file.read_text().splitlines()
    except PermissionError:
        fail("Cannot read /etc/shells (try with sudo)")
        return

    # Filter out lines containing nix references
    nix_patterns = ["/nix/", "nix-profile"]
    cleaned = []
    removed = []
    for line in lines:
        if any(pattern in line for pattern in nix_patterns):
            removed.append(line)
        else:
            cleaned.append(line)

    if not removed:
        info("No nix entries found in /etc/shells")
        return

    info(f"Removing {len(removed)} nix entries from /etc/shells:")
    for entry in removed:
        info(f"  {entry}")

    if not dry_run:
        shells_file.write_text("\n".join(cleaned) + "\n")

    warn("Shell default was NOT reverted. To change it, run:")
    warn("  chsh -s /bin/bash  # or /bin/zsh, etc.")
    ok("Nix entries removed from /etc/shells")


def uninstall_nix(dry_run: bool = False) -> None:
    """Uninstall Nix using Determinate Systems uninstaller."""
    nix_installer = Path("/nix/nix-installer")
    if not nix_installer.exists():
        warn("Nix installer not found at /nix/nix-installer")
        warn("Nix may have been installed differently or is already removed")
        warn("Manual cleanup may be needed for /nix/ and related files")
        return

    info("Uninstalling Nix via Determinate Systems uninstaller...")
    run(f"{nix_installer} uninstall --no-confirm", dry_run=dry_run)
    ok("Nix uninstalled")


def remove_deps(distro: str, dry_run: bool = False) -> None:
    """Remove system dependencies (opt-in)."""
    deps = DEPS.get(distro, [])
    if not deps:
        return

    info(f"Would remove the following packages ({distro}):")
    for dep in deps:
        info(f"  {dep}")

    if dry_run:
        return

    confirm = input(f"\n{YEL}Remove these packages? [y/N]: {RST}").strip().lower()
    if confirm != "y":
        info("Skipping package removal")
        return

    pkg_list = " ".join(deps)
    if distro == "ubuntu":
        run("sudo apt-get update -qq", dry_run=dry_run)
        run(f"sudo apt-get remove -yqq {pkg_list}", dry_run=dry_run)
    elif distro == "fedora":
        run(f"sudo dnf remove -yq {pkg_list}", dry_run=dry_run)
    ok("System dependencies removed")


def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Uninstall Nix dotfiles environment")
    p.add_argument(
        "--dry-run", action="store_true", help="Preview without making changes"
    )
    p.add_argument(
        "--remove-deps",
        action="store_true",
        help="Also remove system dependencies (requires confirmation)",
    )
    return p.parse_args()


def main() -> None:
    args = parse_args()
    user = get_user()
    systemd = is_systemd()

    print(f"\n{BOLD}{'=' * 50}{RST}")
    print(f"{BOLD}  Nix Dotfiles Uninstaller{RST}")
    print(f"{BOLD}{'=' * 50}{RST}")
    print(f"  User:    {user}")
    print(f"  Systemd: {'yes' if systemd else 'no'}")
    if args.dry_run:
        print(f"  {YEL}DRY RUN — no changes will be made{RST}")
    print(f"{BOLD}{'=' * 50}{RST}\n")

    if not args.dry_run:
        check_sudo()

    step("Detecting distribution")
    distro = detect_distro()
    ok(f"Detected: {distro}")

    step("Removing Neovim")
    remove_neovim(dry_run=args.dry_run)

    step("Removing Fisher")
    remove_fisher(dry_run=args.dry_run)

    step("Removing Starship")
    remove_starship(dry_run=args.dry_run)

    step("Cleaning up Home Manager")
    cleanup_home_manager(dry_run=args.dry_run)

    step("Cleaning up shell entries")
    cleanup_shell(dry_run=args.dry_run)

    step("Uninstalling Nix")
    uninstall_nix(dry_run=args.dry_run)

    if args.remove_deps:
        step("Removing system dependencies")
        remove_deps(distro, dry_run=args.dry_run)
    else:
        step("System dependencies")
        info("The following packages were installed by install.py:")
        for dep in DEPS.get(distro, []):
            info(f"  {dep}")
        warn("Use --remove-deps to remove them (requires confirmation)")

    print(f"\n{BOLD}{GRN}{'=' * 50}{RST}")
    print(f"{BOLD}{GRN}  ✓ Uninstallation complete!{RST}")
    print(f"{BOLD}{GRN}{'=' * 50}{RST}")
    print(
        f"\n  {YEL}Note:{RST} You may need to log out and back in for all changes to take effect."
    )
    print(f"  {YEL}Note:{RST} Run 'chsh -s /bin/bash' to restore default shell if needed.\n")


if __name__ == "__main__":
    main()
