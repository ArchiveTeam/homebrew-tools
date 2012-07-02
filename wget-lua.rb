require 'formula'

class WgetLua < Formula
  homepage 'https://github.com/alard/wget-lua'
  url 'https://github.com/downloads/ArchiveTeam/picplz-grab/wget-lua-20120602.tar.gz'
  sha1 'ab42c26e38c25b70839e7d768094736033e4b3c3'
  version '20120602'

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
    This only provides the wget-warc-lua tool. If you're looking to
    run one of the Archive Team projects, look at the other formulae
    in this repository.
    EOS
  end

  def test
    system "#{bin}/wget-warc-lua", "-O", "-", "www.google.com"
  end
end
