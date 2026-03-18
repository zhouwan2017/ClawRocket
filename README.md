# 🚀 ClawRocket

> Shadowrocket 规则配置生成器 —— 简单、高效、智能

---

## 📋 项目简介

ClawRocket 是一个专为 Shadowrocket 设计的规则配置生成工具，提供**标准版**和**Pro版**两种配置方案，满足不同用户的网络代理需求。

### 版本对比

| 特性 | 标准版 | Pro版 |
|------|--------|-------|
| 基础规则 | ✅ | ✅ |
| 去广告规则 | ❌ | ✅ |
| 高级分流 | ❌ | ✅ |
| 自定义域名 | ❌ | ✅ |

---

## 📁 项目结构

```
ClawRocket/
├── scripts/              # 规则生成脚本
│   ├── generate_clawrules_iphone_v2.sh    # iPhone版生成脚本
│   ├── generate_clawrules_mac_v2.sh       # Mac版生成脚本
│   └── generate_clawrules_iphone_ad_enhanced.sh  # Pro版参考脚本（开发中）
├── output/               # 生成的配置文件
│   ├── ClawRocket.conf           # 标准版配置
│   ├── ClawRocket-AD.conf        # 标准版去广告
│   ├── ClawRocket-Test.conf      # 测试版配置
│   └── ClawRocket-AD-Test.conf   # 测试版去广告
├── cache/                # 规则缓存
│   ├── acl4ssr/          # ACL4SSR规则缓存
│   ├── dnsmasq-china/    # 国内DNS规则缓存
│   └── adblock/          # 广告规则缓存
└── logs/                 # 生成日志
```

---

## 🚀 快速开始

### 生成标准版配置

```bash
# iPhone版（使用 DoH DNS）
./scripts/generate_clawrules_iphone_v2.sh

# Mac版（本地DNS配合AdGuard）
./scripts/generate_clawrules_mac_v2.sh
```

### 输出生成

生成的配置文件将保存在 `output/` 目录，命名格式：
- `🦞CR-i-月日-时分.conf` - iPhone版
- `🦞CR-m-月日-时分.conf` - Mac版

---

## 📖 使用指南

### 标准版使用

1. 运行生成脚本
2. 在 `output/` 目录找到生成的 `.conf` 文件
3. 导入 Shadowrocket

### Pro版使用（开发中）

敬请期待...

---

## 🔧 技术特性

- **双版本支持**：iPhone版 + Mac版
- **网络重试**：3次重试，单次30秒超时
- **本地缓存**：规则缓存加速生成
- **完整规则**：~2300条（自定义+ACL4SSR+dnsmasq-china-list）
- **Bark通知**：成功/失败均推送

---

## 📝 更新日志

### 2026-03-18
- 项目初始化
- 创建基础目录结构
- 迁移现有脚本

---

## 📄 许可证

MIT License

---

**Made with 🦐 by Clawbaby**
