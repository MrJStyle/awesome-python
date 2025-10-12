# ✅ 已完成：迁移到 uv 依赖管理

## 🎉 更新内容

项目已成功迁移到使用 [uv](https://github.com/astral-sh/uv) 作为依赖管理工具！

### 📝 主要变更

#### 1. 新增文件

- ✅ **`pyproject.toml`** - 项目配置文件，定义依赖和元数据
- ✅ **`UV_GUIDE.md`** - uv 使用指南
- ✅ **`.gitignore`** - 忽略 uv 生成的文件

#### 2. 修改文件

- ✅ **`start_ui.sh`** - 改用 uv 来同步依赖和启动程序
- ✅ **`requirements.txt`** - 改为 PEP 723 内联脚本元数据格式
- ✅ **`README.md`** - 更新安装说明，添加 uv 使用方法
- ✅ **`README_UI.md`** - 更新依赖安装部分
- ✅ **`QUICKSTART.md`** - 添加 uv 安装和使用说明

## 🚀 如何使用

### 快速启动（最简单）

```bash
./start_ui.sh
```

启动脚本会自动：
1. 检查 uv 是否安装
2. 使用 `uv sync` 同步依赖
3. 使用 `uv run` 启动 Web UI

### 手动使用 uv

```bash
# 同步依赖
uv sync

# 运行 Web UI
uv run video_organizer_ui.py

# 运行命令行工具
uv run video_organizer.py <源目录> <目标目录> <设备名称>

# 运行演示
uv run demo.py
```

## 🎯 uv 的优势

- ⚡ **速度快**: 比 pip 快 10-100 倍
- 🎯 **简单**: 无需手动管理虚拟环境
- 📦 **现代**: 支持最新的 Python 打包标准
- 🔒 **可靠**: 自动锁定依赖版本（`uv.lock`）
- 🌐 **兼容**: 完全兼容 pip 和 requirements.txt

## 📚 文档更新

所有文档已更新，包含 uv 的使用说明：

- **`README.md`** - 主文档，现在推荐使用 uv
- **`QUICKSTART.md`** - 快速开始指南，包含 uv 安装步骤
- **`README_UI.md`** - Web UI 手册，更新依赖安装方法
- **`UV_GUIDE.md`** - 新增的 uv 详细使用指南

## 🔄 向后兼容

如果你不想使用 uv，仍然可以用传统方式：

```bash
# 安装 Gradio
pip install gradio>=4.0.0

# 运行程序
python video_organizer_ui.py
```

但我们**强烈推荐使用 uv**，它会让你的开发体验更好！

## ⚙️ 技术细节

### pyproject.toml

定义了项目的配置：

```toml
[project]
name = "media-organizer"
version = "1.0.0"
requires-python = ">=3.7"
dependencies = [
    "gradio>=4.0.0",
]
```

### 启动脚本变更

**之前（使用 pip）:**
```bash
# 检查 Python
# 检查 Gradio
# pip3 install gradio>=4.0.0
python3 video_organizer_ui.py
```

**现在（使用 uv）:**
```bash
# 检查 uv
uv sync
uv run video_organizer_ui.py
```

更简洁，更快速！

## 📦 依赖管理

### 添加新依赖

```bash
uv add <package-name>
```

### 更新依赖

```bash
uv sync --upgrade
```

### 查看依赖

```bash
uv pip list
```

## 🐛 故障排除

### 如果遇到 "uv: command not found"

安装 uv：

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.zshrc  # 或 source ~/.bashrc
```

### 如果依赖同步失败

清理缓存重试：

```bash
uv cache clean
uv sync
```

### 如果想回到 pip

直接使用 pip 也可以：

```bash
pip install gradio>=4.0.0
python video_organizer_ui.py
```

## 🎊 开始使用

现在就运行启动脚本，体验 uv 的速度吧！

```bash
./start_ui.sh
```

---

**更多信息**: 查看 [`UV_GUIDE.md`](UV_GUIDE.md) 了解 uv 的详细使用方法。
