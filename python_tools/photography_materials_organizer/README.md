# 媒体文件整理工具

这是一个强大的媒体文件整理工具，可以根据文件创建时间和设备名称自动整理视频和图片文件。提供**命令行**和 **Web UI** 两种使用方式。

## 🌟 功能特点

- 🎥 支持多种视频格式（mp4, avi, mov, mkv 等 30+ 种格式）
- 📷 支持多种图片格式（jpg, png, raw, heic 等 40+ 种格式）
- �️ **Web UI 界面**：友好的图形界面，无需记忆命令行参数
- 💻 **命令行工具**：适合自动化脚本和批处理
- �📅 根据文件创建时间自动创建日期文件夹
- 📱 支持自定义设备名称
- 🎯 支持日期范围过滤
- 🔄 自动处理文件名冲突（添加数字后缀）
- 📁 递归扫描子文件夹
- 📊 提供详细的处理统计信息和实时日志
- 🚫 只复制文件，不删除源文件（安全模式）

## 📦 安装要求

- Python 3.7+
- [uv](https://github.com/astral-sh/uv) - 快速的 Python 包管理器（推荐）
- Gradio 4.0+（仅 Web UI 需要，会自动安装）

### 安装 uv

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# 或使用 Homebrew
brew install uv
```

## 🚀 快速开始

### 方法 1: 使用 uv 启动（推荐）

最简单的方式，一键启动：

```bash
cd python_tools/photography_materials_organizer
./start_ui.sh
```

启动脚本会自动使用 uv 同步依赖并启动服务。浏览器会自动打开 `http://localhost:7860`

### 方法 2: 手动使用 uv

```bash
# 同步依赖
uv sync

# 启动 Web UI
uv run video_organizer_ui.py

# 或运行命令行工具
uv run video_organizer.py <源目录> <目标目录> <设备名称>
```

### 方法 3: 传统 pip 方式

如果你没有安装 uv，也可以使用传统方式：

```bash
# 安装依赖
pip install gradio>=4.0.0

# 启动 Web UI
python video_organizer_ui.py
```

详细使用说明请查看 [快速开始指南](QUICKSTART.md)

## 📖 使用方法


### Web UI 方式（推荐）

通过友好的图形界面操作：

1. 启动 Web UI
2. 填写配置信息（源文件夹、目标文件夹、设备名称等）
3. 可选：设置日期范围过滤
4. 点击"开始整理"按钮
5. 查看实时日志和处理结果

详细说明：[Web UI 使用指南](README_UI.md)

### 命令行方式

适合脚本化和批处理：

```bash
python video_organizer.py <源文件夹> <目标文件夹> <设备名称> [选项]
```

**基本示例：**

```bash
# 整理iPhone拍摄的视频
python video_organizer.py ~/Downloads/iphone_videos ~/Videos/organized "iPhone 15 Pro"

# 整理图片文件
python video_organizer.py ~/Downloads/photos ~/Photos/organized "Canon EOS R5" --type image

# 整理所有媒体文件
python video_organizer.py ~/Downloads/media ~/Media/organized "DJI Mavic 3" --type all
```

**高级示例（带日期过滤）：**

```bash
# 只处理 2024 年的文件
python video_organizer.py ~/Downloads/videos ~/Videos/2024 "GoPro Hero12" \
  --start-date 2024-01-01 --end-date 2024-12-31

# 只处理 6 月份的照片
python video_organizer.py ~/Downloads/photos ~/Photos/June "iPhone 15" \
  --type image --start-date 2024-06-01 --end-date 2024-06-30
```

**命令行参数：**

- `from_dir`: 源文件夹路径（包含要整理的媒体文件）
- `to_dir`: 目标文件夹路径（整理后的文件存放位置）
- `device_name`: 设备名称（将作为文件夹名称的一部分）
- `-t, --type`: 文件类型 (video/image/all，默认: video)
- `--start-date`: 起始日期（格式：YYYY-MM-DD）
- `--end-date`: 终止日期（格式：YYYY-MM-DD）
- `-v, --verbose`: 显示详细日志信息
- `-h, --help`: 显示帮助信息

## 📁 文件夹结构

脚本会在目标文件夹中创建以下格式的文件夹：

```text
目标文件夹/
├── 20241001 - iPhone 15 Pro/
│   ├── video1.mp4
│   └── photo1.jpg
├── 20241002 - iPhone 15 Pro/
│   └── video2.mp4
└── 20241005 - iPhone 15 Pro/
    ├── video3.mp4
    └── video3_1.mp4  # 自动添加后缀避免重名
```

## 📄 支持的文件格式

### 视频格式（30+ 种）

.mp4, .avi, .mov, .mkv, .wmv, .flv, .webm, .m4v, .3gp, .mpg, .mpeg, .ts, .mts, .m2ts, .insv, .lrv, .xml

### 图片格式（40+ 种）

.jpg, .jpeg, .png, .gif, .bmp, .tiff, .webp, .heic, .heif, .raw, .cr2, .nef, .arw, .dng 等

完整列表请查看源代码或 Web UI 界面。

## 📚 文档

- [快速开始指南](QUICKSTART.md) - 详细的入门教程
- [Web UI 使用手册](README_UI.md) - Web 界面完整说明
- 命令行帮助：`python video_organizer.py --help`

## ⚠️ 注意事项

1. **安全性**: 脚本使用复制模式，不会删除或移动源文件
2. **重名处理**: 如果目标位置已存在同名文件，会自动添加数字后缀（如 video_1.mp4）
3. **权限**: 确保对源文件夹有读取权限，对目标文件夹有写入权限
4. **空间**: 确保目标磁盘有足够空间存储复制的文件
5. **中断恢复**: 如果程序被中断，可以重新运行，已存在的文件不会被重复复制
6. **日期判断**: 使用文件的创建时间（macOS 上是 birthtime）

## 🐛 错误处理

脚本包含完善的错误处理机制：

- ✅ 文件读取权限错误
- ✅ 磁盘空间不足
- ✅ 路径不存在
- ✅ 文件损坏等情况
- ✅ 详细的日志记录


所有错误都会被记录到日志中，方便排查问题。

## 💻 项目结构

```
photography_materials_organizer/
├── video_organizer.py      # 核心功能模块（命令行工具）
├── video_organizer_ui.py   # Web UI 界面
├── start_ui.sh            # 一键启动脚本
├── requirements.txt       # Python 依赖
├── README.md             # 项目主文档（本文件）
├── README_UI.md          # Web UI 详细文档
└── QUICKSTART.md         # 快速开始指南
```

## 🎯 使用场景

### 场景 1: 旅行照片整理

旅行回来后，相机、手机、无人机拍摄的照片和视频混在一起，使用本工具可以快速按照日期和设备分类整理。

### 场景 2: 多设备内容归档

如果你使用多台设备拍摄（如 iPhone + 相机 + GoPro），可以分别整理每台设备的内容，最终按时间线查看所有素材。

### 场景 3: 视频剪辑素材管理

视频创作者可以用这个工具管理大量的原始素材，按拍摄日期和设备分类，方便后期查找和剪辑。

### 场景 4: 备份与归档

定期将各种设备的照片和视频整理归档到 NAS 或外置硬盘，保持良好的文件组织结构。

## 📈 示例日志输出

```text
2024-10-12 10:30:15 - INFO - 开始整理视频文件...
2024-10-12 10:30:15 - INFO - 源文件夹: /Users/username/Downloads/videos
2024-10-12 10:30:15 - INFO - 目标文件夹: /Users/username/Videos/organized
2024-10-12 10:30:15 - INFO - 设备名称: iPhone 15 Pro
2024-10-12 10:30:15 - INFO - 文件夹已创建或已存在: /Users/username/Videos/organized/20241001 - iPhone 15 Pro
2024-10-12 10:30:16 - INFO - 文件已复制: IMG_1234.mp4 -> /Users/username/Videos/organized/20241001 - iPhone 15 Pro/IMG_1234.mp4
2024-10-12 10:30:18 - INFO - 整理完成!
2024-10-12 10:30:18 - INFO - 总文件数: 50
2024-10-12 10:30:18 - INFO - 视频文件数: 15
2024-10-12 10:30:18 - INFO - 成功复制: 15
✅ 视频文件整理完成!
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📝 许可证

MIT License

## 🙏 致谢

感谢所有使用和反馈的朋友们！

---

**开始使用**: 运行 `./start_ui.sh` 或查看 [快速开始指南](QUICKSTART.md) 🚀

