# Polar.sh Product Listing — StereoWeave Pro (macOS Apple Silicon)

> Use this copy directly when creating the StereoWeave Pro product in your Polar.sh dashboard (`polar.sh`).
> Enable Polar's built-in **License Keys** benefit (prefix: `SW3D`, activation limit: `3` machines per buyer, expiration: never / perpetual).

---

## Product Title
**StereoWeave Pro — 3D Display EDID Unlock, Metal Stereo Weaver & MV-HEVC Converter (macOS)**

## Price & Billing Model
- **$29 USD** — One-time purchase (Perpetual License, v0.x updates included, up to 3 personal Macs).
- **Free Core Tier** available in the exact same 630 KB binary so buyers can run `probe`, `edid inspect`, `edid budget`, `edid patch --dry-run`, `weave --out-layout dubois-anaglyph`, and read-only MCP tools before buying.

## Tagline (1-sentence summary)
Fix locked 3D modes and blurry YCbCr text on macOS external displays, weave 8 stereo/lenticular formats on Apple Silicon Metal, and convert Apple MV-HEVC Spatial Video without FFmpeg — in one 630 KB native CLI + MCP server.

## Storefront Description

macOS on Apple Silicon routinely hides `3840x1080` Full-SBS modes on AR glasses, drops external 4K OLEDs into blurry YCbCr 4:2:0 subsampling, omits HDMI 1.4 3D Frame Packing flags for projectors, and locks iPhone / Vision Pro MV-HEVC Spatial Videos inside Apple's ecosystem.

**StereoWeave** solves all four from one **645 KB** zero-dependency native Apple Silicon binary (7.9 ms cold start, zero Python, zero FFmpeg, zero Electron, zero background telemetry).

### What Is Included in Pro ($29 Perpetual)
- **Link-Budget-Verified EDID Patcher (`edid patch`)**: Synthesize checksum-valid VESA EDID 1.4 / CTA-861 binaries and macOS `DisplayOverride` plists for:
  - `full-sbs-1080p` / `full-sbs-1080p-120` (`3840x1080` CVT-RB2 for AR glasses & 3D monitors)
  - `force-rgb444` (strips YCbCr 4:4:4 / 4:2:2 / 4:2:0 blocks to restore crisp RGB 4:4:4 text on 4K OLEDs)
  - `hdmi-3d-framepack` (injects HDMI 1.4 VSDB 3D Frame Packing, TAB, and SBS-Half flags for 3D projectors/TVs)
- **Snapshot + Auto-Revert Override Installer (`edid apply`)**: Validates every EDID checksum before touching disk, snapshots existing overrides, verifies byte-for-byte readback, and auto-reverts automatically if you don't confirm within `--confirm-timeout` seconds or press `Ctrl-C` (`SIGINT`/`SIGTERM`).
- **Apple Silicon Metal GPU Stereo & Lenticular Weaver (`weave`)**: Runtime-compiled Metal compute shaders for Full-SBS, Half-SBS (2x horizontal unsqueeze), Top-and-Bottom, Row/Column Interlaced, Checkerboard, Slanted Subpixel Lenticular (`--lens-pitch`, `--lens-slant`, `--lens-phase`), Dubois Anaglyph, and RGB-D Depth-Image-Based Rendering (DIBR).
- **Hardware VideoToolbox MV-HEVC Spatial Video Transcoder (`convert`)**: Bidirectional Apple MV-HEVC Spatial Video <-> Full-SBS / Half-SBS / TAB / Lenticular / Interlaced / Anaglyph `.mov` conversion with audio pass-through.
- **Built-in AI Agent MCP Server (`stereoweave mcp`)**: Zero-dependency JSON-RPC 2.0 stdio server + `--json` + `--describe` ready for Claude Code, Codex, Cursor, and Antigravity.

### Free Core vs. Pro Comparison

| Feature | Free Core | Pro ($29 one-time) |
|---|---|---|
| `probe` (live CoreGraphics + IOKit display audit) | Included | Included |
| `edid inspect` (VESA EDID 1.4 / CTA-861 / HDMI 3D / DisplayID 2.x) | Included | Included |
| `edid budget` (CVT-RB2 & HDMI/DP/USB-C bandwidth solver) | Included | Included |
| `edid patch --dry-run` (preview changes & checksums) | Included | Included |
| `edid restore` (instant rollback to prior state) | Included | Included |
| `weave --out-layout dubois-anaglyph` | Included | Included |
| `edid patch` binary & macOS override plist write | — | Included |
| `edid apply` safe installer with timed auto-revert | — | Included |
| `weave` Full-SBS, Half-SBS, TAB, Interlaced, Checkerboard, Lenticular, RGB-D DIBR | — | Included |
| `convert` hardware VideoToolbox MV-HEVC Spatial Video <-> 3D video | — | Included |
| `mcp` write/convert tools | Read-only | Full |

### Requirements & Honest Limits
- **OS & Hardware**: macOS 14.0+ on Apple Silicon (`arm64` — M1/M2/M3/M4).
- **Permissions**: Writing system overrides under `/Library/Displays/Contents/Resources/Overrides` requires `sudo` and reconnecting the display (or rebooting) for WindowServer to reload. No SIP disabling or kernel extensions required.
- **Activation & Privacy**: License key activates once via Polar.sh (`stereoweave license activate --key <KEY>`), caches locally with `0600` permissions and 14-day offline grace, and makes zero background network calls.
- **Hardware Verification Note**: All EDID codecs, link budgets, rollback triggers, Metal GPU pixel outputs, and VideoToolbox MV-HEVC <-> Full-SBS video round-trips are verified by automated tests on Apple Silicon hardware. Because external 3D monitors, AR glasses, and USB-C hubs vary across firmware revisions, test with `--dry-run` and `edid budget` first; a 14-day refund policy applies if your specific display hardware rejects overrides.

---

## Seller Launch Checklist (5 Minutes on Polar.sh)
1. Create organization `raydeoliveira` on `polar.sh` (or set `STEREOWEAVE_POLAR_ORG_ID` / rebuild with your Polar Organization UUID).
2. Create product **StereoWeave Pro** ($29 one-time).
3. Attach Benefit 1 (**Downloadables**): upload `dist/stereoweave-0.1.0-macos-arm64.tar.gz` and `dist/SHA256SUMS.txt`.
4. Attach Benefit 2 (**License Keys**): prefix `SW3D`, max `3` activations, no expiration.
5. (Optional for Gatekeeper warning-free installs): Export Apple Developer ID cert & run `CODESIGN_IDENTITY="Developer ID Application: ..." NOTARY_PROFILE="notarytool-profile" bash scripts/package_release.sh`.
