class WgetLua < Formula
  desc "lua-scriptable fork of wget"
  homepage "https://github.com/alard/wget-lua"
  url "https://github.com/alard/wget-lua.git",
    :revision => "dc1aeae4d7ae9adb0fd1a296af71e119da6426b1"
  version "20151217"
  head "https://github.com/alard/wget-lua.git", :branch => "lua"

  deprecated_option "enable-iri" => "with-iri"

  option "with-iri", "Enable iri support."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xz" => :build
  depends_on "gettext"
  depends_on "openssl"
  depends_on "libidn" if build.with? "iri"
  depends_on "lua51"

  def install
    ENV.append_to_cflags "-I#{Formula["lua51"].include}/lua-5.1"

    args = ["--disable-debug",
            "--prefix=#{prefix}",
            "--sysconfdir=#{etc}",
            "--with-ssl=openssl",
            # don't clobber standard wget
            "--program-suffix=-lua"]

    args << "--disable-iri" if build.without? "iri"

    system "./bootstrap"
    system "./configure", *args
    inreplace %w[Makefile lib/Makefile src/Makefile tests/Makefile util/Makefile], "-llua", "-llua5.1"
    system "make"

    bin.install "src/wget" => "wget-lua"
  end

  def caveats
    <<-EOS.undent
    This only provides the wget-lua tool. If you're looking to
    run one of the Archive Team projects, try the Warrior:
      http://archive.org/details/archiveteam-warrior
    EOS
  end

  test do
    system "#{bin}/wget-lua", "-O", "-", "www.google.com"
  end
end
