class PhpBuild < Formula
  desc "Install various PHP versions and implementations"
  homepage "https://github.com/php-build/php-build"
  url "https://github.com/php-build/php-build", :using => :git, :revision => "8cc8307ef3ec5196ba756c854345a143609f48da"
  head "https://github.com/php-build/php-build.git"

  bottle :unneeded

  depends_on "autoconf" => :recommended
  depends_on "pkg-config" => :recommended
  depends_on "openssl" => :recommended
  depends_on "re2c" => :recommended
  depends_on "bison" => :recommended
  depends_on "libxml2" => :recommended
  depends_on "icu4c" => :recommended
  depends_on "mcrypt" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
    # WTF WHY.
    rm_f "#{bin}/rbenv-install"
    rm_f "#{bin}/rbenv-uninstall"
    rm_f "#{bin}/rbenv-update"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/php-build --definitions")
  end
end
