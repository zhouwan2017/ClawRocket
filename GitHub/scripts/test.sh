#!/bin/bash
# test.sh - 验证规则顺序和冲突

cd "/Users/unclevv/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/ClawRocket"

echo "🔍 检查规则冲突..."

# 检查 REJECT 是否在 DIRECT 之前
reject_line=$(grep -n "DOMAIN-SUFFIX,bootpreload.uve.weibo.com,REJECT" output/ClawRocket-AD.conf | cut -d: -f1)
direct_line=$(grep -n "DOMAIN-SUFFIX,mwr.gov.cn,DIRECT" output/ClawRocket-AD.conf | cut -d: -f1)

if [ -n "$reject_line" ] && [ -n "$direct_line" ]; then
  if [ $reject_line -lt $direct_line ]; then
    echo "✅ 规则顺序正确 (REJECT:$reject_line < DIRECT:$direct_line)"
  else
    echo "❌ 规则顺序错误！"
    exit 1
  fi
else
  echo "⚠️ 未找到对比规则，跳过顺序检查"
fi

# 检查规则数量
reject_count=$(grep -c ",REJECT" output/ClawRocket-AD.conf || echo 0)
direct_count=$(grep -c ",DIRECT" output/ClawRocket-AD.conf || echo 0)
proxy_count=$(grep -c ",PROXY" output/ClawRocket-AD.conf || echo 0)

echo "📊 规则统计：REJECT=$reject_count, DIRECT=$direct_count, PROXY=$proxy_count"

# 验证标准版不包含 REJECT
if grep -q ",REJECT" output/ClawRocket.conf 2>/dev/null; then
  std_reject_count=$(grep -c ",REJECT" output/ClawRocket.conf)
  echo "❌ 标准版包含 REJECT 规则（$std_reject_count 条）"
  exit 1
else
  echo "✅ 标准版无 REJECT 规则"
fi

echo "✅ 所有测试通过"
