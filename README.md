# ClawRocket 🦞

> 统一版本 Shadowrocket 配置 —— 简单、高效、智能

---

## 简介

ClawRocket 是一个专为 Shadowrocket 设计的规则配置生成工具，提供**标准版**和**Pro去广告版**两种配置方案，满足不同用户的网络代理需求。

### 核心特点
- 🎯 **统一版本**：告别多版本混乱，一个项目解决所有需求
- 🚀 **智能生成**：自动整合多源规则，保持配置最新
- 📱 **双平台**：支持 iPhone 和 Mac 双版本
- 🔔 **实时通知**：生成成功/失败均推送 Bark 通知

---

## 版本对比

| 特性 | 标准版 | Pro版 |
|------|--------|-------|
| 基础代理规则 | ✅ | ✅ |
| 国内外分流 | ✅ | ✅ |
| 去广告规则 | ❌ | ✅ |
| 隐私保护规则 | ❌ | ✅ |
| MitM 证书配置 | ❌ | ⚠️ 需手动配置 |
| 推荐用户 | 普通用户 | 高级用户 |

### 版本说明

**标准版**
- 适合大多数用户
- 开箱即用，无需额外配置
- 稳定的代理体验

**Pro版**
- 适合追求极致体验的用户
- 包含广告拦截和隐私保护
- ⚠️ **需要配置 MitM 证书**（见下方警告）

---

## 使用方法

### 方式一：手动下载

1. 访问 GitHub Releases 页面
2. 下载最新版本的 `.conf` 配置文件
3. 导入 Shadowrocket

### 方式二：CDN 订阅（推荐）

通过 CDN 链接直接订阅，手动更新：

```
https://cdn.jsdelivr.net/gh/unclevv/ClawRocket@main/output/ClawRocket.conf
```

**⚠️ 重要提示**：本项目采用**手动触发更新**，非自动更新。建议按需手动刷新配置。

---

## iPhone 导入方法

### 步骤 1：下载配置
[截图占位：下载配置文件]

### 步骤 2：导入 Shadowrocket
1. 打开 Shadowrocket 应用
2. 点击右上角 **+** 添加配置
3. 选择 **从 URL 添加** 或 **从文件导入**
4. 粘贴 CDN 链接或选择下载的 `.conf` 文件

[截图占位：Shadowrocket 导入界面]

### 步骤 3：启用配置
1. 选择导入的配置
2. 点击连接按钮
3. 完成！

[截图占位：连接成功界面]

---

## 配置说明

### 标准版配置
- **DNS**：自动选择最优 DNS（iPhone 版使用 DoH）
- **分流规则**：国内直连，国外代理
- **更新方式**：手动触发更新

### Pro版配置
- **DNS**：增强隐私保护 DNS
- **分流规则**：国内直连，国外代理 + 广告拦截
- **MitM**：需要安装并信任证书
- **更新方式**：手动触发更新

---

## ⚠️ Pro版 MitM 配置警告

Pro版包含广告拦截功能，需要启用 **MitM（中间人攻击）** 来解密 HTTPS 流量。

### 风险提示
1. **证书信任**：需要安装并信任 ClawRocket 生成的证书
2. **隐私考虑**：MitM 会解密你的 HTTPS 流量
3. **设备限制**：某些应用可能无法正常工作

### 配置步骤
1. 下载 MitM 证书（首次使用 Pro版时脚本会生成）
2. 在 iPhone **设置 → 通用 → VPN与设备管理** 中安装证书
3. 在 **设置 → 通用 → 关于本机 → 证书信任设置** 中启用完全信任
4. 返回 Shadowrocket，开启 MitM 开关

**建议**：仅在必要时使用 Pro版，标准版已能满足大多数需求。

---

## 链接

| 类型 | 链接 |
|------|------|
| **GitHub** | https://github.com/unclevv/ClawRocket |
| **标准版 CDN** | `https://cdn.jsdelivr.net/gh/unclevv/ClawRocket@main/output/ClawRocket.conf` |
| **Pro版 CDN** | `https://cdn.jsdelivr.net/gh/unclevv/ClawRocket@main/output/ClawRocket-AD.conf` |
| **Issues** | https://github.com/unclevv/ClawRocket/issues |

---

## 技术细节

### 规则来源
ClawRocket 整合以下优质规则源：
- **ACL4SSR**：国内外分流规则
- **dnsmasq-china-list**：国内域名白名单
- **AdGuard DNS**：广告拦截规则
- **自定义规则**：针对特定服务的优化规则

### 更新频率
- **规则源**：每日自动检查更新
- **配置文件**：手动触发生成
- **版本发布**：按需发布

### 手动触发方式

```bash
# 生成 iPhone 版配置
./scripts/generate_clawrules_iphone_v2.sh

# 生成 Mac 版配置
./scripts/generate_clawrules_mac_v2.sh

# 生成 Pro版配置（带广告拦截）
./scripts/generate_clawrules_iphone_ad_enhanced.sh
```

---

## 项目结构

```
ClawRocket/
├── scripts/              # 规则生成脚本
│   ├── generate_clawrules_iphone_v2.sh    # iPhone版生成脚本
│   ├── generate_clawrules_mac_v2.sh       # Mac版生成脚本
│   └── generate_clawrules_iphone_ad_enhanced.sh  # Pro版生成脚本
├── output/               # 生成的配置文件
│   ├── ClawRocket.conf           # 标准版配置
│   ├── ClawRocket-AD.conf        # Pro去广告版配置
│   └── ...
├── cache/                # 规则缓存
│   ├── acl4ssr/          # ACL4SSR规则缓存
│   ├── dnsmasq-china/    # 国内DNS规则缓存
│   └── adblock/          # 广告规则缓存
└── logs/                 # 生成日志
```

---

## 更新日志

### v1.0.0 (2026-03-18)
- 🎉 初始版本发布
- ✅ 支持标准版和 Pro去广告版
- ✅ iPhone 和 Mac 双平台支持
- ✅ CDN 订阅支持
- ✅ Bark 通知集成
- ✅ 本地缓存机制

---

## 许可证

MIT License

---

**Made with 🦐 by Clawbaby**
