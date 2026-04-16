# Security Enhancements for SSH Askpass Helper

## Overview
The askpass script uses a native GNOME confirmation dialog and multiple security layers to prevent unauthorized access while keeping sudo prompts usable in a desktop session.

## Security Features

### 1. GNOME Confirmation Dialog
- Shows a native GTK4/libadwaita dialog
- Displays the command being executed, user, and hostname
- Requires explicit user approval for each sudo request
- Follows the active GNOME theme, including dark mode
- Has no fallback to other GUI toolkits in this fork

### 2. Path-based Restrictions
- Only allows execution from trusted directories: `/home/ian/` and `/tmp/`
- Prevents malicious scripts from arbitrary locations accessing passwords

### 3. Time-based Expiration
- Passwords automatically expire after 24 hours
- Expired password files are automatically deleted
- Configurable via `expiration_hours` in config

### 4. Process Validation
- Verifies the calling process is from allowed list: `sudo`, `claude-code`, `code`, `bash`, `sh`
- Prevents unauthorized processes from retrieving passwords

### 5. Environment Verification
- Requires a graphical GNOME session
- Ensures askpass is called from a legitimate user desktop session

### 6. Audit Logging
- All askpass usage is logged to syslog
- Records calling process, PID, command, and working directory
- Failed security checks and user denials are logged with warnings

## Configuration
Security settings can be configured via `askpass-config.json`:
```json
{
    "require_user_confirmation": true,
    "allowed_paths": ["/home/ian/", "/tmp/"],
    "expiration_hours": 24,
    "allowed_processes": ["sudo", "claude-code", "codex", "opencode", "opencode-cli", "code", "bash", "sh"]
}
```

The configuration file is loaded from (in order of priority):
1. `~/.config/secure-askpass/config.json`
2. `./askpass-config.json` (in the same directory as the script)

## Monitoring
Check audit logs with:
```bash
sudo journalctl -t sudo-askpass -f
```

## Testing
Test the setup:
```bash
# From within the project directory
./askpass-manager test
```

## Backup
Original askpass script backed up to: `askpass.backup`
