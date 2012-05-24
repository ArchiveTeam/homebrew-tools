require 'formula'

class WgetLua < Formula
  homepage 'https://github.com/alard/wget-lua'
  url 'https://github.com/downloads/ArchiveTeam/tabblo-grab/wget-lua-20120522b.tar.gz'
  md5 'd98cca1c6dc57d0dbc99522f97e774b8'
  version '20120522'
end

class Tabblo < Formula
  homepage 'http://archiveteam.org/index.php?title=Tabblo'
  url 'https://github.com/ArchiveTeam/tabblo-grab.git',
    :revision => 'b41f211c51e1ad69bb47f7655885ec0b62913113'
  version 'b41f211'

  depends_on "openssl" if MacOS.leopard?
  depends_on "lua"
  depends_on "coreutils" # bsd du doesn't cut it

  keg_only "This is so that downloaded data is not placed in your #{HOMEBREW_PREFIX}."

  def install
    WgetLua.new.brew do
      args = ["--disable-debug",
              "--prefix=#{prefix}",
              "--sysconfdir=#{etc}",
              "--with-ssl=openssl"]

      args << "--disable-iri"

      system "./configure", *args
      system "make"

      prefix.install "src/wget" => "wget-warc-lua"
    end

    # we don't need this, we're building separately
    rm "get-wget-warc-lua.sh"

    prefix.install Dir['*']
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