class Hashdir < Formula
  desc "Command-line utility to checksum directories and files"
  homepage "https://ultimateanu.github.io/hashdir/"
  url "https://github.com/ultimateanu/hashdir/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "9a9335d99a7938155505cd2abe08c4be970abcbaa0ac90cf4bebf9cb0d6d633c"
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
