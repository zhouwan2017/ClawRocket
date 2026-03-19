#!/bin/bash
# 🦞 ClawRocket iCloud 同步脚本
# 将生成的配置文件同步到 iCloud/Clawbaby/配置/ClawRocket/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/output"
LOG_DIR="$PROJECT_DIR/logs"
mkdir -p "$LOG_DIR"

# iCloud 目标目录
ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/07-System/配置/ClawRocket"
mkdir -p "$ICLOUD_DIR"

# 日志
LOG_FILE="$LOG_DIR/icloud-sync-$(date +%Y%m%d-%H%M).log"
log() { echo "$(date '+%H:%M:%S') $1" | tee -a "$LOG_FILE"; }

log "🦞 ClawRocket iCloud 同步脚本"
log "=============================="

# 检查配置文件
log "📋 检查配置文件..."
STANDARD_FILE="$OUTPUT_DIR/ClawRocket.conf"
PRO_FILE="$OUTPUT_DIR/ClawRocket-AD.conf"
STANDARD_TEST="$OUTPUT_DIR/ClawRocket-Test.conf"
PRO_TEST="$OUTPUT_DIR/ClawRocket-AD-Test.conf"

# 复制到 iCloud
log "📤 同步到 iCloud..."

if [ -f "$STANDARD_FILE" ]; then
    cp "$STANDARD_FILE" "$ICLOUD_DIR/"
    log "  ✅ 标准版: $(basename "$STANDARD_FILE")"
fi

if [ -f "$PRO_FILE" ]; then
    cp "$PRO_FILE" "$ICLOUD_DIR/"
    log "  ✅ Pro版: $(basename "$PRO_FILE")"
fi

if [ -f "$STANDARD_TEST" ]; then
    cp "$STANDARD_TEST" "$ICLOUD_DIR/"
    log "  ✅ 标准版测试: $(basename "$STANDARD_TEST")"
fi

if [ -f "$PRO_TEST" ]; then
    cp "$PRO_TEST" "$ICLOUD_DIR/"
    log "  ✅ Pro版测试: $(basename "$PRO_TEST")"
fi

# 同时复制带时间戳的最新版本
LATEST_STANDARD=$(ls -t "$OUTPUT_DIR"/ClawRocket-[0-9]*.conf 2>/dev/null | head -1)
LATEST_PRO=$(ls -t "$OUTPUT_DIR"/ClawRocket-AD-[0-9]*.conf 2>/dev/null | head -1)

if [ -n "$LATEST_STANDARD" ]; then
    cp "$LATEST_STANDARD" "$ICLOUD_DIR/"
    log "  ✅ 最新标准版: $(basename "$LATEST_STANDARD")"
fi

if [ -n "$LATEST_PRO" ]; then
    cp "$LATEST_PRO" "$ICLOUD_DIR/"
    log "  ✅ 最新Pro版: $(basename "$LATEST_PRO")"
fi

# 创建 README
README_FILE="$ICLOUD_DIR/README.md"
cat > "$README_FILE" << 'EOF'
# ClawRocket 配置同步目录

> 自动同步自 ~/.openclaw/workspace/ClawRocket/output/

## 文件说明

| 文件 | 说明 |
|------|------|
| `ClawRocket.conf` | 标准版稳定配置 |
| `ClawRocket-AD.conf` | Pro去广告版稳定配置 |
| `ClawRocket-Test.conf` | 标准版测试配置 |
| `ClawRocket-AD-Test.conf` | Pro版测试配置 |
| `ClawRocket-*.conf` | 带时间戳的历史版本 |

## 使用方式

1. **Shadowrocket 导入**: 直接下载 `.conf` 文件导入
2. **CDN 订阅**: 使用 GitHub CDN 链接自动更新

## CDN 链接

```
https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket.conf
https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket-AD.conf
```

---
🦞 自动同步于 $(date '+%Y-%m-%d %H:%M:%S')
EOF

log "  ✅ README.md 已更新"

# 输出信息
log ""
log "📁 iCloud 同步目录:"
log "   $ICLOUD_DIR"
log ""
log "📱 可在 iPhone/iPad 文件 App 中访问:"
log "   文件 > iCloud Drive > Clawbaby > 07-System > 配置 > ClawRocket"
log ""
log "📝 日志: $LOG_FILE"
log "✅ 同步完成"
