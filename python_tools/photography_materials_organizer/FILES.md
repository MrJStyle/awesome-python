# 📦 项目文件说明

本文档介绍媒体文件整理工具中各个文件的作用和使用方法。

## 📁 文件列表

### 核心功能文件

#### 1. `video_organizer.py` ⭐
**核心功能模块，命令行工具**

- 包含所有文件整理的核心逻辑
- 支持视频和图片文件整理
- 可以作为独立的命令行工具使用
- 也被 Web UI 调用

**使用方法：**
```bash
python video_organizer.py <源目录> <目标目录> <设备名称> [选项]
```

#### 2. `video_organizer_ui.py` 🖥️
**Web UI 界面**

- 基于 Gradio 构建的图形界面
- 调用 `video_organizer.py` 中的核心功能
- 提供友好的交互体验
- 实时日志显示

**使用方法：**
```bash
python video_organizer_ui.py
```

### 启动脚本

#### 3. `start_ui.sh` 🚀
**一键启动脚本（推荐使用）**

- 自动检查 Python 环境
- 自动安装缺失的依赖（Gradio）
- 启动 Web UI
- 自动打开浏览器

**使用方法：**
```bash
./start_ui.sh
```

### 配置文件

#### 4. `requirements.txt` 📋
**Python 依赖列表**

- 列出所有需要的 Python 包
- 目前只需要 Gradio

**使用方法：**
```bash
pip install -r requirements.txt
```

### 文档文件

#### 5. `README.md` 📖
**项目主文档**

- 项目概述
- 功能特点
- 快速开始
- 使用方法（Web UI 和命令行）
- 支持的格式
- 注意事项

#### 6. `README_UI.md` 📱
**Web UI 详细使用手册**

- Web UI 的完整说明
- 安装依赖
- 界面使用步骤
- 使用示例
- 故障排除

#### 7. `QUICKSTART.md` 🎯
**快速开始指南**

- 详细的入门教程
- 使用流程
- 实际使用场景
- 高级配置
- 常见问题

#### 8. `FILES.md` 📄
**项目文件说明（本文件）**

- 说明每个文件的作用
- 提供使用建议

### 工具脚本

#### 9. `demo.py` 🎬
**演示脚本**

- 创建测试数据
- 用于演示工具功能
- 清理演示文件

**使用方法：**
```bash
python demo.py
```

## 🎯 使用建议

### 对于新手用户

1. 先阅读 `README.md` 了解项目概况
2. 查看 `QUICKSTART.md` 学习如何开始使用
3. 运行 `./start_ui.sh` 启动 Web UI
4. 如果需要，运行 `python demo.py` 创建测试数据

### 对于进阶用户

1. 阅读 `README_UI.md` 了解 Web UI 的高级功能
2. 使用命令行工具 `video_organizer.py` 进行批处理
3. 将工具集成到自己的自动化脚本中

### 对于开发者

1. 查看 `video_organizer.py` 源代码了解核心逻辑
2. 查看 `video_organizer_ui.py` 了解如何构建 Gradio 界面
3. 根据需要修改和扩展功能

## 📊 文件依赖关系

```
video_organizer.py (核心模块)
    ↑
    │ 被调用
    │
video_organizer_ui.py (Web UI)
    ↑
    │ 被启动
    │
start_ui.sh (启动脚本)
```

```
requirements.txt → 定义依赖 → gradio
```

```
README.md (主文档)
    ├── QUICKSTART.md (快速开始)
    ├── README_UI.md (UI 手册)
    └── FILES.md (本文件)
```

## 🔧 开发建议

### 添加新功能

1. 如果是核心功能，修改 `video_organizer.py`
2. 如果是 UI 功能，修改 `video_organizer_ui.py`
3. 更新相关文档

### 修改启动脚本

编辑 `start_ui.sh`，例如修改端口号、添加环境检查等

### 添加新依赖

1. 在 `requirements.txt` 中添加
2. 在 `start_ui.sh` 中可选择性地添加自动安装逻辑

## 🎨 自定义建议

### 修改 UI 主题

在 `video_organizer_ui.py` 中找到：

```python
with gr.Blocks(
    theme=gr.themes.Soft(),  # 修改这里
    ...
)
```

可选主题：
- `gr.themes.Soft()` - 柔和主题
- `gr.themes.Base()` - 基础主题
- `gr.themes.Glass()` - 玻璃主题
- `gr.themes.Monochrome()` - 单色主题

### 修改服务器配置

在 `video_organizer_ui.py` 的 `main()` 函数中：

```python
app.launch(
    server_name="0.0.0.0",  # 监听地址
    server_port=7860,       # 端口号
    share=False,            # 是否生成公网链接
    inbrowser=True,         # 是否自动打开浏览器
    ...
)
```

### 添加新的文件格式

在 `video_organizer.py` 中修改：

```python
VIDEO_EXTENSIONS = {
    '.mp4', '.avi', ...
    '.your_format',  # 添加新格式
}

IMAGE_EXTENSIONS = {
    '.jpg', '.png', ...
    '.your_format',  # 添加新格式
}
```

## 📦 打包建议

如果想要分发这个工具，可以：

1. **使用 PyInstaller 打包为可执行文件**
   ```bash
   pip install pyinstaller
   pyinstaller --onefile --windowed video_organizer_ui.py
   ```

2. **创建 Python 包**
   - 添加 `setup.py`
   - 使用 `setuptools` 打包
   - 上传到 PyPI

3. **Docker 容器化**
   - 创建 `Dockerfile`
   - 构建 Docker 镜像
   - 方便部署和分发

## 💡 最佳实践

1. **定期备份**: 虽然工具使用复制模式，但建议定期备份重要文件
2. **测试先行**: 使用 `demo.py` 创建测试数据，先测试再处理真实文件
3. **日志保存**: 重要操作时可以将日志重定向到文件保存
4. **权限检查**: 确保对源和目标目录有适当的读写权限

## 🚀 快速参考

### 启动 Web UI
```bash
./start_ui.sh
```

### 命令行使用
```bash
python video_organizer.py <源目录> <目标目录> <设备名称>
```

### 创建测试数据
```bash
python demo.py
```

### 安装依赖
```bash
pip install -r requirements.txt
```

### 查看帮助
```bash
python video_organizer.py --help
```

---

**提示**: 如果对任何文件有疑问，可以直接查看其源代码，所有文件都有详细的注释！
