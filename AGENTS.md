@RTK.md

--- project-doc ---

# SSH Askpass Helper Project Guidelines

## Project Overview

This is an SSH askpass helper for agent-friendly sudo access on Linux VMs. The
project consists of:

- `askpass` - Primary askpass script
- `askpass-manager` - Management utility for the askpass service
- `agent-sudo` - Convenience wrapper that sets `SUDO_ASKPASS` and runs `sudo -A`

## Development Guidelines

1. **Tool Usage**:
   - Use `bash` commands directly for basic operations
   - Use parallel command execution when reading independent files

2. **Code Style**:
   - Follow existing conventions in the askpass scripts
   - Keep scripts minimal and focused on single responsibilities
   - No unnecessary comments unless explicitly requested

3. **Testing**:
   - Test `askpass`, `askpass-manager`, and `agent-sudo`
   - Verify age encryption/decryption with Ed25519 or RSA SSH keys
   - Ensure secure password handling

4. **Security**:
   - Never log or expose passwords in plain text
   - Verify SSH key and encrypted password file permissions
   - Follow secure coding practices for password handling

5. **Commits**:
   - Only commit when explicitly requested
   - Follow existing commit style from git history
