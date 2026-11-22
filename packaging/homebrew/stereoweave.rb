class Stereoweave < Formula
  desc "Spatial 3D display EDID unlock, Metal stereo/lenticular weaver, MV-HEVC converter & MCP server"
  homepage "https://github.com/raydeoliveira/stereoweave"
  version "0.1.0"
  license :cannot_represent

  depends_on arch: :arm64
  depends_on macos: :sonoma

  url "https://github.com/raydeoliveira/stereoweave/releases/download/v0.1.0/stereoweave-0.1.0-macos-arm64.tar.gz"
  sha256 "dc6e66732e96eae0c30e4ad4967e67141ae419a0b1660e5a435ee6f9c65cc8ac"

  def install
    bin.install "stereoweave"
    doc.install "README.md", "LICENSE", "SECURITY.md", "SKILL.md", "server.json"
  end

  test do
    assert_match "stereoweave 0.1.0", shell_output("#{bin}/stereoweave --version")
    describe_json = shell_output("#{bin}/stereoweave --describe")
    assert_match "\"schema_version\":1", describe_json
    assert_match "XREAL Air/One", shell_output("#{bin}/stereoweave edid inspect --fixture xreal-ar-glasses")
  end
end
