# UV 依赖管理说明

本项目使用 [uv](https://github.com/astral-sh/uv) 作为 Python 包管理工具。uv 是一个极快的 Python 包安装器和解析器，用 Rust 编写。

## 🚀 为什么选择 uv？

- ⚡ **极快**: 比 pip 快 10-100 倍
- 🎯 **简单**: 无需虚拟环境管理，自动处理
- 📦 **现代**: 支持 PEP 723 内联脚本元数据
- 🔒 **可靠**: 自动锁定依赖版本
- 🌐 **兼容**: 与 pip 和 pyproject.toml 完全兼容

## 📦 安装 uv

### macOS/Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Homebrew

```bash
brew install uv
```

### Windows

```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 验证安装

```bash
uv --version
```

## 🎯 常用命令

### 同步依赖

首次使用或 `pyproject.toml` 更新后运行：

```bash
uv sync
```

这会：
- 读取 `pyproject.toml` 中的依赖
- 创建或更新虚拟环境
- 安装所有依赖
- 生成 `uv.lock` 文件

### 运行脚本

```bash
# 运行 Web UI
uv run video_organizer_ui.py

# 运行命令行工具
uv run video_organizer.py <源目录> <目标目录> <设备名称>

# 运行演示脚本
uv run demo.py
```

### 添加依赖

```bash
# 添加新的依赖
uv add <package-name>

# 添加开发依赖
uv add --dev <package-name>
```

### 移除依赖

```bash
uv remove <package-name>
```

### 更新依赖

```bash
# 更新所有依赖
uv sync --upgrade

# 更新特定包
uv add <package-name> --upgrade
```

### 查看已安装的包

```bash
uv pip list
```

## 📁 项目文件说明

### pyproject.toml

这是项目的主配置文件，定义了：
- 项目元数据（名称、版本、描述）
- Python 版本要求
- 运行时依赖
- 开发依赖
- 可执行命令

```toml
[project]
name = "media-organizer"
version = "1.0.0"
requires-python = ">=3.7"
dependencies = [
    "gradio>=4.0.0",
]
```

### uv.lock

这是 uv 自动生成的锁文件，记录了：
- 确切的依赖版本
- 依赖的依赖（传递依赖）
- 哈希值（用于验证完整性）

**注意**: 不要手动编辑此文件，它由 uv 自动管理。

### requirements.txt

保留用于 PEP 723 内联脚本元数据，支持 `uv run` 直接运行单个脚本。

## 🔧 与传统 pip 的对比

| 操作 | pip | uv |
|------|-----|-----|
| 安装依赖 | `pip install -r requirements.txt` | `uv sync` |
| 运行脚本 | `python script.py` | `uv run script.py` |
| 添加包 | 手动编辑 requirements.txt<br>+ `pip install` | `uv add package` |
| 更新包 | `pip install --upgrade package` | `uv add package --upgrade` |
| 虚拟环境 | 手动创建和激活 | 自动管理 |
| 速度 | 慢 | 快 10-100 倍 |

## 🎬 实际使用示例

### 启动 Web UI

```bash
# 方法 1: 使用启动脚本（推荐）
./start_ui.sh

# 方法 2: 手动运行
uv sync
uv run video_organizer_ui.py
```

### 整理媒体文件

```bash
# 使用 uv 运行命令行工具
uv run video_organizer.py ~/Downloads/photos ~/Photos/organized "iPhone 15"

# 带日期过滤
uv run video_organizer.py ~/Downloads/photos ~/Photos/organized "Canon EOS R5" \
  --type image --start-date 2024-01-01 --end-date 2024-12-31
```

### 运行演示

```bash
uv run demo.py
```

## 🐛 故障排除

### 问题 1: uv 命令未找到

**解决方案**: 确保 uv 已安装并在 PATH 中

```bash
# 重新加载 shell 配置
source ~/.zshrc  # 或 source ~/.bashrc

# 验证安装
which uv
uv --version
```

### 问题 2: 依赖同步失败

**解决方案**: 清理缓存并重试

```bash
# 清理 uv 缓存
uv cache clean

# 重新同步
uv sync
```

### 问题 3: Python 版本不兼容

**解决方案**: 确保 Python 版本 >= 3.7

```bash
python3 --version

# 如果版本太低，更新 Python
# macOS: brew install python@3.11
# Linux: sudo apt install python3.11
```

### 问题 4: 想要使用传统 pip

**解决方案**: 仍然可以使用 pip，但不推荐

```bash
# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate

# 安装依赖
pip install gradio>=4.0.0

# 运行
python video_organizer_ui.py
```

## 📚 更多信息

- [uv 官方文档](https://docs.astral.sh/uv/)
- [uv GitHub 仓库](https://github.com/astral-sh/uv)
- [PEP 723 - 内联脚本元数据](https://peps.python.org/pep-0723/)

## 💡 最佳实践

1. **提交 `uv.lock`**: 将 `uv.lock` 加入 git，确保团队使用相同的依赖版本
2. **定期更新**: 定期运行 `uv sync --upgrade` 更新依赖
3. **使用 uv run**: 始终用 `uv run` 运行脚本，无需手动激活虚拟环境
4. **快速开发**: uv 的速度让你可以快速迭代和测试

---

**开始使用**: 运行 `./start_ui.sh` 体验 uv 的极速体验！ 🚀
