# Homebrew formula for csi，由 .github/workflows/release.yml 的 tap job 渲染并推送到
# ximing/homebrew-csi。占位符：0.7.2 / ca3309713fdd071c7f9f92ace71c53b9d0318f519f14e241ba791130713fcfeb / 4c686e1e9054fcf131975cdb7e4a155951302c8f13ef0c38624c5aea89a2f6cb /
# 692ac5b068acdedd7d9e2dee31605056c039a014d3660d68787d807c6d915e2b / 17c384433f845b4d47aa6d4c30b21d5f0dbcd592ebe396f19427f577bc942761。手工改动请改本文件，不要直接改 tap 仓库。
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
  version "0.7.2"

  on_macos do
    on_arm do
      url "https://github.com/ximing/csi/releases/download/v0.7.2/csi-darwin-arm64.tar.gz"
      sha256 "ca3309713fdd071c7f9f92ace71c53b9d0318f519f14e241ba791130713fcfeb"
    end
    on_intel do
      url "https://github.com/ximing/csi/releases/download/v0.7.2/csi-darwin-amd64.tar.gz"
      sha256 "4c686e1e9054fcf131975cdb7e4a155951302c8f13ef0c38624c5aea89a2f6cb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ximing/csi/releases/download/v0.7.2/csi-linux-arm64.tar.gz"
      sha256 "692ac5b068acdedd7d9e2dee31605056c039a014d3660d68787d807c6d915e2b"
    end
    on_intel do
      url "https://github.com/ximing/csi/releases/download/v0.7.2/csi-linux-amd64.tar.gz"
      sha256 "17c384433f845b4d47aa6d4c30b21d5f0dbcd592ebe396f19427f577bc942761"
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
