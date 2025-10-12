# 媒体文件整理工具 - 快速开始指南

## 🚀 快速启动

### 前置要求

本项目使用 [uv](https://github.com/astral-sh/uv) 作为依赖管理工具。

**安装 uv:**

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# 或使用 Homebrew
brew install uv
```

### 方法 1: 使用启动脚本（推荐）

```bash
cd /Users/luominzhi/Code/Personal/Python/awesome-python/python_tools/photography_materials_organizer
./start_ui.sh
```

启动脚本会自动：
- 检查 uv 是否安装
- 自动同步依赖
- 启动 Web UI
- 自动打开浏览器

### 方法 2: 手动使用 uv 启动

```bash
# 1. 进入目录
cd /Users/luominzhi/Code/Personal/Python/awesome-python/python_tools/photography_materials_organizer

# 2. 同步依赖（首次运行）
uv sync

# 3. 启动 UI
uv run video_organizer_ui.py
```

### 方法 3: 传统方式（不推荐）

如果你没有安装 uv，也可以使用传统的 pip 方式：

```bash
# 1. 安装依赖
pip install gradio>=4.0.0

# 2. 启动 UI
python video_organizer_ui.py
```

浏览器会自动打开 `http://localhost:7860`

## 📋 使用流程

### 步骤 1: 准备测试数据（可选）

如果你想测试这个工具，可以先创建一些测试文件：

```bash
# 使用内置演示脚本
uv run demo.py

# 或手动创建
mkdir -p ~/test_media/source
mkdir -p ~/test_media/organized
# cp your_videos/* ~/test_media/source/
```

### 步骤 2: 填写配置信息

在 Web 界面中填写：

1. **源文件夹路径**: 
   - 示例：`/Users/luominzhi/test_media/source`
   - 或者你实际的媒体文件路径

2. **目标文件夹路径**: 
   - 示例：`/Users/luominzhi/test_media/organized`
   - 整理后的文件会保存在这里

3. **设备名称**: 
   - 示例：`iPhone 15`, `Canon EOS R5`, `DJI Mavic 3`
   - 这个名称会出现在文件夹名称中

4. **文件类型**:
   - 仅视频文件
   - 仅图片文件
   - 所有媒体文件

5. **日期过滤（可选）**:
   - 起始日期：`2024-01-01`
   - 终止日期：`2024-12-31`

### 步骤 3: 开始整理

点击 **"🚀 开始整理"** 按钮，系统会：
- 扫描源文件夹中的所有媒体文件
- 按照创建日期分组
- 复制到目标文件夹（原文件不会被删除）
- 显示详细的处理日志

### 步骤 4: 查看结果

整理完成后，目标文件夹会有类似这样的结构：

```
organized/
├── 20241001 - iPhone 15/
│   ├── video1.mp4
│   └── video2.mov
├── 20241002 - iPhone 15/
│   ├── photo1.jpg
│   └── photo2.heic
└── 20241005 - iPhone 15/
    └── video3.mp4
```

## 🎯 实际使用场景

### 场景 1: 整理旅行照片

```
源文件夹: /Users/luominzhi/Downloads/Japan_Trip
目标文件夹: /Users/luominzhi/Photos/Travel/Japan_2024
设备名称: iPhone 15 Pro
文件类型: 仅图片文件
起始日期: 2024-03-01
终止日期: 2024-03-15
```

### 场景 2: 整理无人机视频

```
源文件夹: /Users/luominzhi/Downloads/DJI_Videos
目标文件夹: /Users/luominzhi/Videos/Drone
设备名称: DJI Mavic 3
文件类型: 仅视频文件
日期过滤: 不限制
```

### 场景 3: 整理相机拍摄的所有文件

```
源文件夹: /Volumes/SD_Card/DCIM
目标文件夹: /Users/luominzhi/Photos/Canon
设备名称: Canon EOS R5
文件类型: 所有媒体文件
日期过滤: 不限制
```

## 🔧 高级配置

### 修改服务器端口

如果 7860 端口被占用，可以编辑 `video_organizer_ui.py`：

```python
# 找到这一行
app.launch(
    server_port=7860,  # 改为其他端口，如 8080
    ...
)
```

### 允许远程访问

如果想从其他设备访问（局域网内）：

```python
app.launch(
    server_name="0.0.0.0",  # 已经是这个配置
    share=False,  # 改为 True 可以生成公网链接
    ...
)
```

### 启用分享链接

```python
app.launch(
    share=True,  # 会生成一个临时的公网访问链接
    ...
)
```

## ❓ 常见问题

### Q1: 如何停止服务器？

A: 在终端中按 `Ctrl + C`

### Q2: 源文件会被删除吗？

A: 不会，工具使用**复制模式**，源文件完全不受影响

### Q3: 如果目标文件已存在会怎样？

A: 会自动添加数字后缀，如 `video.mp4` → `video_1.mp4`

### Q4: 支持哪些视频格式？

A: 支持常见格式如 mp4, mov, avi, mkv 等，完整列表请查看界面中的"支持的文件格式"

### Q5: 文件日期是如何确定的？

A: 使用文件的创建时间（macOS 上是 birthtime）

### Q6: 可以处理子文件夹中的文件吗？

A: 可以，工具会递归扫描所有子文件夹

## 📞 获取帮助

如果遇到问题：

1. 查看日志输出中的错误信息
2. 检查文件路径是否正确
3. 确认有足够的磁盘空间
4. 检查文件和文件夹的访问权限

## 🎉 开始使用

现在运行启动脚本，开始整理你的媒体文件吧！

```bash
./start_ui.sh
```

祝使用愉快！ 🎬📸
