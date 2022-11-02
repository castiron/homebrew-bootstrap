class Ciclaunchdns < Formula
  desc "Mini DNS server designed solely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.4.tar.gz"
  sha256 "60f6010659407e3d148c021c88e1c1ce0924de320e99a5c58b21c8aece3888aa"
  license "MIT"
  revision 2
  head "https://github.com/josh/launchdns.git", branch: "master"

  depends_on :macos # uses launchd, a component of macOS

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix/"etc/resolver/localhost").write <<~EOS
      nameserver 127.0.0.1
      port 55353
    EOS

    (prefix/"etc/resolver/lvh").write <<~EOS
      nameserver 127.0.0.1
      port 55353
    EOS

  end

  service do
    run [opt_bin/"launchdns", "--port=55353"]
    error_log_path var/"log/launchdns.log"
    log_path var/"log/launchdns.log"
  end

  test do
    output = shell_output("#{bin}/launchdns --version")
    refute_match(/without socket activation/, output)
    system bin/"launchdns", "-p0", "-t1"
  end
end
