# SSH Askpass Helper

Secure askpass helper for agent-friendly `sudo -A` usage on Linux VMs.

The normal agent workflow is:

```bash
./askpass-manager doctor
./askpass-manager set
./agent-sudo whoami
```

`agent-sudo` is a tiny wrapper that sets `SUDO_ASKPASS` to this checkout's
`askpass` script and then runs `sudo -A`.

## Requirements

- Linux with `sudo` askpass support
- `age`
- An SSH keypair supported by age: Ed25519 or RSA
- GNOME with GTK4/libadwaita for the graphical confirmation dialog

Install `age` with your distro package manager:

```bash
sudo apt install age      # Debian/Ubuntu
sudo dnf install age      # Fedora
sudo pacman -S age        # Arch
```

If you do not have a supported SSH key yet:

```bash
ssh-keygen -t ed25519
```

## Setup

```bash
./setup.sh
./askpass-manager set
./askpass-manager test
```

For shell-wide use, add this to your shell profile:

```bash
export SUDO_ASKPASS="/path/to/secure-askpass/askpass"
alias agent-sudo="/path/to/secure-askpass/agent-sudo"
```

## Commands

```bash
./askpass-manager doctor     # Check prerequisites without invoking sudo
./askpass-manager set        # Store sudo password
./askpass-manager get        # Check whether a password is stored
./askpass-manager clear      # Remove stored password and legacy files
./askpass-manager test       # Force a fresh sudo auth through askpass
./askpass-manager audit      # Show recent askpass approvals
```

Headless setup is available when you want a TOTP confirmation path:

```bash
./askpass-manager totp-setup
./askpass-manager set-totp
TOTP="123456" sudo -A command
```

## Security Model

- The sudo password is stored in `~/.sudo_askpass.age` with `0600`
  permissions.
- The password file is encrypted with age using your Ed25519 or RSA SSH public
  key.
- The helper validates that `SUDO_ASKPASS` points at this script.
- The helper validates that the immediate caller is `sudo` or `sudo.ws`.
- Stored passwords expire after `expiration_hours` and are removed on the next
  askpass invocation. Set `expiration_hours` to `"never"` to disable expiration.
- GNOME confirmation is enabled by default. Headless sessions can use TOTP.
- Attempts and approvals are logged to syslog and
  `~/.config/secure-askpass/audit.log`.

Per-machine config lives at `~/.config/secure-askpass/config.json` and overrides
the repo default `askpass-config.json`.

Example:

```json
{
  "require_user_confirmation": false,
  "allowed_paths": ["/"],
  "expiration_hours": "never",
  "sudo_parent_processes": ["sudo", "sudo.ws"],
  "max_attempts_per_hour": 30,
  "lockout_minutes": 15
}
```

## sudo-rs Note

If your system uses `sudo-rs`, askpass may not be supported. Use `sudo.ws` as
the sudo alternative:

```bash
sudo update-alternatives --install /usr/bin/sudo sudo /usr/bin/sudo.ws 100
sudo update-alternatives --config sudo
```
