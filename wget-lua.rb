require 'formula'

class WgetLua < Formula
  homepage 'https://github.com/alard/wget-lua'
  url 'https://github.com/downloads/ArchiveTeam/tabblo-grab/wget-lua-20120522b.tar.gz'
  md5 'd98cca1c6dc57d0dbc99522f97e774b8'
  version '20120522'

  depends_on "openssl" if MacOS.leopard?
  depends_on "libidn" if ARGV.include? "--enable-iri"
  depends_on "lua"

  def options
    [["--enable-iri", "Enable iri support."]]
  end

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--with-ssl=openssl",
            # don't clobber standard wget
            "--program-suffix=-warc-lua"]

    args << "--disable-iri" unless ARGV.include? "--enable-iri"

    system "./configure", *args
    system "make"

    bin.install "src/wget" => "wget-warc-lua"
  end

  def caveats
    <<-EOS.undent
    The Tabblo seesaw.sh script looks for wget-warc-lua in the
    working directory; you may need to tweak it so it can find
    the Homebrew-provided version.
    EOS
  end

  def test
    system "#{bin}/wget-warc-lua", "-O", "-", "www.google.com"
  end
end
