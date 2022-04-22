class Hashdir < Formula
  desc "Command-line utility to checksum directories and files"
  homepage "https://ultimateanu.github.io/hashdir/"
  url "https://github.com/ultimateanu/hashdir/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e27b08437957a02ea55c62b4837005bd6abea9608a290d67a2b351a16f037a29"
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
