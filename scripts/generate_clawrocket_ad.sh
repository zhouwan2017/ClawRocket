#!/bin/bash
# 🦞 ClawRocket-AD Pro v1.0.0 - Shadowrocket 去广告强化版
# MitM + URL Rewrite + 增强广告过滤

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/output"
CACHE_DIR="$PROJECT_DIR/cache"
LOG_DIR="$PROJECT_DIR/logs"
mkdir -p "$OUTPUT_DIR" "$CACHE_DIR/acl4ssr" "$CACHE_DIR/dnsmasq-china" "$CACHE_DIR/adblock" "$LOG_DIR"

# 版本号
VERSION="1.0.0"

# 日志
LOG_FILE="$LOG_DIR/generate-ad-$(date +%Y%m%d-%H%M).log"
log() { echo "$(date '+%H:%M:%S') $1" | tee -a "$LOG_FILE"; }

log "🦞 ClawRocket-AD Pro v$VERSION 生成器启动"
log "============================================"

# 输出文件
TIMESTAMP=$(date +%m%d-%H%M)
OUTPUT_FILE="$OUTPUT_DIR/ClawRocket-AD-$TIMESTAMP.conf"
OUTPUT_TEST="$OUTPUT_DIR/ClawRocket-AD-Test.conf"

# 生成配置头部
log "📝 生成配置头部..."
cat > "$OUTPUT_FILE" << CONFIGHEAD
# 🦞 ClawRocket-AD Pro v$VERSION
# 生成时间: $(date +%Y-%m-%d' '%H:%M)
# 规则类型: 白名单模式 + MitM 去广告强化
# GitHub: https://github.com/zhouwan2017/ClawRocket
# CDN: https://cdn.jsdelivr.net/gh/zhouwan2017/ClawRocket@main/ClawRocket-AD.conf
#
# ⚠️ 重要提示:
# - 本配置启用 MitM (HTTPS 解密) 以增强去广告效果
# - 使用前必须在 Shadowrocket 中生成并信任 CA 证书
# - 部分银行/金融 App 可能无法使用
# - 如遇问题，请切换至标准版 ClawRocket
#
# 优化说明:
# - DNS: 使用 DoH 防污染
# - MitM: 启用 HTTPS 解密，大幅提升去广告效果
# - URL Rewrite: 拦截广告请求
# - 完整国内网站名单（2000+ 域名）
# - 增强广告过滤（500+ 广告域名）

[General]
# DNS 配置 - 使用 DoH 防污染
doh-server = https://dns.alidns.com/dns-query, https://cloudflare-dns.com/dns-query

# 传统 DNS 备用
dns-server = 223.5.5.5, 119.29.29.29, 1.1.1.1, 8.8.8.8

# IPv6 设置
ipv6 = false

# 绕过系统设置
bypass-system = true

# DNS 失败时回退
dns-fallback = system

# 并发 DNS 查询
dns-direct-fallback = true

# 本地 DNS 映射
dns-direct-system = false

# 始终真实 IP
direct-domain-fallback = true

# 跳过代理
skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, 127.0.0.1, localhost, *.local

# 排除简单主机名
exclude-simple-hosts = true

# 网络测试 URL
internet-test-url = http://www.baidu.com

# 代理测试 URL
proxy-test-url = http://www.google.com

# 测试超时
test-timeout = 5

# 并发测试线程
test-threads = 4

[Host]
# 本地开发环境
localhost = 127.0.0.1

# 局域网 AI 服务
*.local = 192.168.21.219

[URL Rewrite]
# ===== 抖音/头条广告 =====
^https?://(.*).snssdk.com/api/ads - reject
^https?://(.*).amemv.com/api/ads - reject
^https?://(.*).musical.ly/api/ads - reject
^https?://(.*).tiktokv.com/api/ads - reject
^https?://(.*).byteoversea.com/api/ads - reject

# ===== 知乎广告 =====
^https?://api.zhihu.com/topstory/recommend - reject
^https?://api.zhihu.com/v4/questions/\d+/answers\?include=.*ad - reject
^https?://api.zhihu.com/v4/questions/\d+/feeds\?.*ad - reject

# ===== 微博广告 =====
^https?://api.weibo.cn/2/statuses/extend\?.*ad - reject
^https?://api.weibo.cn/2/cardlist\?.*ad - reject
^https?://api.weibo.cn/2/statuses/unread_hot_timeline\?.*ad - reject

# ===== 小红书广告 =====
^https?://edith.xiaohongshu.com/api/sns/v\d+/note/\w+\?.*ad - reject
^https?://edith.xiaohongshu.com/api/sns/v\d+/homefeed\?.*ad - reject

# ===== B站广告 =====
^https?://app.bilibili.com/x/v2/splash\?.*ad - reject
^https?://app.bilibili.com/x/resource/show/tab\?.*ad - reject
^https?://app.bilibili.com/x/v2/feed/index\?.*ad - reject

# ===== 通用广告参数移除 =====
^https?://(.*)\?.*(ad|ads|advertising|tracking|analytics) - reject

[MITM]
# 启用 HTTPS 解密（需手动安装并信任 CA 证书）
enable = true

# 证书策略
ca-p12 = 
ca-passphrase = 

# 主机名通配符（覆盖主流广告域名）
hostname = *.google.com, *.googlevideo.com, *.youtube.com, *.googleapis.com, *.googleusercontent.com, *.gstatic.com, *.googlesyndication.com, *.googleadservices.com, *.doubleclick.net, *.googletagmanager.com, *.google-analytics.com, *.googleoptimize.com, *.googletagservices.com, *.2mdn.net, *.app-measurement.com, *.firebaseio.com, *.crashlytics.com, *.baidu.com, *.bdstatic.com, *.bdimg.com, *.weibo.com, *.weibo.cn, *.sinaimg.cn, *.sina.com.cn, *.sinajs.cn, *.xiaohongshu.com, *.xhscdn.com, *.xhscdn.net, *.zhihu.com, *.zhimg.com, *.bilibili.com, *.bilivideo.com, *.biliapi.net, *.iqiyi.com, *.qiyi.com, *.qiyipic.com, *.youku.com, *.ykimg.com, *.tudou.com, *.tudouui.com, *.mgtv.com, *.hitv.com, *.hunantv.com, *.pptv.com, *.pptvimg.com, *.le.com, *.letv.com, *.letvimg.com, *.sohu.com, *.sogou.com, *.sogoucdn.com, *.360.cn, *.360.com, *.360safe.com, *.qq.com, *.gtimg.com, *.qpic.cn, *.myapp.com, *.weixin.com, *.wechat.com, *.tencent.com, *.tencent-cloud.com, *.alibaba.com, *.alicdn.com, *.aliyun.com, *.alipay.com, *.taobao.com, *.tmall.com, *.jd.com, *.360buyimg.com, *.meituan.com, *.meituan.net, *.dianping.com, *.ele.me, *.eleme.io, *.douyin.com, *.iesdouyin.com, *.amemv.com, *.snssdk.com, *.toutiao.com, *.toutiaocdn.com, *.toutiaovod.com, *.toutiaocloud.com, *.toutiaostatic.com, *.toutiaoimg.com, *.byteoversea.com, *.tiktokv.com, *.musical.ly, *.kuaishou.com, *.kwaicdn.com, *.kwai.com

# 跳过服务端证书验证
skip-server-cert-verify = true

[Rule]
CONFIGHEAD

# 添加自定义规则
log "📝 添加自定义规则..."
cat >> "$OUTPUT_FILE" << 'CUSTOMRULES'
# ===== 优先级 1: 局域网直连（最高优先级）===
IP-CIDR,192.168.0.0/16,DIRECT
IP-CIDR,10.0.0.0/8,DIRECT
IP-CIDR,172.16.0.0/12,DIRECT
IP-CIDR,127.0.0.0/8,DIRECT
IP-CIDR,100.64.0.0/10,DIRECT

# ===== 优先级 2: 广告拦截（REJECT）===
# Google 广告
DOMAIN-SUFFIX,googleadservices.com,REJECT
DOMAIN-SUFFIX,googlesyndication.com,REJECT
DOMAIN-SUFFIX,googletagmanager.com,REJECT
DOMAIN-SUFFIX,google-analytics.com,REJECT
DOMAIN-SUFFIX,googleoptimize.com,REJECT
DOMAIN-SUFFIX,googletagservices.com,REJECT
DOMAIN-SUFFIX,doubleclick.net,REJECT
DOMAIN-SUFFIX,2mdn.net,REJECT
DOMAIN-SUFFIX,app-measurement.com,REJECT
DOMAIN-SUFFIX,firebaseio.com,REJECT
DOMAIN-SUFFIX,crashlytics.com,REJECT

# 百度广告
DOMAIN-SUFFIX,baidustatic.com,REJECT
DOMAIN-SUFFIX,hm.baidu.com,REJECT
DOMAIN-SUFFIX,pos.baidu.com,REJECT
DOMAIN-SUFFIX,cpro.baidu.com,REJECT
DOMAIN-SUFFIX,cpro.baidustatic.com,REJECT

# 微博广告
DOMAIN-SUFFIX,alitui.weibo.com,REJECT
DOMAIN-SUFFIX,tui.weibo.com,REJECT
DOMAIN-SUFFIX,sdkapp.uve.weibo.com,REJECT

# 知乎广告
DOMAIN-SUFFIX,appcloud.zhihu.com,REJECT
DOMAIN-SUFFIX,appcloud2.zhihu.com,REJECT

# 小红书广告
DOMAIN-SUFFIX,edith.xiaohongshu.com,REJECT

# B站广告
DOMAIN-SUFFIX,data.bilibili.com,REJECT
DOMAIN-SUFFIX,cm.bilibili.com,REJECT

# 通用广告域名
DOMAIN-SUFFIX,adnxs.com,REJECT
DOMAIN-SUFFIX,adsafeprotected.com,REJECT
DOMAIN-SUFFIX,adsrvr.org,REJECT
DOMAIN-SUFFIX,advertising.com,REJECT
DOMAIN-SUFFIX,amazon-adsystem.com,REJECT
DOMAIN-SUFFIX,analytics.yahoo.com,REJECT
DOMAIN-SUFFIX,appier.net,REJECT
DOMAIN-SUFFIX,appsflyer.com,REJECT
DOMAIN-SUFFIX,criteo.com,REJECT
DOMAIN-SUFFIX,facebook.com,REJECT
DOMAIN-SUFFIX,fbcdn.net,REJECT
DOMAIN-SUFFIX,flurry.com,REJECT
DOMAIN-SUFFIX,go-mpulse.net,REJECT
DOMAIN-SUFFIX,googleadservices.com,REJECT
DOMAIN-SUFFIX,googlesyndication.com,REJECT
DOMAIN-SUFFIX,googletagmanager.com,REJECT
DOMAIN-SUFFIX,hotjar.com,REJECT
DOMAIN-SUFFIX,inmobi.com,REJECT
DOMAIN-SUFFIX,jpush.cn,REJECT
DOMAIN-SUFFIX,kochava.com,REJECT
DOMAIN-SUFFIX,mixpanel.com,REJECT
DOMAIN-SUFFIX,moatads.com,REJECT
DOMAIN-SUFFIX,scorecardresearch.com,REJECT
DOMAIN-SUFFIX,sentry.io,REJECT
DOMAIN-SUFFIX,taboola.com,REJECT
DOMAIN-SUFFIX,tanx.com,REJECT
DOMAIN-SUFFIX,tapjoy.com,REJECT
DOMAIN-SUFFIX,tremorhub.com,REJECT
DOMAIN-SUFFIX,umeng.com,REJECT
DOMAIN-SUFFIX,umengcloud.com,REJECT
DOMAIN-SUFFIX,unity3d.com,REJECT
DOMAIN-SUFFIX,vungle.com,REJECT

# ===== 优先级 3: 水利/政府直连 ===
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
DOMAIN-SUFFIX,cws.net.cn,DIRECT
DOMAIN-SUFFIX,swcc.org.cn,DIRECT
DOMAIN-SUFFIX,yellowriver.gov.cn,DIRECT
DOMAIN-SUFFIX,changjiang.gov.cn,DIRECT
DOMAIN-SUFFIX,pearlwater.gov.cn,DIRECT
DOMAIN-SUFFIX,haihe.gov.cn,DIRECT
DOMAIN-SUFFIX,huaihe.gov.cn,DIRECT
DOMAIN-SUFFIX,songliao.gov.cn,DIRECT
DOMAIN-SUFFIX,slwr.gov.cn,DIRECT
DOMAIN-SUFFIX,cjbh.gov.cn,DIRECT
DOMAIN-SUFFIX,nsbd.gov.cn,DIRECT
DOMAIN-SUFFIX,gov.cn,DIRECT

# ===== 优先级 4: 银行网站（直连）=====
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
DOMAIN-SUFFIX,icbc.com.cn,DIRECT
DOMAIN-SUFFIX,bankofchina.com,DIRECT

# ===== 优先级 5: 写作/协作软件 ===
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

# ===== 优先级 6: Apple TV+（美区账号精确代理）=====
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

# ===== 优先级 7: AI/大模型 ===
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

# ===== 优先级 8: 开发者工具 ===
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

# ===== 优先级 9: Apple 服务 ===
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

# ===== 优先级 10: 国民应用 ===
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
DOMAIN-SUFFIX,amemv.com,DIRECT
DOMAIN-SUFFIX,iesdouyin.com,DIRECT
DOMAIN-SUFFIX,kuaishou.com,DIRECT
DOMAIN-SUFFIX,jd.com,DIRECT
DOMAIN-SUFFIX,360buyimg.com,DIRECT
DOMAIN-SUFFIX,meituan.com,DIRECT
DOMAIN-SUFFIX,meituan.net,DIRECT
DOMAIN-SUFFIX,dianping.com,DIRECT
DOMAIN-SUFFIX,ele.me,DIRECT
DOMAIN-SUFFIX,eleme.io,DIRECT
CUSTOMRULES

# 下载函数（带重试和缓存）
download_with_retry() {
    local url=$1
    local cache_file=$2
    local max_retry=3
    local retry=0
    
    # 检查缓存（24小时内有效）
    if [ -f "$cache_file" ] && [ $(($(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file"))) -lt 86400 ]; then
        log "  使用缓存: $cache_file"
        cat "$cache_file"
        return 0
    fi
    
    while [ $retry -lt $max_retry ]; do
        local temp_output=$(mktemp)
        if curl -sL --max-time 30 "$url" -o "$temp_output" 2>/dev/null; then
            if [ -s "$temp_output" ]; then
                # 保存到缓存
                cp "$temp_output" "$cache_file"
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
    
    # 全部失败，尝试使用缓存（即使过期）
    if [ -f "$cache_file" ]; then
        log "  ⚠️ 下载失败，使用过期缓存"
        cat "$cache_file"
        return 0
    fi
    
    return 1
}

# 下载 ACL4SSR 国内域名
log "📥 下载 ACL4SSR 国内域名列表..."
ACL4SSR_CACHE="$CACHE_DIR/acl4ssr/chinadomain.list"
if download_with_retry "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/ChinaDomain.list" "$ACL4SSR_CACHE"; then
    log "  ACL4SSR 下载成功"
    # 转换格式并追加
    grep -E '^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD),' "$ACL4SSR_CACHE" | sed 's/,$/,DIRECT/' >> "$OUTPUT_FILE"
else
    log "  ❌ ACL4SSR 下载失败且无缓存"
fi

# 下载 dnsmasq-china-list
log "📥 下载 dnsmasq-china-list..."
DNSMASQ_CACHE="$CACHE_DIR/dnsmasq-china/accelerated-domains.conf"
if download_with_retry "https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf" "$DNSMASQ_CACHE"; then
    log "  dnsmasq-china-list 下载成功"
    # 转换格式（取前1500条）
    head -1500 "$DNSMASQ_CACHE" | grep "^server=/" | sed 's/server=\///' | sed 's|\/.*||' | sed 's/^/DOMAIN-SUFFIX,/' | sed 's/$/,DIRECT/' >> "$OUTPUT_FILE"
else
    log "  ❌ dnsmasq-china-list 下载失败且无缓存"
fi

# 下载 ACL4SSR 广告规则
log "📥 下载 ACL4SSR 广告规则..."
BANAD_CACHE="$CACHE_DIR/adblock/banad.list"
if download_with_retry "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanAD.list" "$BANAD_CACHE"; then
    log "  ACL4SSR BanAD 下载成功"
    grep -E '^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD),' "$BANAD_CACHE" | sed 's/,$/,REJECT/' >> "$OUTPUT_FILE"
else
    log "  ❌ ACL4SSR BanAD 下载失败"
fi

# 下载 ACL4SSR 应用广告
log "📥 下载 ACL4SSR 应用广告规则..."
BANPROG_CACHE="$CACHE_DIR/adblock/banprogramad.list"
if download_with_retry "https://raw.githubusercontent.com/ACL4SSR/ACL4SSR/master/Clash/BanProgramAD.list" "$BANPROG_CACHE"; then
    log "  ACL4SSR BanProgramAD 下载成功"
    grep -E '^(DOMAIN|DOMAIN-SUFFIX|DOMAIN-KEYWORD),' "$BANPROG_CACHE" | sed 's/,$/,REJECT/' >> "$OUTPUT_FILE"
else
    log "  ❌ ACL4SSR BanProgramAD 下载失败"
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
RULE_COUNT=$(grep -c '^DOMAIN\|^IP-CIDR\|^GEOIP\|^FINAL\|^URL' "$OUTPUT_FILE" || echo "0")
log "✅ 生成完成: $(basename "$OUTPUT_FILE")"
log "   大小: $FILE_SIZE"
log "   规则数: $RULE_COUNT"

# 复制到测试文件
cp "$OUTPUT_FILE" "$OUTPUT_TEST"
log "📋 已复制到测试文件: $(basename "$OUTPUT_TEST")"

# 验证
if [ "$RULE_COUNT" -lt 2500 ]; then
    log "⚠️ 警告: 规则数不足 2500，请检查"
fi

log "🕐 完成时间: $(date '+%Y-%m-%d %H:%M:%S')"
log "📝 日志: $LOG_FILE"

# 输出结果供调用者使用
echo ""
echo "OUTPUT_FILE=$OUTPUT_FILE"
echo "RULE_COUNT=$RULE_COUNT"
echo "FILE_SIZE=$FILE_SIZE"