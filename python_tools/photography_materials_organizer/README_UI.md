# 媒体文件整理工具 - Web UI

这是一个基于 Gradio 的媒体文件整理工具的 Web 界面，可以帮助你方便地按照创建日期和设备名称自动整理视频和图片文件。

## 功能特点

- 🎨 **友好的图形界面**：无需记忆命令行参数
- 📁 **智能文件整理**：按照日期和设备名称自动分类
- 🎬 **多格式支持**：支持常见的视频和图片格式
- 📅 **日期过滤**：可以只处理特定日期范围内的文件
- 🔒 **安全操作**：采用复制模式，不会修改或删除源文件
- 📊 **实时日志**：查看整理过程的详细信息

## 安装依赖

本项目使用 [uv](https://github.com/astral-sh/uv) 进行依赖管理。

### 方法 1: 使用 uv（推荐）

```bash
# 安装 uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# 同步依赖
uv sync
```

### 方法 2: 使用 pip

如果你不想使用 uv，也可以用传统的 pip：

```bash
pip install gradio>=4.0.0
```

## 使用方法

### 启动 Web 界面

在终端中运行：

```bash
cd /path/to/photography_materials_organizer
python video_organizer_ui.py
```

或者直接运行：

```bash
python video_organizer_ui.py
```

程序会自动打开浏览器，访问 `http://localhost:7860`

### 界面使用步骤

1. **输入源文件夹路径**：选择包含要整理文件的文件夹
2. **输入目标文件夹路径**：选择整理后文件的存放位置
3. **输入设备名称**：输入拍摄设备的名称（如：iPhone 15）
4. **选择文件类型**：
   - 仅视频文件
   - 仅图片文件
   - 所有媒体文件
5. **（可选）设置日期过滤**：
   - 起始日期：只处理此日期之后的文件
   - 终止日期：只处理此日期之前的文件
6. **点击"开始整理"按钮**：执行整理操作
7. **查看日志输出**：了解整理过程和结果

### 使用示例

#### 示例 1: 整理 iPhone 拍摄的视频

- **源文件夹**: `/Users/john/Downloads/iPhone_Videos`
- **目标文件夹**: `/Users/john/Videos/Organized`
- **设备名称**: `iPhone 15 Pro`
- **文件类型**: 仅视频文件

整理后的文件会保存在类似这样的文件夹中：
- `/Users/john/Videos/Organized/20241001 - iPhone 15 Pro/`
- `/Users/john/Videos/Organized/20241002 - iPhone 15 Pro/`

#### 示例 2: 整理相机拍摄的照片（带日期过滤）

- **源文件夹**: `/Users/john/Downloads/Camera_Photos`
- **目标文件夹**: `/Users/john/Photos/Organized`
- **设备名称**: `Canon EOS R5`
- **文件类型**: 仅图片文件
- **起始日期**: `2024-06-01`
- **终止日期**: `2024-06-30`

只会处理 2024 年 6 月的照片。

#### 示例 3: 整理无人机拍摄的所有媒体文件

- **源文件夹**: `/Users/john/Downloads/Drone`
- **目标文件夹**: `/Users/john/Media/Organized`
- **设备名称**: `DJI Mavic 3`
- **文件类型**: 所有媒体文件

会同时整理视频和图片文件。

## 支持的文件格式

### 视频格式
.mp4, .avi, .mov, .mkv, .wmv, .flv, .webm, .m4v, .3gp, .mpg, .mpeg, .ts, .mts, .m2ts, .insv, .lrv, .xml

### 图片格式
.jpg, .jpeg, .png, .gif, .bmp, .tiff, .tif, .webp, .svg, .ico, .raw, .cr2, .nef, .arw, .dng, .orf, .rw2, .pef, .srw, .x3f, .raf, .3fr, .fff, .dcr, .kdc, .srf, .mrw, .nrw, .rwl, .iiq, .heic, .heif, .avif

## 支持的日期格式

- `YYYY-MM-DD` (2024-01-15)
- `YYYY/MM/DD` (2024/01/15)
- `YYYYMMDD` (20240115)
- `MM-DD-YYYY` (01-15-2024)
- `MM/DD/YYYY` (01/15/2024)
- `DD-MM-YYYY` (15-01-2024)
- `DD/MM/YYYY` (15/01/2024)

## 命令行版本

如果你更喜欢使用命令行，可以使用 `video_organizer.py`：

```bash
# 基本用法
python video_organizer.py /path/to/source /path/to/destination "Device Name"

# 整理图片文件
python video_organizer.py ~/Downloads/photos ~/Photos/organized "Canon EOS R5" --type image

# 带日期过滤
python video_organizer.py ~/Downloads/videos ~/Videos/organized "DJI Mavic" --start-date 2024-01-01 --end-date 2024-12-31

# 查看帮助
python video_organizer.py --help
```

## 注意事项

- ⚠️ 本工具采用**复制模式**，不会修改或删除源文件
- 🔄 如果目标文件已存在，会自动添加数字后缀（如：`video_1.mp4`）
- 📂 文件夹命名格式：`YYYYMMDD - 设备名称`（如：`20241012 - iPhone 15`）
- 🕐 文件日期基于文件的创建时间（在 macOS 上使用 birthtime）

## 故障排除

### 问题 1: Gradio 导入错误

如果遇到 `ModuleNotFoundError: No module named 'gradio'`，请安装 gradio：

```bash
pip install gradio
```

### 问题 2: 端口被占用

如果 7860 端口被占用，可以修改 `video_organizer_ui.py` 中的端口号：

```python
app.launch(
    server_port=8080,  # 改为其他端口
    ...
)
```

### 问题 3: 浏览器没有自动打开

手动访问：`http://localhost:7860`

## 技术栈

- **Python 3.7+**
- **Gradio 4.0+**: Web UI 框架
- **标准库**: pathlib, shutil, datetime, logging

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！

## 更新日志

### v1.0.0 (2024-10-12)
- 首次发布
- 基于 Gradio 的 Web UI
- 支持视频和图片文件整理
- 支持日期过滤功能
- 实时日志显示
