class Raine < Formula
  desc "680x0 arcade emulator"
  homepage "http://raine.1emulation.com/"
  url "https://github.com/zelurker/raine/archive/0.64.10.tar.gz"
  sha256 "d25fdc705828d4dde5bf6734da799ea6f1986ee7e1996ac29db537047a8d3eac"
  head "https://github.com/zelurker/raine.git"

  bottle do
    cellar :any
    sha256 "959bf845d5eba202ee4e3ffcf465a6f754a56382f8d0c44a66ff7437211f6ade" => :el_capitan
    sha256 "1e5d5a1890a5502083eb22775af1382d2749d1b6c9e4855b1c846dc45e064579" => :yosemite
    sha256 "44f7c3153be208b8000a5288a92d41c236dcf34a6872bdfc9f0716f3fbd60b17" => :mavericks
  end

  # Fix str(n)cpy source/target overlap issue
  patch do
    url "https://github.com/zelurker/raine/commit/f5e835b8dc253e0eb70d7756f3578960c4fcf09e.diff"
    sha256 "764e0fdc80b0bc3e24654f5cedd6fd6183105ff6c1c0ca3a73561366954cb435"
  end

  depends_on "gettext" => "universal"
  depends_on "libpng" => "universal"
  depends_on "sdl" => "universal"
  depends_on "sdl_image" => "universal"
  depends_on "sdl_sound" => ["universal", "with-flac", "with-libogg", "with-libvorbis"]
  depends_on "sdl_ttf" => "universal"
  depends_on "muparser" => "universal"
  depends_on "nasm" => :build

  depends_on "flac" => "universal" # for sdl_sound
  depends_on "freetype" => "universal" # for sdl_ttf
  depends_on "xz" => "universal" # for sdl_sound, etc.

  def install
    ENV.m32
    inreplace "makefile" do |s|
      s.gsub! /-framework (SDL|SDL_image|SDL_ttf)/, "-l\\1"
      s.gsub! %r{/usr/local/lib/libSDL_sound\.a}, "-lSDL_sound"
      s.gsub! %r{/usr/local/lib/libintl\.a}, "-lintl"
      s.gsub! %r{/usr/local/lib/libmuparser\.a}, "-lmuparser"
    end
    system "make"
    system "make", "install"
    prefix.install "Raine.app"
    bin.write_exec_script "#{prefix}/Raine.app/Contents/MacOS/raine"
  end

  test do
    assert_match /RAINE \(680x0 Arcade Emulation\) #{version} /, shell_output("#{bin}/raine -n")
  end
end
