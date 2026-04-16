#!/bin/bash
# 🦞 ClawRocket GitHub 推送脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/output"
LOG_DIR="$PROJECT_DIR/logs"
mkdir -p "$LOG_DIR"

# 日志
LOG_FILE="$LOG_DIR/github-push-$(date +%Y%m%d-%H%M).log"
log() { echo "$(date '+%H:%M:%S') $1" | tee -a "$LOG_FILE"; }

# GitHub 仓库配置
REPO_URL="https://github.com/zhouwan2017/ClawRocket.git"
REPO_DIR="$PROJECT_DIR/.github-temp"

log "🦞 ClawRocket GitHub 推送脚本"
log "=============================="

# 检查配置文件
log "📋 检查配置文件..."
STANDARD_FILE="$OUTPUT_DIR/ClawRocket-Test.conf"
PRO_FILE="$OUTPUT_DIR/ClawRocket-AD-Test.conf"

if [ ! -f "$STANDARD_FILE" ]; then
    log "❌ 标准版配置不存在: $STANDARD_FILE"
    exit 1
fi

if [ ! -f "$PRO_FILE" ]; then
    log "❌ Pro版配置不存在: $PRO_FILE"
    exit 1
fi

log "  ✅ 标准版: $(basename "$STANDARD_FILE")"
log "  ✅ Pro版: $(basename "$PRO_FILE")"

# 克隆或更新仓库
log "📥 准备 GitHub 仓库..."
if [ -d "$REPO_DIR/.git" ]; then
    log "  更新现有仓库..."
    cd "$REPO_DIR"
    git fetch origin
    git reset --hard origin/main
else
    log "  克隆仓库..."
    rm -rf "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR" || {
        log "❌ 克隆失败，尝试初始化本地仓库..."
        mkdir -p "$REPO_DIR"
        cd "$REPO_DIR"
        git init
        git remote add origin "$REPO_URL"
    }
fi

# 复制配置文件
log "📦 复制配置文件..."
cp "$STANDARD_FILE" "$REPO_DIR/ClawRocket.conf"
cp "$PRO_FILE" "$REPO_DIR/ClawRocket-AD.conf"
cp "$STANDARD_FILE" "$REPO_DIR/ClawRocket-Test.conf"
cp "$PRO_FILE" "$REPO_DIR/ClawRocket-AD-Test.conf"

# 获取文件信息
STANDARD_SIZE=$(du -h "$STANDARD_FILE" | cut -f1)
PRO_SIZE=$(du -h "$PRO_FILE" | cut -f1)
STANDARD_RULES=$(grep -c '^DOMAIN\|^IP-CIDR\|^GEOIP\|^FINAL' "$STANDARD_FILE" || echo "0")
PRO_RULES=$(grep -c '^DOMAIN\|^IP-CIDR\|^GEOIP\|^FINAL' "$PRO_FILE" || echo "0")

log "  标准版: $STANDARD_SIZE, $STANDARD_RULES 规则"
log "  Pro版: $PRO_SIZE, $PRO_RULES 规则"

# Git 提交
log "📝 Git 提交..."
cd "$REPO_DIR"
git add -A

if git diff --cached --quiet; then
    log "  📝 无变化，跳过提交"
else
    git commit -m "🦞 Update configs ($(date +%Y-%m-%d-%H%M))

标准版: $STANDARD_RULES 规则 ($STANDARD_SIZE)
Pro版: $PRO_RULES 规则 ($PRO_SIZE)
生成时间: $(date '+%Y-%m-%d %H:%M:%S')"
    
    log "📤 推送到 GitHub..."
    if git push origin main; then
        log "  ✅ 推送成功"
    else
        log "  ⚠️ 推送失败，可能是权限问题"
        log "     请检查 SSH key 或 HTTPS 认证"
    fi
fi

# 输出链接
log ""
log "🔗 GitHub 链接:"
log "   https://github.com/zhouwan2017/ClawRocket"
log ""
log "🚀 CDN 链接（立即可用）:"
log "   标准版: https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket.conf"
log "   Pro版:  https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket-AD.conf"
log "   标准版测试: https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket-Test.conf"
log "   Pro版测试:  https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket-AD-Test.conf"
log ""
log "📝 日志: $LOG_FILE"

# 清理
rm -rf "$REPO_DIR"

log "✅ 完成"
