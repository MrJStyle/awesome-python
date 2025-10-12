#!/bin/bash
# 媒体文件整理工具 Web UI 启动脚本

echo "🚀 正在启动媒体文件整理工具 Web UI..."
echo ""

# 检查 uv 是否安装
if ! command -v uv &> /dev/null; then
    echo "❌ 错误: 未找到 uv，请先安装 uv"
    echo "   安装命令: curl -LsSf https://astral.sh/uv/install.sh | sh"
    echo "   或访问: https://github.com/astral-sh/uv"
    exit 1
fi

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 切换到脚本目录
cd "$SCRIPT_DIR"

echo "✅ 检测到 uv: $(uv --version)"
echo ""
echo "📦 正在同步依赖..."

# 使用 uv 同步依赖
uv sync

if [ $? -ne 0 ]; then
    echo "❌ 依赖同步失败"
    exit 1
fi

echo ""
echo "📂 工作目录: $SCRIPT_DIR"
echo ""
echo "🌐 Web UI 即将启动，浏览器会自动打开..."
echo "   访问地址: http://localhost:7860"
echo ""
echo "💡 提示: 按 Ctrl+C 可以停止服务器"
echo ""
echo "---"
echo ""

# 使用 uv 运行 Web UI
uv run video_organizer_ui.py
