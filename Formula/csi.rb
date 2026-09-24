# Homebrew formula for csi，由 .github/workflows/release.yml 的 tap job 渲染并推送到
# ximing/homebrew-csi。占位符：0.9.0 / 8f602182d21cc02b8324479307f7040f2185990934b9d976d058317d4e487304 / 2024feada61db14cd9737e5f9ec15fb4bef8f97c6208c24edba6d14c0dd7beaf /
# 267028554477020bbc2e18d09d5bc7e21dc66db2b8b85cf1e466414b67ec2d63 / e7ceb56f395a27665a8f4096c325d708c8a0cfc76132f7d23d9a6328a966a976。手工改动请改本文件，不要直接改 tap 仓库。
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
  version "0.9.0"

  on_macos do
    on_arm do
      url "https://github.com/ximing/csi/releases/download/v0.9.0/csi-darwin-arm64.tar.gz"
      sha256 "8f602182d21cc02b8324479307f7040f2185990934b9d976d058317d4e487304"
    end
    on_intel do
      url "https://github.com/ximing/csi/releases/download/v0.9.0/csi-darwin-amd64.tar.gz"
      sha256 "2024feada61db14cd9737e5f9ec15fb4bef8f97c6208c24edba6d14c0dd7beaf"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ximing/csi/releases/download/v0.9.0/csi-linux-arm64.tar.gz"
      sha256 "267028554477020bbc2e18d09d5bc7e21dc66db2b8b85cf1e466414b67ec2d63"
    end
    on_intel do
      url "https://github.com/ximing/csi/releases/download/v0.9.0/csi-linux-amd64.tar.gz"
      sha256 "e7ceb56f395a27665a8f4096c325d708c8a0cfc76132f7d23d9a6328a966a976"
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
