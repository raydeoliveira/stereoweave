# Changelog

All notable changes to StereoWeave are documented in this file.

## [0.1.0] — 2026-11-20

### Added
- **Hardware Display & EDID Inspector**: Live CoreGraphics + IOKit display prober (`probe`), VESA EDID 1.4 / CTA-861 / HDMI 3D VSDB / DisplayID 2.x binary decoder (`edid inspect`), and 4 built-in spec-compliant hardware fixtures (`xreal-ar-glasses`, `odyssey-3d-lenticular`, `lg-oled-ycbcr420`, `projector-hdmi-3d`).
- **CVT-RB2 Timing & Physical Link-Budget Solver**: Deterministic VESA CVT-RB2 generator and physical bandwidth verification across HDMI 1.4/2.0/2.1, DisplayPort 1.2/1.4/2.1, and USB-C 2-lane/4-lane Alt-Mode with DSC checks (`edid budget`).
- **Surgical EDID Patcher & Safe Rollback Installer**: Checksum-verified Full-SBS (`3840x1080@60Hz`, `120Hz`), RGB 4:4:4 YCbCr-strip, and HDMI 1.4 3D VSDB presets (`edid patch`), plus symlink-safe macOS DisplayOverride staging with pre-change snapshot, timed confirmation watchdog, `SIGINT`/`SIGTERM` automatic rollback (`edid apply`), and free-tier `edid restore`.
- **Apple Silicon Metal GPU Stereo & Lenticular Weaver**: Zero-offline-toolchain runtime MSL compute kernels supporting Full-SBS, Half-SBS (with 2x horizontal unsqueeze), TAB, Row/Column Interlaced, Checkerboard, Slanted Subpixel Lenticular optics, Eric Dubois color-preserving anaglyph, and RGB-D depth-image-based rendering (`weave`).
- **Hardware VideoToolbox MV-HEVC Spatial Video Pipeline**: Zero-FFmpeg bidirectional Apple MV-HEVC Spatial Video <-> 3D stereo video converter with audio pass-through and atomic output swapping (`convert`).
- **AI-Agent & Commercial Packaging**: Dual Human + `--json` CLI contract (`schema_version=1`), `--describe` manifest, stdio JSON-RPC 2.0 MCP server (`mcp`), Polar.sh Pro license activation with 14-day offline grace (`license`), `-DOSS_EDITION` compile switch, `SKILL.md`, `server.json`, Homebrew formula, and checksummed macOS arm64 release packaging (`scripts/package_release.sh`).

### Security & QA Hardening
- Passed independent Adversarial QA audit and 16 automated tests covering Metal pixel oracles, VideoToolbox MV-HEVC round-trip pixel verification, DisplayID-first EDID preservation, full-DBC overflow rejection, signal-interrupted rollback, symlink rejection, strict JSON-RPC 2.0 notification handling, and loopback HTTP Polar.sh licensing.
