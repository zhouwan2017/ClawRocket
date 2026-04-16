#!/bin/bash
# push.sh - 推送 GitHub 并刷新 CDN

cd "/Users/unclevv/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/ClawRocket"

git add -A
git commit -m "🦞 v1.2.0 规则重构（模块化拆分 + REJECT 前置）"
git push

# 刷新 CDN 缓存
curl -X POST "https://purge.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/output/ClawRocket.conf"
curl -X POST "https://purge.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/output/ClawRocket-AD.conf"

echo "✅ 推送完成，CDN 已刷新"
