# Homebrew formula for csi，由 .github/workflows/release.yml 的 tap job 渲染并推送到
# ximing/homebrew-csi。占位符：0.6.0 / 5f84570f9ffbc0bb2e5aa5452771b0759488f7f5b1e675019fe4ee31c64150cb / a1b14ba12fd95d8f35c6cb451fadcf7a58822c00f7777b9a01038e8017a9bcb1 /
# 85a630b2415ff18c4167cc4a5149d46d19fcf375e9a7c73dd67fb3c2b6b53010 / 5a2395f31b0f97860f49326cc1b73369ae7bc25c8a7f567cd27977995ed11f27。手工改动请改本文件，不要直接改 tap 仓库。
#
# 注意：这是个人 tap 的二进制 formula（直接装 Release 预编译包，不走源码构建）。
# 将来若向 homebrew-core 投稿，需另写源码构建版本（见 docs/superpowers/specs/
# 2026-08-31-homebrew-agpl-design.md）。
#
# TODO(AGPL)：许可证切换到 AGPL-3.0-only 的首个 tag 起，加回 license 行：
#   license "AGPL-3.0-only"
class Csi < Formula
  desc "Let AI control your real Chrome browser via a local daemon"
  homepage "https://github.com/ximing/csi"
  version "0.6.0"

  on_macos do
    on_arm do
      url "https://github.com/ximing/csi/releases/download/v0.6.0/csi-darwin-arm64.tar.gz"
      sha256 "5f84570f9ffbc0bb2e5aa5452771b0759488f7f5b1e675019fe4ee31c64150cb"
    end
    on_intel do
      url "https://github.com/ximing/csi/releases/download/v0.6.0/csi-darwin-amd64.tar.gz"
      sha256 "a1b14ba12fd95d8f35c6cb451fadcf7a58822c00f7777b9a01038e8017a9bcb1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ximing/csi/releases/download/v0.6.0/csi-linux-arm64.tar.gz"
      sha256 "85a630b2415ff18c4167cc4a5149d46d19fcf375e9a7c73dd67fb3c2b6b53010"
    end
    on_intel do
      url "https://github.com/ximing/csi/releases/download/v0.6.0/csi-linux-amd64.tar.gz"
      sha256 "5a2395f31b0f97860f49326cc1b73369ae7bc25c8a7f567cd27977995ed11f27"
    end
  end

  def install
    bin.install "csi"
  end

  service do
    run [opt_bin/"csi", "serve"]
    keep_alive true
    environment_variables CSI_BREW_SERVICE: "1"
    log_path var/"log/csi.log"
    error_log_path var/"log/csi.log"
  end

  def caveats
    <<~EOS
      启动 daemon（现在 + 登录保活）：
        brew services start csi

      停止 / 重启请用 `brew services stop|restart csi`——KeepAlive 会把
      `csi stop` 杀掉的进程拉回来，CLI 也会拒绝。

      Chrome 扩展：从 Chrome 商店安装，或 sideload ~/.csi/extension。

      如果本机以前用过 curl 安装器，先停掉旧进程再启动，避免抢 10088 端口：
        csi stop   （或 ~/.csi/bin/csi stop）
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/csi version")
  end
end
