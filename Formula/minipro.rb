class Minipro < Formula
  desc "Open controller for the MiniPRO TL866xx series of chip programmers"
  homepage "https://gitlab.com/DavidGriffith/minipro/"
  url "https://gitlab.com/DavidGriffith/minipro/-/archive/0.5/minipro-0.5.tar.gz"
  sha256 "1c7559fd45c5cfc1d83cd0dfe2dd132cb621afbd113ab18dec1b5e6832f7121d"
  license "GPL-3.0"

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "srecord"
  
  def install
    system "make", "CC=clang"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{share}", "install"
  end
  
  test do
    output_minipro = shell_output("#{bin}/minipro 2>&1")
    assert_match "minipro version #{version}", output_minipro
    output_miniprohex = shell_output("#{bin}/miniprohex 2>&1")
    assert_match "miniprohex by Al Williams", output_miniprohex

    output_minipro_read_nonexistent = shell_output("#{bin}/minipro -p \"ST21C325@DIP7\" -b 2>&1", 1)
    if (!output_minipro_read_nonexistent.include? "Device ST21C325@DIP7 not found!") &&
       (!output_minipro_read_nonexistent.include? "Error opening device")
      raise "Error validating minipro device database."
    end
  end
end
