# Claude Code Mobile 📱

> **手机远程AI编程助手 — Claude Code + DeepSeek，不用梯子、不限地点**

[![Deploy](https://img.shields.io/badge/一键部署-阿里云99元/年-ff6a00)](https://www.aliyun.com/minisite/goods?userCode=6rifipk8)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 🌟 这是什么？

把 **Claude Code**（Anthropic 出品的 AI 编程助手）装到云服务器上，手机通过 SSH 连接，用 **DeepSeek API**（中文模型，巨便宜）来驱动。

```
手机 Termius → SSH → 云服务器 → Claude Code
                                  ↓
                          deepseek-claude-proxy (反向代理)
                                  ↓
                          DeepSeek API (¥0.5/百万token)
```

### ✨ 优势

| 优势 | 说明 |
|------|------|
| 🚫 **不用梯子** | 阿里云国内服务器，直连 |
| 📱 **手机能用** | Termius SSH 连上就行 |
| 💰 **成本极低** | 服务器 ¥99/年 + API ¥5/月 |
| 🔌 **一键安装** | 一行命令，5 分钟搞定 |
| 🧑‍🤝‍🧑 **多人共用** | 各自 SSH 互不影响 |

---

## 🚀 快速开始

### 1️⃣ 买服务器

[**阿里云 e实例 2核2G 40G 3M带宽 ¥99/年**](https://www.aliyun.com/minisite/goods?userCode=6rifipk8)

> 实测 Claude Code + 代理只占 **72MB 内存**，该配置完全够用。

### 2️⃣ 一键安装

SSH 连上服务器，运行：

```bash
bash <(curl -sL http://47.101.210.146:8000/install.sh)
```

安装过程：
1. 输入你的 [DeepSeek API Key](https://platform.deepseek.com/api_keys)
2. 等待 3-5 分钟自动安装
3. 完成！

> 💡 如果没有 DeepSeek 账号，去 [platform.deepseek.com](https://platform.deepseek.com) 注册，新用户有免费额度。

### 3️⃣ 手机连接

**① 装 Termius**（App Store / 应用商店搜索）

**② 新建主机：**

```
📋 Host：你的服务器 IP
📋 Port：2222（备用端口，防止运营商封锁 22）
📋 User：root 或 admin
📋 Password：你的服务器密码
```

**③ 连接后输入：**

```bash
claude
```

首次使用需要登录，执行 `claude auth login` 按提示完成认证。

---

## 📖 详细教程

<details>
<summary>点击展开完整安装教程</summary>

### 环境要求

- 一台云服务器（CentOS 7+ / Ubuntu 20+ / Alibaba Linux）
- 一个 [DeepSeek API Key](https://platform.deepseek.com/api_keys)
- 手机装 Termius（免费）

### 安装脚本做了什么

1. ✅ 安装 Node.js 20
2. ✅ 安装 Claude Code CLI
3. ✅ 安装 `deepseek-claude-proxy`（反向代理）
4. ✅ 配置 Claude Code 环境变量
5. ✅ 适配最新模型版本号
6. ✅ 开启 SSH 备用端口 2222
7. ✅ 启动代理并配置开机自启

### 验证是否成功

```bash
# 测试 Claude Code
echo "ping" | claude -p "say pong"

# 应该返回：pong 🏓
```

</details>

---

## ⚙️ 工作原理

| 组件 | 作用 | 端口 |
|------|------|------|
| `claude` | Anthropic 出品的 AI 编程 CLI | - |
| `deepseek-claude-proxy` | 反向代理，把 Anthropic API 请求转发到 DeepSeek | 8080 |
| SSH | 手机连接服务器的通道 | 22 / 2222 |
| 文件服务器 | 托管一键安装脚本 | 8000 |

### 配置在哪里

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

## 💡 成本估算

| 项目 | 价格 | 说明 |
|------|------|------|
| 阿里云服务器 | ¥99/年 | 2核2G 40G 3M带宽 |
| DeepSeek API | ~¥5/月 | 按量计费，写代码足够用 |
| Termius | 免费 | 手机 SSH 客户端 |
| **总计** | **~¥13/月** | 一杯奶茶钱 |

---

## ❓ 常见问题

<details>
<summary>手机连不上 SSH？</summary>

移动/联通经常封锁 22 端口，试试：
1. 把端口改成 **2222**（部署脚本已自动开启）
2. 切换 Wi-Fi / 流量
3. 换个 SSH 客户端试试
</details>

<details>
<summary>Claude Code 要求登录？</summary>

首次运行需要认证。执行：
```bash
claude auth login
```
按提示完成 OAuth 认证（需要能访问 claude.com）
</details>

<details>
<summary>报模型找不到？</summary>

代理模型列表版本号可能不匹配，指定模型运行：
```bash
claude --model deepseek-chat
```
</details>

<details>
<summary>API Key 哪里拿？</summary>

去 [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys) 注册并创建 API Key。新用户有免费额度。
</details>

<details>
<summary>可以用其他 API 吗？</summary>

可以。`deepseek-claude-proxy` 支持切换后端，改环境变量或 settings.json 的模型名即可。
</details>

---

## 🔧 维护命令

```bash
# 更新 Claude Code
sudo npm update -g @anthropic-ai/claude-code

# 更新代理
sudo npm update -g deepseek-claude-proxy

# 重启代理
pkill -f deepseek-claude-proxy
DEEPSEEK_API_KEY=你的key nohup deepseek-claude-proxy start --port 8080 > /tmp/proxy.log 2>&1 &

# 查看代理日志
tail -f /tmp/proxy.log
```

---

## 📚 学术说明

这套方案的本质是 **反向代理 + 协议转换网关**（Reverse Proxy + Protocol Translation Gateway）。Claude Code 发送 Anthropic Messages API 格式的请求，代理将其转换为 OpenAI Chat Completions 格式，转发给 DeepSeek API。

---

## 📜 许可

MIT License

## ⭐ 支持

如果这个项目对你有帮助，请给一个 Star ⭐

## 🔗 推广链接

[阿里云 99元/年 服务器购买链接](https://www.aliyun.com/minisite/goods?userCode=6rifipk8)
