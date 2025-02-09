class Hashdir < Formula
  desc "Command-line utility to checksum directories and files"
  homepage "https://ultimateanu.github.io/hashdir/"
  url "https://github.com/ultimateanu/hashdir/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "14104fca1c31e342f62a4fe76493bd1d509555df498271aefd4692da76cf3196"
  license "MIT"

  depends_on "dotnet@8"

  def install
    system "#{Formula["dotnet@8"].opt_bin}/dotnet", "publish",
           "--configuration", "Release",
           "--framework", "net#{Formula["dotnet@8"].version.major_minor}",
           "--output", "out",
           "src/App/App.fsproj"

    libexec.install Dir["out/*"]

    (bin/"hashdir").write <<~EOS
      #!/bin/sh
      exec "#{Formula["dotnet@8"].opt_bin}/dotnet" "#{libexec}/hashdir.dll" "$@"
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
