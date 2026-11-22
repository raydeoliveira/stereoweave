# Security Policy — StereoWeave

## Reporting a Vulnerability
Report security vulnerabilities privately via GitHub Security Advisories on `https://github.com/raydeoliveira/stereoweave`.

## Security & Hardware Safety Model
- **Zero external dependencies**: Compiled strictly against Apple macOS system frameworks (`Foundation`, `CoreGraphics`, `IOKit`, `Metal`, `AVFoundation`, `VideoToolbox`, `ImageIO`, `CryptoKit`).
- **Zero telemetry**: StereoWeave makes zero network calls during normal operation. The only outbound HTTPS request occurs when explicitly running `stereoweave license activate --key <KEY>` against `https://api.polar.sh/v1/customer-portal/license-keys/validate`.
- **No silent privilege escalation**: `edid apply` never spawns `sudo` or modifies `/Library/Displays/Contents/Resources/Overrides` without explicit user execution and `--confirm-timeout` auto-revert rollback (or explicit `--yes`).
- **Path traversal & plist validation**: Override paths validate hex vendor/product IDs and parse plist bytes before writing to disk; existing files are snapshotted to a companion backup and restored automatically on timeout, error, `SIGINT`, or `SIGTERM`.
