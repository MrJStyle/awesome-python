# 媒体文件整理工具

一个强大的媒体文件整理工具，可以根据文件创建时间和设备名称自动整理视频和图片文件。提供 **Web UI** 和**命令行**两种使用方式。

## ✨ 功能特点

- 🎨 **友好的 Web UI**：基于 Gradio 的图形界面，无需记忆命令行参数
- 💾 **预设配置管理**：保存和加载常用的整理配置，一键快速填充表单
- 🎥 支持 30+ 种视频格式（mp4, avi, mov, mkv 等）
- 📷 支持 40+ 种图片格式（jpg, png, raw, heic 等）
- 📅 按创建日期和设备名称自动分类
- 🎯 支持日期范围过滤
- 🔄 智能处理文件名冲突（自动添加数字后缀）
- 📁 递归扫描子文件夹
- 📊 实时日志和处理统计
- 🚫 安全复制模式，不删除源文件

## 🚀 快速开始

### 1. 安装 uv（推荐）

本项目使用 [uv](https://github.com/astral-sh/uv) 进行依赖管理：

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# 或使用 Homebrew
brew install uv
```

### 2. 启动 Web UI

最简单的方式：

```bash
cd python_tools/photography_materials_organizer
./start_ui.sh
```

启动脚本会自动：
- ✅ 检查 uv 是否安装
- ✅ 同步依赖（`uv sync`）
- ✅ 启动 Web UI
- ✅ 打开浏览器 `http://localhost:7860`

### 3. 使用 Web 界面

在浏览器中填写：
- **源文件夹**：包含要整理文件的路径
- **目标文件夹**：整理后的文件存放位置
- **设备名称**：如 `iPhone 15`、`Canon EOS R5`
- **文件类型**：选择视频/图片/全部
- **日期过滤**（可选）：设置起始/终止日期

点击 **"开始整理"** 即可。

### 4. 使用预设配置（新功能）

Web UI 现在支持预设配置管理，让你可以保存常用的整理配置并快速复用：

#### 📌 使用预设
1. 在 **"预设配置"** 区域，点击任意预设按钮
2. 表单会自动填充预设的值（源文件夹、目标文件夹、设备名称、文件类型）
3. 日期需要手动设置（预设不包括日期）
4. 点击 **"开始整理"** 执行

#### 💾 保存新预设
1. 在表单中填写好所有配置信息
2. 在 **"保存新预设配置"** 区域输入预设名称（如：我的 iPhone 视频）
3. 点击 **"💾 保存预设"**
4. 预设会保存到 `presets.json` 文件中

#### 🗑️ 删除预设
1. 在 **"删除预设配置"** 区域选择要删除的预设
2. 点击 **"🗑️ 删除"** 确认删除

#### 📝 预设配置文件
预设存储在项目目录下的 `presets.json` 文件中，你也可以直接编辑这个文件来批量管理预设。

文件格式示例：
```json
[
    {
        "name": "整理 iPhone 拍摄的视频",
        "from_dir": "/Users/john/Downloads/iPhone_Videos",
        "to_dir": "/Users/john/Videos/Organized",
        "device_name": "iPhone 15 Pro",
        "file_type": "video"
    }
]
```

## 💻 命令行使用

### 基本用法

```bash
# 使用 uv（推荐）
uv run video_organizer.py <源目录> <目标目录> <设备名称>

# 或传统方式
python video_organizer.py <源目录> <目标目录> <设备名称>
```

### 示例

```bash
# 整理视频文件
uv run video_organizer.py ~/Downloads/videos ~/Videos/organized "iPhone 15"

# 整理图片文件
uv run video_organizer.py ~/Downloads/photos ~/Photos/organized "Canon EOS R5" --type image

# 整理所有媒体文件
uv run video_organizer.py ~/Downloads/media ~/Media/organized "DJI Mavic 3" --type all

# 带日期过滤
uv run video_organizer.py ~/Downloads/photos ~/Photos/2024 "iPhone 15" \
  --start-date 2024-01-01 --end-date 2024-12-31
```

### 命令行参数

| 参数 | 说明 |
|------|------|
| `from_dir` | 源文件夹路径 |
| `to_dir` | 目标文件夹路径 |
| `device_name` | 设备名称 |
| `-t, --type` | 文件类型：`video`/`image`/`all`（默认：video） |
| `--start-date` | 起始日期（格式：YYYY-MM-DD） |
| `--end-date` | 终止日期（格式：YYYY-MM-DD） |
| `-v, --verbose` | 显示详细日志 |
| `-h, --help` | 显示帮助信息 |

## 📁 整理结果

文件会按照以下格式组织：

```
目标文件夹/
├── 20241001 - iPhone 15/
│   ├── video1.mp4
│   └── photo1.jpg
├── 20241002 - iPhone 15/
│   └── video2.mp4
└── 20241005 - iPhone 15/
    └── photo2.heic
```

## 📦 支持的文件格式

### 视频格式（30+ 种）

.mp4, .avi, .mov, .mkv, .wmv, .flv, .webm, .m4v, .3gp, .mpg, .mpeg, .ts, .mts, .m2ts, .insv, .lrv 等

### 图片格式（40+ 种）

.jpg, .jpeg, .png, .gif, .bmp, .tiff, .webp, .heic, .heif, .raw, .cr2, .nef, .arw, .dng 等

## 🔧 手动安装（不使用 uv）

如果你不想使用 uv：

```bash
# 安装依赖
pip install gradio>=4.0.0

# 启动 Web UI
python video_organizer_ui.py

# 或使用命令行
python video_organizer.py <源目录> <目标目录> <设备名称>
```

## 🎯 使用场景

- **旅行照片整理**：按日期和设备分类整理旅行素材
- **多设备管理**：iPhone、相机、无人机等多设备内容归档
- **视频剪辑素材**：按时间线组织原始素材，方便后期查找
- **定期备份**：将媒体文件整理后备份到 NAS 或外置硬盘

## 📝 日期格式

支持多种日期格式：
- `YYYY-MM-DD`（2024-01-15）
- `YYYY/MM/DD`（2024/01/15）
- `YYYYMMDD`（20240115）
- `MM-DD-YYYY`（01-15-2024）
- `DD-MM-YYYY`（15-01-2024）

## ⚙️ uv 常用命令

```bash
# 同步依赖
uv sync

# 运行脚本
uv run video_organizer_ui.py

# 添加依赖
uv add <package-name>

# 查看已安装的包
uv pip list
```

更多信息请访问：https://github.com/astral-sh/uv

## ⚠️ 注意事项

- ✅ 采用**复制模式**，不会删除源文件
- ✅ 文件重名时自动添加数字后缀
- ✅ 需要对源和目标文件夹有相应的读写权限
- ✅ 确保目标磁盘有足够空间
- ✅ 使用文件创建时间（macOS 上是 birthtime）

## 🧪 测试工具

运行演示脚本创建测试数据：

```bash
uv run demo.py
```

这会在你的 home 目录创建 `media_organizer_demo` 文件夹，包含测试文件供你练习使用。

## 📄 项目结构

```
photography_materials_organizer/
├── video_organizer.py      # 核心功能（命令行工具）
├── video_organizer_ui.py   # Web UI 界面
├── demo.py                 # 演示测试脚本
├── start_ui.sh             # 一键启动脚本
├── pyproject.toml          # 项目配置
├── requirements.txt        # 依赖配置
└── README.md               # 本文档
```

## 🐛 故障排除

### Q: uv 命令未找到？

A: 重新加载 shell 配置：
```bash
source ~/.zshrc  # 或 source ~/.bashrc
uv --version
```

### Q: Python 版本不兼容？

A: 本项目需要 Python 3.8+，检查你的版本：
```bash
python3 --version
```

### Q: 依赖同步失败？

A: 清理缓存重试：
```bash
uv cache clean
uv sync
```

### Q: 想用传统 pip 方式？

A: 完全可以：
```bash
pip install gradio>=4.0.0
python video_organizer_ui.py
```

## 📚 技术栈

- **Python 3.8+**
- **Gradio 4.0+** - Web UI 框架
- **uv** - 现代化的依赖管理工具
- **标准库** - pathlib, shutil, datetime, logging

## 📜 许可证

MIT License

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**立即开始**: 运行 `./start_ui.sh` 🚀的媒体文件整理工具，可以根据文件创建时间和设备名称自动整理视频和图片文件。提供**命令行**和 **Web UI** 两种使用方式。

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

