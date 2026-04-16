#!/bin/bash
# 🦞 Clawrules Mac 版生成脚本 v2.0（合并 v6 规则 + AdGuard）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/Shadowrocket/配置"
LOG_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/Shadowrocket/日志"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

LOG_FILE="$LOG_DIR/generate_mac_$(date +%Y%m%d-%H%M).log"
log() { echo "$(date '+%H:%M:%S') $1" | tee -a "$LOG_FILE"; }

# 缓存目录
CACHE_DIR="$HOME/.openclaw/cache/shadowrocket-rules"
mkdir -p "$CACHE_DIR"

log "🦞 Clawrules Mac 版 v2.0 生成器启动（合并 v6 规则 + AdGuard）"
log "============================================================"

OUTPUT_FILE="$OUTPUT_DIR/🦞CR-m-$(date +%m%d-%H%M).conf"

# 生成配置头部
log "📝 生成 Mac 版配置头部..."
cat > "$OUTPUT_FILE" << 'CONFIGHEAD'
# 🦞 Clawrules Shadowrocket 配置 Mac 版 v2.0
# 生成时间: GENERATED_TIME
# 规则类型：白名单模式 (国内直连，其他代理)
# 版本：Mac + AdGuard 优化版（合并 v6 完整规则）
#
# 优化说明:
# - DNS: 本地 AdGuard (127.0.0.1:53)
# - 完整国内网站名单（2000+ 域名）
# - 无广告过滤（AdGuard 已处理）
# - 水利/政府网站：强制直连，工作优先
# - Apple TV+：精确域名代理，美区账号优化
# - 写作/协作软件：国内直连，国际服务智能分流
# - AI/大模型：代理访问，国内镜像直连加速

[General]
# DNS 配置 - 配合 AdGuard 使用本地 DNS
dns-server = 127.0.0.1:53

# 传统 DNS 备用（AdGuard 未启动时使用）
dns-fallback = 223.5.5.5, 119.29.29.29

# IPv6 设置
ipv6 = false

# 绕过系统设置
bypass-system = true

# 跳过代理的地址
skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, localhost, *.local, *.lan, *.internal, 127.0.0.1

# UDP 转发
udp-relay = true

# TCP 并发
tcp-concurrent = true

# 测试超时
test-timeout = 5

# URL 测试间隔
url-test-interval = 600

# HTTP/SOCKS5 监听（Mac 版启用本地代理）
http-listen = 127.0.0.1:1082
socks5-listen = 127.0.0.1:1081

[Rule]
CONFIGHEAD

# 替换时间
sed -i '' "s/GENERATED_TIME/$(date +%Y-%m-%d' '%H:%M)/g" "$OUTPUT_FILE"

# 添加自定义规则（v6 规则，无广告过滤）
log "📝 添加自定义规则..."
cat >> "$OUTPUT_FILE" << 'CUSTOMRULES'
# ===== 优先级 1: 水利/政府网站（强制直连）=====
DOMAIN-SUFFIX,mwr.gov.cn,DIRECT
DOMAIN-SUFFIX,cjw.gov.cn,DIRECT
DOMAIN-SUFFIX,cjh.com.cn,DIRECT
DOMAIN-SUFFIX,changjiang.cn,DIRECT
DOMAIN-SUFFIX,mwr.gov,DIRECT
DOMAIN-SUFFIX,slj.cq.gov.cn,DIRECT
DOMAIN-SUFFIX,cq.gov.cn,DIRECT
DOMAIN-SUFFIX,jxsl.gov.cn,DIRECT
DOMAIN-SUFFIX,jiangxi.gov.cn,DIRECT
DOMAIN-SUFFIX,ynwater.gov.cn,DIRECT
DOMAIN-SUFFIX,yn.gov.cn,DIRECT
DOMAIN-SUFFIX,hbwater.gov.cn,DIRECT
DOMAIN-SUFFIX,hubei.gov.cn,DIRECT
DOMAIN-SUFFIX,hljwater.gov.cn,DIRECT
DOMAIN-SUFFIX,hlj.gov.cn,DIRECT
DOMAIN-SUFFIX,yrcc.gov.cn,DIRECT

# ===== 优先级 2: AdGuard 相关（直连）=====
DOMAIN-SUFFIX,adguard.com,DIRECT
DOMAIN,adguardteam.github.io,DIRECT
IP-CIDR,127.0.0.1/32,DIRECT

# ===== 优先级 3: 写作/协作软件 ===
DOMAIN-SUFFIX,shimo.im,DIRECT
DOMAIN-SUFFIX,yuque.com,DIRECT
DOMAIN-SUFFIX,feishu.cn,DIRECT
DOMAIN-SUFFIX,larksuite.com,DIRECT
DOMAIN-SUFFIX,docs.qq.com,DIRECT
DOMAIN-SUFFIX,wps.cn,DIRECT
DOMAIN-SUFFIX,wps.com,DIRECT
DOMAIN-SUFFIX,officeplus.cn,DIRECT
DOMAIN-SUFFIX,yinxiang.com,DIRECT
DOMAIN-SUFFIX,evernote.cn,DIRECT
DOMAIN-SUFFIX,notion.so,PROXY
DOMAIN-SUFFIX,notion.site,PROXY
DOMAIN-SUFFIX,processon.com,DIRECT
DOMAIN-SUFFIX,xmind.cn,DIRECT
DOMAIN-SUFFIX,xmind.net,PROXY
DOMAIN-SUFFIX,figma.com,PROXY
DOMAIN-SUFFIX,lanhuapp.com,DIRECT
DOMAIN-SUFFIX,mastergo.com,DIRECT
DOMAIN-SUFFIX,js.design,DIRECT

# ===== 优先级 4: Apple TV+（美区账号精确代理）=====
DOMAIN,tv.apple.com,PROXY
DOMAIN,uts-api.itunes.apple.com,PROXY
DOMAIN,play-edge.itunes.apple.com,PROXY
DOMAIN,np-edge.itunes.apple.com,PROXY
DOMAIN,tv.g.apple.com,PROXY
DOMAIN,uts-api-siri.itunes.apple.com,PROXY
DOMAIN,play.itunes.apple.com,PROXY
DOMAIN,streaming.itunes.apple.com,PROXY
DOMAIN,apple-tv-plus-press.apple.com,PROXY
DOMAIN,tv.apple.com.edgekey.net,PROXY

# ===== 优先级 5: AI/大模型 ===
DOMAIN-SUFFIX,openai.com,PROXY
DOMAIN-SUFFIX,chat.openai.com,PROXY
DOMAIN-SUFFIX,api.openai.com,PROXY
DOMAIN-SUFFIX,anthropic.com,PROXY
DOMAIN-SUFFIX,claude.ai,PROXY
DOMAIN-SUFFIX,cursor.sh,PROXY
DOMAIN-SUFFIX,perplexity.ai,PROXY
DOMAIN-SUFFIX,ollama.com,PROXY
DOMAIN-SUFFIX,lmstudio.ai,PROXY
DOMAIN-SUFFIX,huggingface.co,PROXY
DOMAIN-SUFFIX,huggingface.com,PROXY
DOMAIN-SUFFIX,baichuan-ai.com,DIRECT
DOMAIN-SUFFIX,xinghuo.xfyun.cn,DIRECT
DOMAIN-SUFFIX,qianwen.aliyun.com,DIRECT
DOMAIN-SUFFIX,hf-mirror.com,DIRECT

# ===== 优先级 6: 开发者工具 ===
DOMAIN-SUFFIX,github.com,PROXY
DOMAIN-SUFFIX,githubusercontent.com,PROXY
DOMAIN-SUFFIX,github.io,PROXY
DOMAIN-SUFFIX,raw.githubusercontent.com,PROXY
DOMAIN-SUFFIX,ghproxy.com,DIRECT
DOMAIN-SUFFIX,ghps.cc,DIRECT
DOMAIN-SUFFIX,npmjs.com,PROXY
DOMAIN-SUFFIX,registry.npmjs.org,PROXY
DOMAIN-SUFFIX,npmmirror.com,DIRECT
DOMAIN-SUFFIX,pypi.org,PROXY
DOMAIN-SUFFIX,pypi.tuna.tsinghua.edu.cn,DIRECT
DOMAIN-SUFFIX,mirrors.aliyun.com,DIRECT
DOMAIN-SUFFIX,docker.io,PROXY
DOMAIN-SUFFIX,registry-1.docker.io,PROXY
DOMAIN-SUFFIX,registry.docker-cn.com,DIRECT
DOMAIN-SUFFIX,stackoverflow.com,PROXY
DOMAIN-SUFFIX,medium.com,PROXY
DOMAIN-SUFFIX,dev.to,PROXY
DOMAIN-SUFFIX,juejin.cn,DIRECT
DOMAIN-SUFFIX,v2ex.com,DIRECT
DOMAIN-SUFFIX,gitee.com,DIRECT
DOMAIN-SUFFIX,gitcode.net,DIRECT

# ===== 优先级 7: Apple 服务 ===
DOMAIN-SUFFIX,icloud.com,DIRECT
DOMAIN-SUFFIX,icloud.com.cn,DIRECT
DOMAIN-SUFFIX,me.com,DIRECT
DOMAIN-SUFFIX,itunes.com,DIRECT
DOMAIN-SUFFIX,apps.apple.com,DIRECT
DOMAIN-SUFFIX,mzstatic.com,DIRECT
DOMAIN-SUFFIX,apple.com,DIRECT
DOMAIN-SUFFIX,apple.com.cn,DIRECT
DOMAIN-SUFFIX,cdn-apple.com,DIRECT
DOMAIN-SUFFIX,push.apple.com,DIRECT
DOMAIN-SUFFIX,music.apple.com,DIRECT
DOMAIN-SUFFIX,apple.news,PROXY
DOMAIN-SUFFIX,news.apple.com,PROXY
DOMAIN-SUFFIX,arcade.apple.com,PROXY
DOMAIN-SUFFIX,fitnessplus.apple.com,PROXY

# ===== 优先级 8: 国民应用 ===
DOMAIN-SUFFIX,wechat.com,DIRECT
DOMAIN-SUFFIX,weixin.qq.com,DIRECT
DOMAIN-SUFFIX,wechatpay.com,DIRECT
DOMAIN-SUFFIX,alipay.com,DIRECT
DOMAIN-SUFFIX,alicdn.com,DIRECT
DOMAIN-SUFFIX,aliyun.com,DIRECT
DOMAIN-SUFFIX,taobao.com,DIRECT
DOMAIN-SUFFIX,tmall.com,DIRECT
DOMAIN-SUFFIX,qq.com,DIRECT
DOMAIN-SUFFIX,bilibili.com,DIRECT
DOMAIN-SUFFIX,iqiyi.com,DIRECT
DOMAIN-SUFFIX,youku.com,DIRECT
DOMAIN-SUFFIX,douyin.com,DIRECT
DOMAIN-SUFFIX,toutiao.com,DIRECT

# ===== 优先级 9: 银行 ===
DOMAIN-SUFFIX,95516.com,DIRECT
DOMAIN-SUFFIX,abchina.com,DIRECT
DOMAIN-SUFFIX,bankcomm.com,DIRECT
DOMAIN-SUFFIX,boc.cn,DIRECT
DOMAIN-SUFFIX,ccb.com,DIRECT
DOMAIN-SUFFIX,cmbchina.com,DIRECT
DOMAIN-SUFFIX,cmbc.com.cn,DIRECT
DOMAIN-SUFFIX,citicbank.com,DIRECT
DOMAIN-SUFFIX,cebbank.com,DIRECT
DOMAIN-SUFFIX,psbc.com,DIRECT
DOMAIN-SUFFIX,spdb.com.cn,DIRECT
DOMAIN-SUFFIX,pingan.com,DIRECT
CUSTOMRULES

# 下载国内域名列表（v6 规则）
# 下载函数（带重试）
download_with_retry() {
    local url=$1
    local max_retry=3
    local retry=0
    
    while [ $retry -lt $max_retry ]; do
        local temp_output=$(mktemp)
        if curl -sL --max-time 30 "$url" -o "$temp_output" 2>/dev/null; then
            if [ -s "$temp_output" ]; then
                cat "$temp_output"
                rm "$temp_output"
                return 0
            fi
        fi
        rm -f "$temp_output"
        retry=$((retry + 1))
        log "  下载失败，第 $retry 次重试..."
        sleep 5
    done
    return 1
}

log "📥 下载国内域名列表（ACL4SSR）..."
ACL4SSR_CACHE="$CACHE_DIR/acl4ssr-chinadomain.cache"
if download_with_retry "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaDomain.list"; then
    log "  ACL4SSR 下载成功"
    # 保存到缓存
    grep -E '^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD),' > "$ACL4SSR_CACHE.tmp" && mv "$ACL4SSR_CACHE.tmp" "$ACL4SSR_CACHE"
else
    log "  ⚠️ ACL4SSR 下载失败（3次重试），使用缓存"
    if [ -s "$ACL4SSR_CACHE" ]; then
        log "  使用缓存: $ACL4SSR_CACHE"
    else
        log "  ❌ 无可用缓存，跳过"
    fi
fi | grep -E '^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD),' >> "$OUTPUT_FILE"
if [ ! -s "$OUTPUT_FILE" ] && [ -s "$ACL4SSR_CACHE" ]; then
    cat "$ACL4SSR_CACHE" >> "$OUTPUT_FILE"
fi

log "📥 下载国内加速域名（dnsmasq-china-list）..."
DNSMASQ_CACHE="$CACHE_DIR/dnsmasq-china.cache"
if download_with_retry "https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf"; then
    log "  dnsmasq-china-list 下载成功"
    # 保存到缓存
    head -1500 | grep "^server=/" | sed 's/server=\///' | sed 's|\/.*||' | sed 's/^/DOMAIN-SUFFIX,/' | sed 's/$/,DIRECT/' > "$DNSMASQ_CACHE.tmp" && mv "$DNSMASQ_CACHE.tmp" "$DNSMASQ_CACHE"
else
    log "  ⚠️ dnsmasq-china-list 下载失败（3次重试），使用缓存"
    if [ -s "$DNSMASQ_CACHE" ]; then
        log "  使用缓存: $DNSMASQ_CACHE"
    else
        log "  ❌ 无可用缓存，跳过"
    fi
fi | head -1500 | grep "^server=/" | sed 's/server=\///' | sed 's|\/.*||' | sed 's/^/DOMAIN-SUFFIX,/' | sed 's/$/,DIRECT/' >> "$OUTPUT_FILE"
if [ ! -s "$OUTPUT_FILE" ] && [ -s "$DNSMASQ_CACHE" ]; then
    cat "$DNSMASQ_CACHE" >> "$OUTPUT_FILE"
fi

# 兜底规则
log "📝 添加兜底规则..."
cat >> "$OUTPUT_FILE" << 'FOOTER'

# ===== 兜底规则 ===
GEOIP,CN,DIRECT
FINAL,PROXY
FOOTER

# 统计
FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
RULE_COUNT=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')
log "✅ 生成完成: $(basename "$OUTPUT_FILE")"
log "   大小: $FILE_SIZE"
log "   行数: $RULE_COUNT"

log "🕐 完成时间: $(date '+%Y-%m-%d %H:%M:%S')"
log "📝 日志: $LOG_FILE"
