#!/bin/bash
# stats.sh - 统计各规则集数量

cd "/Users/unclevv/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/ClawRocket"

echo "📊 ClawRocket 规则统计"
echo "===================="
total=0
for file in rules/01-dns.conf rules/02-reject.conf rules/03-direct.conf rules/04-proxy.conf rules/05-final.conf; do
  if [ -f "$file" ]; then
    count=$(grep -c "^DOMAIN" "$file" 2>/dev/null)
    if [ -z "$count" ]; then count=0; fi
    printf "%-30s %5d 条\n" "$(basename $file)" $count
    total=$((total + count))
  fi
done
echo "===================="
printf "%-30s %5d 条\n" "总计" $total
