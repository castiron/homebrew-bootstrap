class PhpBuild < Formula
  desc "Install various PHP versions and implementations"
  homepage "https://github.com/php-build/php-build"
  url "https://github.com/php-build/php-build", :using => :git, :revision => "a18e89205ae6b316773befbe1ca19ab1a3790141"
  head "https://github.com/php-build/php-build.git"
  version "1.4"

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
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/php-build --definitions")
  end
end
