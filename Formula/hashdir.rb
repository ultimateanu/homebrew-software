class Hashdir < Formula
  desc "Command-line utility to checksum directories and files"
  homepage "https://ultimateanu.github.io/hashdir/"
  url "https://github.com/ultimateanu/hashdir/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "02a9fb260bf60a1c5c671ad26ae1ba8566977ebaddf6d04f518fe6163ace6f6b"
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
    assert_match "d42f7ed4b73c6bde", shell_output("#{bin}/hashdir #{testpath}/test.txt")
  end
end
