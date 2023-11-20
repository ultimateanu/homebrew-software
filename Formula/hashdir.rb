class Hashdir < Formula
  desc "Command-line utility to checksum directories and files"
  homepage "https://ultimateanu.github.io/hashdir/"
  url "https://github.com/ultimateanu/hashdir/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "36fad59153a387ba0592ae0f62d1006b788a9f4155240400f1cf9be2c844790b"
  license "MIT"

  depends_on "dotnet"

  def install
    system "dotnet", "publish",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet"].version.major_minor}",
           "--output", "out",
           "src/App/App.fsproj"

    libexec.install Dir["out/*"]

    (bin/"hashdir").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet"].opt_bin}/dotnet" "#{libexec}/hashdir.dll" "$@"
    EOS
  end

  test do
    (testpath/"test.txt").write <<~EOS
      hello world
    EOS

    assert_match Formula["hashdir"].version.to_s, shell_output("#{bin}/hashdir --version")
    assert_match "22596363b3de40b06f981fb85d82312e8c0ed511", shell_output("#{bin}/hashdir #{testpath}/test.txt")
  end
end
