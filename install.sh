#!/bin/bash
# ============================================================
# Claude Code 手机远程开发 - 一键安装脚本
# 用法：bash <(curl -sL 你的链接)
# 或下载后：chmod +x install.sh && ./install.sh
# ============================================================

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Claude Code 手机远程开发 - 一键安装${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# --- 检查系统 ---
OS=""
if [ -f /etc/redhat-release ]; then OS="yum"
elif [ -f /etc/debian_version ]; then OS="apt"
else
  echo -e "${RED}✗ 不支持的系统，请使用 CentOS / Ubuntu / Alibaba Linux${NC}"
  exit 1
fi
echo -e "${GREEN}✓ 系统检测通过${NC}"

# --- 输入 API Key ---
read -p "请输入你的 DeepSeek API Key (sk-...): " API_KEY
if [ -z "$API_KEY" ]; then
  echo -e "${RED}✗ API Key 不能为空${NC}"
  exit 1
fi
echo -e "${GREEN}✓ API Key 已记录${NC}"

# --- 安装 Node.js ---
echo -e "${YELLOW}▶ 安装 Node.js 20...${NC}"
if [ "$OS" = "yum" ]; then
  curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash - > /dev/null 2>&1
  sudo yum install -y nodejs > /dev/null 2>&1
else
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash - > /dev/null 2>&1
  sudo apt-get install -y nodejs > /dev/null 2>&1
fi
echo -e "${GREEN}✓ Node.js $(node -v) 安装成功${NC}"

# --- 安装 Claude Code ---
echo -e "${YELLOW}▶ 安装 Claude Code...${NC}"
sudo npm install -g @anthropic-ai/claude-code > /dev/null 2>&1
echo -e "${GREEN}✓ Claude Code $(claude --version) 安装成功${NC}"

# --- 安装反向代理 ---
echo -e "${YELLOW}▶ 安装反向代理...${NC}"
sudo npm install -g deepseek-claude-proxy > /dev/null 2>&1
echo -e "${GREEN}✓ 反向代理安装成功${NC}"

# --- 配置 Claude Code ---
echo -e "${YELLOW}▶ 配置 Claude Code...${NC}"
mkdir -p ~/.claude
cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "ANTHROPIC_BASE_URL": "http://localhost:8080",
    "ANTHROPIC_API_KEY": "placeholder",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-chat",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-chat",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-chat"
  }
}
EOF
echo -e "${GREEN}✓ Claude Code 配置完成${NC}"

# --- 修改代理模型列表版本号 ---
echo -e "${YELLOW}▶ 适配最新 Claude Code 模型名...${NC}"
sudo sed -i 's/claude-opus-4-7/claude-opus-4-8/g' /usr/lib/node_modules/deepseek-claude-proxy/dist/proxy.js 2>/dev/null || true
sudo sed -i 's/claude-sonnet-4-6/claude-sonnet-4-8/g' /usr/lib/node_modules/deepseek-claude-proxy/dist/proxy.js 2>/dev/null || true
echo -e "${GREEN}✓ 模型名已适配${NC}"

# --- 配置 SSH 备用端口 ---
echo -e "${YELLOW}▶ 配置 SSH 备用端口 2222...${NC}"
if ! grep -q "Port 2222" /etc/ssh/sshd_config 2>/dev/null; then
  echo "Port 2222" | sudo tee -a /etc/ssh/sshd_config > /dev/null
  sudo systemctl restart sshd 2>/dev/null || sudo service sshd restart 2>/dev/null || true
fi
echo -e "${GREEN}✓ SSH 备用端口 2222 已开启${NC}"

# --- 启动代理 ---
echo -e "${YELLOW}▶ 启动反向代理...${NC}"
pkill -f deepseek-claude-proxy 2>/dev/null || true
sleep 1
DEEPSEEK_API_KEY="$API_KEY" nohup deepseek-claude-proxy start --port 8080 > /tmp/proxy.log 2>&1 &

# --- 配置开机自启 ---
echo -e "${YELLOW}▶ 配置开机自启...${NC}"
(crontab -l 2>/dev/null | grep -v deepseek; echo "@reboot nohup bash -c 'DEEPSEEK_API_KEY=$API_KEY deepseek-claude-proxy start --port 8080' > /tmp/proxy.log 2>&1 &") | crontab - 2>/dev/null || true
echo -e "${GREEN}✓ 开机自启已配置${NC}"

# --- 完成 ---
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ✅ 部署完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "服务器 IP：$(curl -s ifconfig.me 2>/dev/null || echo '请自行查询')"
echo -e "SSH 端口：22（默认）/ 2222（备用）"
echo -e "用户名：$(whoami)"
echo ""
echo -e "${YELLOW}手机连接步骤：${NC}"
echo -e "1. 手机安装 Termius"
echo -e "2. 新建 Host：IP=服务器IP  Port=2222  用户名=$(whoami)  密码=你的服务器密码"
echo -e "3. 连接成功后输入：claude"
echo ""
echo -e "${YELLOW}首次使用：${NC}"
echo -e "第一次运行 claude 需要登录，输入：claude auth login"
echo -e "按提示完成认证后即可使用"
echo ""
echo -e "${YELLOW}如果模型报错，指定模型运行：${NC}"
echo -e "claude --model deepseek-chat"
echo ""
