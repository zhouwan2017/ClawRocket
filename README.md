# ClawRocket 规则集 🦞

ClawRocket 是一个模块化的 Shadowrocket 规则集，支持标准版和 AD 版两种配置。

## 规则结构

| 文件 | 说明 | 条数 |
|------|------|------|
| 01-dns.conf | DNS 配置和 MitM 设置 | ~10 |
| 02-reject.conf | 广告拦截（REJECT） | ~500 |
| 03-direct.conf | 国内直连（白名单） | ~2000 |
| 04-proxy.conf | 代理规则 | ~50 |
| 05-final.conf | 托底规则 | 2 |

## 目录结构

```
ClawRocket/
├── rules/                    # 子规则集
│   ├── 01-dns.conf          # DNS 配置
│   ├── 02-reject.conf       # 广告拦截
│   ├── 03-direct.conf       # 国内直连
│   ├── 04-proxy.conf        # 代理规则
│   └── 05-final.conf        # 托底规则
├── scripts/
│   ├── build.sh             # 构建脚本
│   ├── test.sh              # 规则验证
│   ├── push.sh              # 推送 GitHub+CDN 刷新
│   └── stats.sh             # 规则统计
├── output/                   # 生成的配置
│   ├── ClawRocket.conf      # 标准版
│   └── ClawRocket-AD.conf   # AD 版（REJECT 前置）
├── CHANGELOG.md             # 变更日志
└── README.md                # 本文件
```

## 构建

```bash
cd "/Users/unclevv/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/ClawRocket/scripts"
chmod +x *.sh
./build.sh
./test.sh
./push.sh
```

## 订阅链接

- **标准版**：https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/output/ClawRocket.conf
- **AD 版**：https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/output/ClawRocket-AD.conf

## 版本说明

- **标准版**：无广告拦截规则，适合不需要去广告的用户
- **AD 版**：包含完整的广告拦截规则（REJECT 前置），优先匹配广告域名

## 特性

- ✅ 模块化设计，易于维护和扩展
- ✅ REJECT 规则前置，确保广告优先拦截
- ✅ 完整的国内网站白名单（2000+ 域名）
- ✅ 水利/政府网站强制直连
- ✅ 银行网站直连保护
- ✅ 国内外大模型智能分流
- ✅ MitM 增强去广告

## 更新日志

参见 [CHANGELOG.md](./CHANGELOG.md)

---

**GitHub**: https://github.com/zhouwan2017/ClawRocket  
**维护者**: Uncle VV 🦐
