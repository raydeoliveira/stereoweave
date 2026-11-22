---
name: stereoweave
description: >-
  Unlocks 3D display modes, AR glasses Full-SBS 3840x1080 timings, RGB 4:4:4 OLED fixes,
  Apple Silicon Metal stereo/lenticular weaving, and bidirectional Apple MV-HEVC Spatial Video
  transcoding via the `stereoweave` CLI and built-in MCP server on macOS. Use when diagnosing
  external displays, solving HDMI/DP/USB-C link budgets, patching EDID overrides safely, or
  converting 3D/spatial images and videos.
---

# Skill: StereoWeave (`stereoweave`)

## Install
```bash
brew install raydeoliveira/tap/stereoweave
# Or verify capability manifest directly:
stereoweave --describe
```

## Safe Display & EDID Workflow
1. Always probe first (read-only):
   ```bash
   stereoweave probe --json
   stereoweave edid inspect --fixture xreal-ar-glasses --json
   ```
2. Verify physical link bandwidth before patching:
   ```bash
   stereoweave edid budget --width 3840 --height 1080 --hz 60 --bpc 8 --chroma 444 --link usbc-2lane --json
   ```
3. Dry-run EDID patch before writing files:
   ```bash
   stereoweave edid patch --fixture xreal-ar-glasses --preset full-sbs-1080p --dry-run --json
   ```
4. Apply with mandatory snapshot + 15s auto-revert watchdog (never pass `--yes` blindly on an untested physical display):
   ```bash
   stereoweave edid apply override.plist --display-vendor 3a6c --display-product 0574 --confirm-timeout 15 --json
   ```
5. Restore prior state at any time (always free, zero license required):
   ```bash
   stereoweave edid restore --display-vendor 3a6c --display-product 0574 --json
   ```

## Spatial 3D Media & Metal GPU Weaving
- Convert Apple MV-HEVC Spatial Video -> Full-SBS 3840x1080 for AR glasses:
  ```bash
  stereoweave convert --input spatial.mov --in-layout mv-hevc --out-layout full-sbs --output glasses_sbs.mov --json
  ```
- Weave stereo pair or RGB-D depth frame into lenticular, interlaced, SBS, TAB, or Dubois anaglyph:
  ```bash
  stereoweave weave --input frame_sbs.png --in-layout full-sbs --out-layout lenticular --lens-pitch 4.5 --lens-slant 0.3333 --output woven.png --json
  ```

## Native MCP Mode
Run `stereoweave mcp` over stdio (JSON-RPC 2.0) to call `probe_displays`, `inspect_edid`, `solve_link_budget`, `patch_edid`, `weave_frame`, and `convert_spatial_media`.

## Exit Codes
- `0` ok | `1` runtime/rollback | `2` usage/validation/bandwidth | `3` hardware unavailable | `4` permission/symlink denied | `5` Pro license required (`stereoweave license activate --key <KEY>`) | `130` interrupted after automatic rollback cleanup
