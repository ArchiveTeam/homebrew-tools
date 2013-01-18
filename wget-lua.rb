require 'formula'

class WgetLua < Formula
  homepage 'https://github.com/alard/wget-lua'
  url 'https://github.com/alard/wget-lua.git',
    :revision => '959e5d1e90f4ac515418f1ada9852bb14fe11c11'
  version '20120920'
  head 'https://github.com/alard/wget-lua.git', :branch => 'lua'

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :libtool => :build
  depends_on "gettext"
  depends_on "openssl" if MacOS.version < 10.6
  depends_on "libidn" if build.include? "enable-iri"
  depends_on "lua"

  option 'enable-iri', 'Enable iri support.'

  def install
    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--with-ssl=openssl",
            # don't clobber standard wget
            "--program-suffix=-lua"]

    args << "--disable-iri" unless build.include? "enable-iri"

    system "./bootstrap"
    system "./configure", *args
    system "make"

    bin.install "src/wget" => "wget-lua"
  end

  def caveats
    <<-EOS.undent
    This only provides the wget-warc-lua tool. If you're looking to
    run one of the Archive Team projects, look at the other formulae
    in this repository.
    EOS
  end

  def test
    system "#{bin}/wget-lua", "-O", "-", "www.google.com"
  end
end
