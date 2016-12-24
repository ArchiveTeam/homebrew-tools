class Tabblo < Formula
  desc "Tool used in the program to download Tabblo content"
  homepage "http://archiveteam.org/index.php?title=Tabblo"
  url "https://github.com/ArchiveTeam/tabblo-grab.git",
    :revision => "b41f211c51e1ad69bb47f7655885ec0b62913113"
  version "b41f211"

  keg_only "This is so that downloaded data is not placed in your #{HOMEBREW_PREFIX}."

  depends_on "openssl"
  depends_on "lua51"
  depends_on "coreutils" # bsd du doesn't cut it

  resource "wget-lua" do
    url "https://github.com/downloads/ArchiveTeam/tabblo-grab/wget-lua-20120522b.tar.gz"
    sha256 "179b48b1285b4afd4d2a3bb6a60cf5b77cb022facf94c0f5d3bd723ecc50f863"
  end

  def install
    resource("wget-lua").stage do
      ENV.append_to_cflags "-I#{Formula["lua51"].include}/lua-5.1"

      args = ["--disable-debug",
              "--prefix=#{prefix}",
              "--sysconfdir=#{etc}",
              "--with-ssl=openssl"]

      args << "--disable-iri"

      system "./configure", *args
      inreplace %w[Makefile lib/Makefile src/Makefile tests/Makefile util/Makefile], "-llua", "-llua5.1"
      system "make"

      prefix.install "src/wget" => "wget-warc-lua"
    end

    # we don't need this, we're building separately
    rm "get-wget-warc-lua.sh"

    prefix.install Dir["*"]
  end

  def caveats
    <<-EOS.undent
    To start downloading, do
      cd `brew --prefix tabblo`
      ./seesaw.sh "<YOURNICK>"

    To stop the script, open a new terminal window to the same directory and run
      touch STOP
    EOS
  end
end
