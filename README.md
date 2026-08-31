# homebrew-csi

[csi](https://github.com/ximing/csi) 的 Homebrew tap —— 让 AI 控制你真实的 Chrome 浏览器（带真实登录态）。

## 安装

```bash
brew tap ximing/csi
brew install csi
brew services start csi
```

`brew services` 会以 KeepAlive 托管 `csi serve`。停止 / 重启请用
`brew services stop|restart csi`，不要直接 `csi stop`。

Chrome 扩展请从 Chrome 商店安装（见主仓库 README）。

## 更新

```bash
brew update && brew upgrade csi
```

Formula 由 [ximing/csi](https://github.com/ximing/csi) 的 release workflow 自动更新，请勿在此仓库手工修改 `Formula/csi.rb`。
