#!/bin/bash
# build.sh - 生成标准版和 AD 版

cd "/Users/unclevv/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/ClawRocket"

RULES_DIR="rules"
OUTPUT_DIR="output"
VERSION="v1.2.0"
DATE=$(date +%Y-%m-%d)

# 确保输出目录存在
mkdir -p $OUTPUT_DIR

# 标准版（无 REJECT）
cat $RULES_DIR/01-dns.conf \
    $RULES_DIR/03-direct.conf \
    $RULES_DIR/04-proxy.conf \
    $RULES_DIR/05-final.conf \
    > $OUTPUT_DIR/ClawRocket.conf

# AD 版（REJECT 前置）
cat $RULES_DIR/01-dns.conf \
    $RULES_DIR/02-reject.conf \
    $RULES_DIR/03-direct.conf \
    $RULES_DIR/04-proxy.conf \
    $RULES_DIR/05-final.conf \
    > $OUTPUT_DIR/ClawRocket-AD.conf

# 更新版本号和日期
sed -i '' "1s/.*/# 🦞 ClawRocket $VERSION/" $OUTPUT_DIR/ClawRocket.conf
sed -i '' "2s/.*/# 生成时间：$DATE/" $OUTPUT_DIR/ClawRocket.conf
sed -i '' "1s/.*/# 🦞 ClawRocket-AD $VERSION/" $OUTPUT_DIR/ClawRocket-AD.conf
sed -i '' "2s/.*/# 生成时间：$DATE/" $OUTPUT_DIR/ClawRocket-AD.conf

echo "✅ 构建完成：$VERSION ($DATE)"
