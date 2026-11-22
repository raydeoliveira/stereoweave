# StereoWeave

Native Apple Silicon macOS CLI and MCP server that audits and patches VESA EDID 1.4 / CTA-861 display overrides for 3D monitors, AR glasses, 3D projectors, and 4K OLEDs, weaves stereo/lenticular frames on Metal, and converts Apple MV-HEVC Spatial Video bidirectionally via VideoToolbox — in a single **645 KB** zero-dependency binary.

## Measured Footprint

Measured on Apple M4 Max (`arm64-apple-macos14.0`, Swift 6.4.2):

| Metric | Measured Value |
|---|---|
| Stripped binary (`arm64`) | `645,216 bytes` (`630 KB`) |
| Compressed release tarball | `253,290 bytes` (`247 KB`, includes binary + docs + MCP manifest) |
| External dependencies | `0` (Apple system frameworks only; no FFmpeg, no Python) |
| Cold-start `--version` latency (15 runs) | `7.90 ms` median (`7.18–9.10 ms`) |
| Automated test suite (16 tests) | `1.07 s` (includes live Metal GPU & VideoToolbox MV-HEVC) |

## What It Does / What It Does Not Do

| Capability | Status | Tier |
|---|---|---|
| Live macOS CoreGraphics + IOKit display/EDID probe (`probe`) | Included | Free |
| VESA EDID 1.4, CTA-861, HDMI 3D VSDB & DisplayID 2.x inspection (`edid inspect`) | Included | Free |
| VESA CVT-RB2 timing synthesis & HDMI/DP/USB-C link-budget solver (`edid budget`) | Included | Free |
| Dry-run EDID patch preview & checksum verification (`edid patch --dry-run`) | Included | Free |
| Dubois color-preserving Red/Cyan anaglyph Metal preview (`weave --out-layout dubois-anaglyph`) | Included | Free |
| Immediate override rollback (`edid restore`) | Included | Free |
| Read-only stdio MCP server (`probe_displays`, `inspect_edid`, `solve_link_budget`, dry-run `patch_edid`) | Included | Free |
| Surgical EDID binary + macOS DisplayOverride plist export (`full-sbs-1080p`, `full-sbs-1080p-120`, `force-rgb444`, `hdmi-3d-framepack`) | Included | Pro ($29) |
| Snapshot + timed auto-revert + `SIGINT`/`SIGTERM` rollback override installer (`edid apply`) | Included | Pro ($29) |
| Full Metal GPU weaver (Full-SBS, Half-SBS unsqueeze, TAB, Row/Col Interlaced, Checkerboard, Slanted Subpixel Lenticular, RGB-D DIBR) | Included | Pro ($29) |
| Bidirectional hardware VideoToolbox MV-HEVC Spatial Video <-> 3D stereo video transcoding with audio pass-through (`convert`) | Included | Pro ($29) |

**Explicit Non-Goals & Current Verification Limits:**
- **macOS Apple Silicon (`arm64`, macOS 14+) only.** Windows and Linux binaries are not built in v0.1.0.
- **No kernel extensions, SIP disabling, or game-engine DLL injection.** Display overrides use Apple's standard `/Library/Displays/Contents/Resources/Overrides` plist path (requires `sudo` when targeting the system directory, and display reconnect or reboot for WindowServer reload).
- **Hardware testing disclosure:** CoreGraphics/IOKit probing, Metal GPU pixel-oracle rendering across all 8 layouts + RGB-D DIBR, VideoToolbox bidirectional MV-HEVC <-> Full-SBS transcoding, symlink/signal rollback, and loopback HTTP Polar.sh licensing were all executed and verified on real Apple M4 Max hardware. Physical external AR glasses (XREAL/VITURE/Rokid), lenticular monitors (Samsung Odyssey 3D / Acer SpatialLabs), and 3D projectors have **not** yet been visually verified on physical units — EDID transformations are verified against VESA EDID 1.4 / CTA-861 binary fixtures and strict checksum re-parsing.

## Install & Uninstall

### From Release Tarball
```bash
tar -xzf stereoweave-0.1.0-macos-arm64.tar.gz
shasum -a 256 -c SHA256SUMS.txt
install -m 755 stereoweave-0.1.0-macos-arm64/stereoweave /usr/local/bin/stereoweave
stereoweave --version
```

### Build From Source (Swift 6, macOS 14+)
```bash
swift test

# Open-Source Edition build (all features unlocked offline, zero network calls):
```

### Uninstall
```bash
rm -f /usr/local/bin/stereoweave
rm -rf ~/.config/stereoweave
# If you installed a system display override, restore it first:
sudo stereoweave edid restore --display-vendor <hex> --display-product <hex>
```

## Quick Start

### 1. Probe Connected Displays & Audit an EDID
```bash
stereoweave probe
```
Real output on Apple Silicon MacBook Pro:
```text
Display #1: Built-in Apple Display [0610:a05c] 3024x1964@120.0Hz builtIn=true edid=apple-internal-attributes
```

Inspect a binary EDID file (or one of 4 built-in hardware fixtures: `xreal-ar-glasses`, `odyssey-3d-lenticular`, `lg-oled-ycbcr420`, `projector-hdmi-3d`):
```bash
stereoweave edid inspect --fixture xreal-ar-glasses
```
Real output:
```text
Display: XREAL Air/One (NRL 3a4c:0574) EDID 1.4 [256B, checksums=true]
  Timing (base-dtd-0): 1920x1080@60.0Hz (133320 kHz)
  [!] No HDMI VSDB 3D structures advertised (fix for 3D projectors/TVs: `--preset hdmi-3d-framepack`).
  [!] No Full-SBS 3840x1080 timing advertised (fix for AR glasses / 3D displays: `--preset full-sbs-1080p`).
```

### 2. Verify Physical Cable Link Budget Before Patching
```bash
stereoweave edid budget --width 3840 --height 1080 --hz 60 --link usbc-4lane
```
Real output:
```text
Timing: 3840x1080@60.0Hz (261310 kHz) | PASS: 6.27 Gbps fits within usbc-4lane ceiling (25.92 Gbps, 24.2% load).
```

Check an impossible link in machine-readable `--json` mode:
```bash
stereoweave edid budget --width 3840 --height 1080 --hz 120 --bpc 10 --link hdmi20 --json
```
Real output:
```json
{"data":{"bitsPerComponent":10,"chroma":"444","dscEnabled":false,"effectiveRequiredGbps":16.144,"fits":false,"link":"hdmi20","linkCapacityGbps":14.4,"recommendation":"FAIL: 16.14 Gbps exceeds hdmi20 ceiling (14.40 Gbps). Lower Hz, use 8bpc, or switch to a 4-lane/FRL6 cable.","requiredGbps":16.144,"timing":{"hBlank":80,"hFrontPorch":8,"hSyncWidth":32,"height":1080,"interlaced":false,"pixelClockKHz":538140,"refreshHz":120,"source":"cvt-rb2","vBlank":64,"vFrontPorch":1,"vSyncWidth":8,"width":3840},"utilizationPercent":112.1},"ok":true,"schema_version":1}
```

### 3. Dry-Run Patch, Metal Weave, MV-HEVC Convert & AI Agent MCP
```bash
# Preview Full-SBS 3840x1080@60Hz EDID patch with checksum verification (Free):
stereoweave edid patch --fixture xreal-ar-glasses --preset full-sbs-1080p --dry-run --json

# Activate Pro license via Polar.sh (validates once, 14-day offline grace, zero telemetry):
stereoweave license activate --key <YOUR_POLAR_KEY>

# Weave stereo image pair into slanted subpixel lenticular output on Metal GPU (Pro):
stereoweave weave --input left.png --right right.png --in-layout pair --out-layout lenticular --lens-pitch 4.5 --lens-slant 0.3333 --output woven.png

# Convert Apple Vision Pro / iPhone MV-HEVC Spatial Video -> Full-SBS for AR glasses (Pro):
stereoweave convert --input spatial.mov --in-layout mv-hevc --out-layout full-sbs --output glasses_sbs.mov

# Start stdio JSON-RPC 2.0 MCP server for Claude Code, Codex, Cursor, or Antigravity:
stereoweave mcp
```

## Safety & Rollback

Every display override mutation enforces the 6-stage safety chain:
1. **Validate**: Parses target plist + embedded `IODisplayEDID` bytes and verifies every 128-byte VESA checksum before touching disk. Refuses symbolic links (`lstat`).
2. **Dry-Run**: Pass `--dry-run` to validate without writing any file.
3. **Non-TTY Guard**: Refuses to mutate disk when stdin is not an interactive TTY unless `--yes` is explicitly supplied.
4. **Snapshot**: Copies any existing override file atomically to `~/.config/stereoweave/snapshots/` (or `--snapshot-dir`) before overwriting.
5. **Timed + Signal-Safe Auto-Revert**: Writes atomically, verifies byte-for-byte readback, then waits `--confirm-timeout` seconds (default `15s`) for `y` + Enter. If the screen goes blank, the timer expires, or `SIGINT`/`SIGTERM` (`Ctrl-C`) arrives, StereoWeave immediately restores the prior file (or deletes the new override if none existed).
6. **Instant Manual Restore**: `stereoweave edid restore --display-vendor <hex> --display-product <hex>` is always unlocked on the Free tier.

## Exit Codes & CLI Contract

Every command accepts `--json` and emits `{"schema_version":1,"ok":true|false,"data":...,"error":...}` to `stdout` (diagnostics only on `stderr`). Run `stereoweave --describe` for the full machine-readable capability manifest or `stereoweave --help` for full usage.

| Exit Code | Meaning |
|---|---|
| `0` | Success (`"ok": true`) |
| `1` | Runtime error, media/GPU failure, or auto-rollback triggered |
| `2` | Invalid CLI usage, invalid EDID/checksum, or link bandwidth exceeded on patch |
| `3` | Hardware unavailable (no displays or Metal GPU) |
| `4` | Permission denied, read-only volume, or symbolic link rejected |
| `5` | Pro license required or invalid/expired Polar.sh license key |
| `130` | Interrupted by `SIGINT`/`SIGTERM` after automatic rollback cleanup |

## License & Support

- Commercial binary distribution is licensed under [LICENSE](LICENSE) (Free Core + $29 one-time Perpetual Pro license via Polar.sh, valid for up to 3 personal Macs, offline-capable with zero telemetry).
- Security & vulnerability disclosure: [SECURITY.md](SECURITY.md).
- AI Agent integration docs: [SKILL.md](SKILL.md) and [server.json](server.json).

## Install (Commercial Free Core + Pro $29)

```bash
brew tap raydeoliveira/tap
brew install stereoweave
```

- **MCP Clients (One-Click `.mcpb`)**: Download `stereoweave-0.1.0-macos-arm64.mcpb` from [GitHub Releases](https://github.com/raydeoliveira/stereoweave/releases/tag/v0.1.0).
- **Pro License ($29, or $49 Complete 4-Tool Spatial Wedge Bundle)**: Purchase at [https://polar.sh/raymond-de-oliveira](https://polar.sh/raymond-de-oliveira) and activate via `stereoweave license activate --key <YOUR-KEY>`.
- **Distribution Notice**: This public repository hosts official documentation, AI-agent `SKILL.md` / `server.json` manifests, and signed commercial release archives. Source code is maintained privately.
