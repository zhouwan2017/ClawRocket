#!/bin/bash
# 🦞 Clawrules iPhone 去广告强化版 v3.0（MitM + 增强规则）

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/Shadowrocket/配置"
LOG_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Clawbaby/05-CronJobs/Shadowrocket/日志"
mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

LOG_FILE="$LOG_DIR/generate_iphone_ad_$(date +%Y%m%d-%H%M).log"
log() { echo "$(date '+%H:%M:%S') $1" | tee -a "$LOG_FILE"; }

# 缓存目录
CACHE_DIR="$HOME/.openclaw/cache/shadowrocket-rules"
mkdir -p "$CACHE_DIR"

log "🦞 Clawrules iPhone 去广告强化版 v3.0 生成器启动"
log "===================================================="

OUTPUT_FILE="$OUTPUT_DIR/🦞CR-AD-i-$(date +%m%d-%H%M).conf"

# 生成配置头部（含 MitM）
log "📝 生成 iPhone 去广告强化版配置头部..."
cat > "$OUTPUT_FILE" << 'CONFIGHEAD'
# 🦞 Clawrules Shadowrocket 配置 iPhone 去广告强化版 v3.0
# 生成时间: GENERATED_TIME
# 规则类型：白名单模式 + MitM 去广告强化
# 版本：iPhone 去广告强化版（MitM + ACL4SSR + 神机规则）
#
# 优化说明:
# - DNS: 使用 DoH 防污染
# - MitM: 启用 HTTPS 解密，大幅提升去广告效果
# - 完整国内网站名单（2000+ 域名）
# - 水利/政府网站：强制直连，工作优先
# - Apple TV+：精确域名代理，美区账号优化
# - 写作/协作软件：国内直连，国际服务智能分流
# - AI/大模型：代理访问，国内镜像直连加速
# - 广告过滤：MitM + 域名拦截双重防护

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
# 通用广告参数移除
^https?://(.*).snssdk.com/api/ads - reject
^https?://(.*).amemv.com/api/ads - reject
^https?://(.*).musical.ly/api/ads - reject
^https?://(.*).tiktokv.com/api/ads - reject
^https?://(.*).byteoversea.com/api/ads - reject

# 知乎去广告
^https?://api.zhihu.com/topstory/recommend - reject
^https?://api.zhihu.com/v4/questions/\d+/answers\?include=.*ad - reject

# 微博去广告
^https?://api.weibo.cn/2/statuses/extend\?.*ad - reject
^https?://api.weibo.cn/2/cardlist\?.*ad - reject

# 小红书去广告
^https?://edith.xiaohongshu.com/api/sns/v\d+/note/\w+\?.*ad - reject

# B站去广告
^https?://app.bilibili.com/x/v2/splash\?.*ad - reject
^https?://app.bilibili.com/x/resource/show/tab\?.*ad - reject

[MITM]
# 启用 HTTPS 解密（需手动安装并信任 CA 证书）
enable = true

# 证书策略
ca-p12 = 
ca-passphrase = 

# 主机名通配符
hostname = *.google.cn, *.googlevideo.com, *.youtube.com, *.google.com, *.googleapis.com, *.googleusercontent.com, *.gstatic.com, *.googlesyndication.com, *.googleadservices.com, *.doubleclick.net, *.googletagmanager.com, *.google-analytics.com, *.googleoptimize.com, *.googletagservices.com, *.2mdn.net, *.app-measurement.com, *.firebaseio.com, *.crashlytics.com, *.google-analytics.com, *.googleadservices.com, *.googlesyndication.com, *.googletagmanager.com, *.googleoptimize.com, *.googletagservices.com, *.doubleclick.net, *.2mdn.net, *.app-measurement.com, *.firebaseio.com, *.crashlytics.com, *.google.cn, *.googlevideo.com, *.youtube.com, *.google.com, *.googleapis.com, *.googleusercontent.com, *.gstatic.com, *.baidu.com, *.bdstatic.com, *.bdimg.com, *.weibo.com, *.weibo.cn, *.sinaimg.cn, *.sina.com.cn, *.sinajs.cn, *.xiaohongshu.com, *.xhscdn.com, *.xhscdn.net, *.zhihu.com, *.zhimg.com, *.bilibili.com, *.bilivideo.com, *.biliapi.net, *.iqiyi.com, *.qiyi.com, *.qiyipic.com, *.youku.com, *.ykimg.com, *.tudou.com, *.tudouui.com, *.mgtv.com, *.hitv.com, *.hunantv.com, *.pptv.com, *.pptvimg.com, *.le.com, *.letv.com, *.letvimg.com, *.sohu.com, *.sogou.com, *.sogoucdn.com, *.360.cn, *.360.com, *.360safe.com, *.qq.com, *.gtimg.com, *.qpic.cn, *.myapp.com, *.weixin.com, *.wechat.com, *.tencent.com, *.tencent-cloud.com, *.alibaba.com, *.alicdn.com, *.aliyun.com, *.alipay.com, *.taobao.com, *.tmall.com, *.jd.com, *.360buyimg.com, *.meituan.com, *.meituan.net, *.dianping.com, *.ele.me, *.eleme.io, *.douyin.com, *.iesdouyin.com, *.amemv.com, *.snssdk.com, *.toutiao.com, *.toutiaocdn.com, *.toutiaovod.com, *.toutiaocloud.com, *.toutiaostatic.com, *.toutiaoimg.com, *.byteoversea.com, *.tiktokv.com, *.musical.ly, *.kuaishou.com, *.kwaicdn.com, *.kwai.com, *.kwai-pro.com, *.kwai.net, *.kwai-pro.net, *.kwai-pro.com.cn, *.kwai-pro.net.cn, *.kwai-pro.cn, *.kwai-pro.com.cn

# 跳过服务端证书验证
skip-server-cert-verify = true

[Rule]
# ===== 优先级 1: 局域网直连（最高优先级）===
# 本地 AI 服务
DOMAIN-SUFFIX,ollama.local,DIRECT
DOMAIN-SUFFIX,lmstudio.local,DIRECT
DOMAIN-SUFFIX,localai.local,DIRECT
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
DOMAIN-KEYWORD,mwr.gov.cn,DIRECT
DOMAIN-KEYWORD,cws.net.cn,DIRECT
DOMAIN-KEYWORD,swcc.org.cn,DIRECT
DOMAIN-KEYWORD,yellowriver.gov.cn,DIRECT
DOMAIN-KEYWORD,changjiang.gov.cn,DIRECT
DOMAIN-KEYWORD,pearlwater.gov.cn,DIRECT
DOMAIN-KEYWORD,haihe.gov.cn,DIRECT
DOMAIN-KEYWORD,huaihe.gov.cn,DIRECT
DOMAIN-KEYWORD,songliao.gov.cn,DIRECT
DOMAIN-KEYWORD,slwr.gov.cn,DIRECT
DOMAIN-KEYWORD,cjbh.gov.cn,DIRECT
DOMAIN-KEYWORD,nsbd.gov.cn,DIRECT
DOMAIN-KEYWORD,mwr.gov.cn,DIRECT
DOMAIN-SUFFIX,gov.cn,DIRECT

# ===== 优先级 4: Apple TV+ 代理 ===
DOMAIN-SUFFIX,tv.apple.com,PROXY
DOMAIN