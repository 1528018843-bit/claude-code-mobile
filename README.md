# Claude Code Mobile 📱

> **手机远程 AI 编程助手 — 把 Claude Code + DeepSeek 装进口袋**
>
> 不需要梯子，不需要电脑，一部手机 + 一台云服务器 = 随时随地 AI 编程

---

## 📋 目录

1. [这套方案是什么？](#-这套方案是什么)
2. [需要准备什么？](#-需要准备什么)
3. [第一步：买服务器](#-第一步买服务器)
4. [第二步：一键安装](#-第二步一键安装)
5. [第三步：手机连接](#-第三步手机连接)
6. [日常使用](#-日常使用)
7. [常见问题](#-常见问题)
8. [工作原理](#-工作原理)
9. [维护与升级](#-维护与升级)
10. [推广与分享](#-推广与分享)

---

## 🌟 这套方案是什么？

### 一句话

把 **Claude Code**（Anthropic 出品的 AI 编程助手）安装在云服务器上，手机通过 SSH 远程连接，用 **DeepSeek API**（国产大模型，便宜又好用）来驱动 AI 编程。

### 架构图

```
手机 Termius → SSH 连接 → 阿里云服务器
                               │
                    ┌──────────┴──────────┐
                    │  claude 命令         │
                    │  (Claude Code CLI)   │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  deepseek-claude-    │
                    │  proxy (反向代理)    │
                    │  端口 8080           │
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  DeepSeek API       │
                    │  ¥0.5/百万 token    │
                    └─────────────────────┘
```

### 这套方案的优点

| 优势 | 说明 |
|------|------|
| 🚫 **不用梯子** | 阿里云在国内，不需要任何翻墙工具 |
| 📱 **手机能用** | 地铁、公交、床上，掏出手机就能写代码 |
| 💰 **成本极低** | 服务器 ¥99/年 + API ¥5/月 = 每月一杯奶茶钱 |
| 🔌 **一键安装** | 一行命令，5 分钟自动搞定 |
| 🧑‍🤝‍🧑 **多人共用** | 一台服务器，各自 SSH 互不影响 |

---

## 📦 需要准备什么？

| 项目 | 说明 | 费用 |
|------|------|------|
| ☁️ **云服务器** | 阿里云 e实例 2核2G 40G 3M带宽 | **¥99/年** |
| 🔑 **DeepSeek API Key** | 在 platform.deepseek.com 注册获取 | **约 ¥5/月** |
| 📱 **手机** | iPhone / Android 都行 | 已有 |
| 📲 **Termius App** | 手机 SSH 客户端（免费） | **免费** |

**总成本：约 ¥13/月** 💰

---

## 🛜 第一步：买服务器

[**👉 点击这里购买阿里云 99元/年 服务器**](https://www.aliyun.com/minisite/goods?userCode=6rifipk8)

配置选择：

```
实例：e实例
核数：2核
内存：2G
系统盘：40G Entry云盘
带宽：3M
时长：1年
价格：99元
```

> 为什么选这个配置？
> - 实测 Claude Code + 代理只占 **72MB 内存**
> - 2核 CPU 几乎跑不满
> - 3M 带宽足够 SSH 连接
> - ¥99/年是最低价

### 服务器购买后的信息

买完后你会收到：

```
公网 IP：47.xxx.xxx.xxx（记下来）
用户名：root 或 admin（看系统）
密码：你设的密码
```

---

## ⚡ 第二步：一键安装

### 2.1 SSH 登服务器

电脑上打开终端（或者用网页版 SSH），输入：

```bash
ssh admin@你的服务器IP
```

输入密码登录。

### 2.2 运行一键脚本

登录后，复制粘贴这一行命令：

```bash
bash <(curl -sL http://47.101.210.146:8000/install.sh)
```

### 2.3 安装过程

脚本会自动完成所有操作，你只需要做一件事：

```
📌 请输入你的 DeepSeek API Key (sk-...): 
```

去 [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys) 注册 → 登录 → 创建 API Key → 粘贴进来。

然后等 3-5 分钟，看到这个画面就完成了：

```
========================================
  ✅ 部署完成！
========================================

服务器 IP：47.xxx.xxx.xxx
SSH 端口：22（默认）/ 2222（备用）
用户名：admin

📱 手机连接步骤：
1. 手机安装 Termius
2. 新建 Host：IP=服务器IP  Port=2222  用户名=admin  密码=你的密码
3. 连接成功后输入：claude
```

### 2.4 验证是否成功

```bash
echo "ping" | claude -p "say pong"
```

如果返回 `pong 🏓`，说明成功了！🎉

---

## 📱 第三步：手机连接

### 3.1 安装 Termius

| 手机系统 | 下载方式 |
|---------|---------|
| **iPhone** | App Store 搜索 "Termius" |
| **Android** | Google Play / 应用商店 搜索 "Termius" |

### 3.2 新建主机连接

打开 Termius → 点 "+" → 填写：

```
📋 标签（随便填）：我的AI编程助手
📋 Hostname：你的服务器公网 IP
📋 Port：2222（重要！不是 22）
📋 Username：admin（或 root，看服务器）
📋 Password：你的服务器密码
```

点右上角 Save → 点一下这个主机连接。

### 3.3 首次使用 Claude Code

连接成功后，输入：

```bash
claude
```

如果是第一次用，会要求登录。输入：

```bash
claude auth login
```

会显示一个链接，在浏览器打开（电脑或能用外网的设备），完成认证即可。

---

## 🎯 日常使用

### 手机上的基本操作

```bash
# 启动 Claude Code（交互模式）
claude

# 直接问问题（非交互模式）
claude -p "用 Python 写一个计算器"

# 指定模型
claude --model deepseek-chat

# 查看帮助
claude --help
```

### 在 Claude Code 里面

```
▶ 输入你的问题，比如：
  "帮我写一个 Flask REST API"
  "解释这段代码是什么意思"
  "给这个函数加注释"
  "帮我看看这个 bug 在哪"

▶ /help    查看命令列表
▶ /models  查看可用模型
▶ /clear   清除对话
▶ /exit    退出
```

---

## ❓ 常见问题

### Q1：手机连不上 SSH？

中国移动、联通经常封锁 22 端口。解决方法：

1. **把 Termius 端口改成 2222**（安装脚本已自动开启）
2. 切换 Wi-Fi 和流量试试
3. 换个 APP（JuiceSSH、Termux 等）

### Q2：报 "model not found" 错误？

代理的模型版本号可能和你装的 Claude Code 不匹配。两种方法：

```bash
# 方法1：指定模型启动
claude --model deepseek-chat

# 方法2：更新代理内的模型列表
sudo sed -i 's/claude-opus-4-7/claude-opus-4-8/g' /usr/lib/node_modules/deepseek-claude-proxy/dist/proxy.js
sudo sed -i 's/claude-sonnet-4-6/claude-sonnet-4-8/g' /usr/lib/node_modules/deepseek-claude-proxy/dist/proxy.js
```

### Q3：DeepSeek API Key 怎么获取？

1. 打开 [platform.deepseek.com](https://platform.deepseek.com)
2. 注册账号
3. 进入 API Keys 页面
4. 点 "Create API Key"
5. 复制 `sk-...` 开头的 key

新用户有 **¥5 免费额度**，够写很久代码。

### Q4：用别的 AI 模型可以吗？

可以。`deepseek-claude-proxy` 支持多种后端：

- DeepSeek（默认）
- OpenAI
- 通义千问
- Ollama（本地模型）
- 任何兼容 OpenAI 格式的 API

### Q5：退出 SSH 后代理会停吗？

不会。安装脚本已经配置了：
- ✅ **crontab 开机自启** — 服务器重启后自动启动
- ✅ **后台守护进程** — 断开 SSH 也继续运行

### Q6：多人可以共用吗？

可以。每个人各自 SSH 登录，各自跑 `claude`，互不影响。

### Q7：服务器会被用爆吗？

实测 2核2G 配置，Claude Code + 代理只占 **72MB 内存**，CPU 几乎闲置，非常轻松。

---

## ⚙️ 工作原理

### 一句话

Claude Code 本来只能连接 Anthropic（Claude 官方）的 API，通过反向代理，把请求"翻译"成 DeepSeek 能理解的格式，从而实现用 DeepSeek 驱动 Claude Code。

### 核心组件

| 组件 | 作用 | 技术 |
|------|------|------|
| **Claude Code** | AI 编程 CLI，负责写代码/读文件/Git操作 | Anthropic 出品 |
| **deepseek-claude-proxy** | 反向代理，做协议转换 | Node.js |
| **SSH** | 手机连接服务器的通道 | OpenSSH |
| **DeepSeek API** | 大模型推理服务，按量计费 | deepseek-chat |

### 数据流向

```
你的问题 → Claude Code → 代理(8080) → DeepSeek API
                                              ↓
你的答案 ← Claude Code ← 代理(8080) ← DeepSeek 回复
```

### 配置文件

```json
// ~/.claude/settings.json
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:8080",
    "ANTHROPIC_API_KEY": "placeholder",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-chat",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-chat",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-chat"
  }
}
```

---

## 🔧 维护与升级

```bash
# 更新 Claude Code
sudo npm update -g @anthropic-ai/claude-code

# 更新代理
sudo npm update -g deepseek-claude-proxy

# 重启代理（更新后需要重启）
pkill -f deepseek-claude-proxy
DEEPSEEK_API_KEY=你的key nohup deepseek-claude-proxy start --port 8080 > /tmp/proxy.log 2>&1 &

# 查看代理运行日志
tail -f /tmp/proxy.log

# 查看代理状态
ps aux | grep deepseek | grep -v grep
```

---

## 📢 推广与分享

觉得好用的话，分享给朋友吧！

### 推广链接

```
阿里云 99元/年 服务器：
https://www.aliyun.com/minisite/goods?userCode=6rifipk8

一键安装脚本（SSH 连上服务器后运行）：
bash <(curl -sL http://47.101.210.146:8000/install.sh)

GitHub 项目：
https://github.com/1528018843-bit/claude-code-mobile
```

### 推荐发到哪里

| 平台 | 内容形式 | 技巧 |
|------|---------|------|
| 小红书 | 图文+截图 | 拍手机上用 Claude Code 的照片 |
| 朋友圈 | 短文案 | "¥99 一年，手机写代码自由了" |
| 知乎 | 详细教程 | 把本文档稍作修改发上去 |
| 掘金 | 技术文章 | 侧重技术实现 |
| 微信群 | 推荐语 | 配合红包效果更好 |

---

## 📜 技术说明

### 学术名称

这套方案在业界叫 **反向代理 + 协议转换网关（Reverse Proxy + Protocol Translation Gateway）**。

Claude Code 使用的是 Anthropic Messages API 格式，而 DeepSeek 使用的是 OpenAI Chat Completions 格式，代理做的事情就是把一种格式"翻译"成另一种。

### 开源协议

MIT License

---

*最后更新：2026年6月13日*
