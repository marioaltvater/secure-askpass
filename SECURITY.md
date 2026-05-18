# Security Notes

`secure-askpass` is designed for convenience on trusted Linux VMs where agents
regularly need `sudo`.

## What It Protects

- The stored sudo password is encrypted with `age`.
- The age recipient is an Ed25519 or RSA SSH public key.
- The stored file is `~/.sudo_askpass.age` with `0600` permissions.
- The askpass script refuses calls where `SUDO_ASKPASS` points somewhere else.
- The immediate parent process must be `sudo` or `sudo.ws`.
- Stored credentials expire after the configured number of hours.
- Approval events are written to syslog and to
  `~/.config/secure-askpass/audit.log`.

## What It Does Not Protect

- It does not prove which agent originally ran `sudo`; askpass sees `sudo` as
  its parent.
- It does not make an untrusted VM safe. A user account that can run arbitrary
  code can still attempt to invoke `sudo -A`.
- It does not support ECDSA or DSA SSH keys for encryption.

## Recommended Defaults

Keep GNOME confirmation enabled on desktop systems. On headless VMs, use the
TOTP flow or set a short expiration period. Set `expiration_hours` to `"never"`
only on machines where persistent encrypted sudo storage is acceptable.

Per-machine config overrides the repo config:

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

## Monitoring

```bash
sudo journalctl -t sudo-askpass -f
./askpass-manager audit
```

## Testing

```bash
./askpass-manager doctor
./askpass-manager test
./agent-sudo whoami
```
