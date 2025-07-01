# 视频素材文件整理脚本

这是一个用于自动整理视频素材文件的Python脚本，可以根据文件创建时间和设备名称将视频文件整理到指定的文件夹结构中。

## 功能特点

- 🎥 支持多种视频格式（mp4, avi, mov, mkv, wmv, flv, webm等）
- 📅 根据文件创建时间自动创建日期文件夹
- 📱 支持自定义设备名称
- 🔄 自动处理文件名冲突（添加数字后缀）
- 📁 递归扫描子文件夹
- 📊 提供详细的处理统计信息
- 🚫 只复制文件，不删除源文件

## 安装要求

- Python 3.6+
- 标准库（无需额外安装包）

## 使用方法

### 1. 命令行方式

```bash
python video_organizer.py <源文件夹> <目标文件夹> <设备名称>
```

**示例：**
```bash
# 整理iPhone拍摄的视频
python video_organizer.py ~/Downloads/iphone_videos ~/Videos/organized "iPhone 15 Pro"

# 整理GoPro视频
python video_organizer.py /Users/username/Desktop/GoPro ~/Videos/Travel "GoPro Hero12"

# 整理相机视频
python video_organizer.py ./raw_footage ./sorted_videos "Sony A7IV"
```

## 文件夹结构

脚本会在目标文件夹中创建以下格式的文件夹：

```text
目标文件夹/
├── 20250701 - iPhone 15 Pro/
│   ├── video1.mp4
│   └── video2.mov
├── 20250702 - iPhone 15 Pro/
│   └── video3.mp4
└── 20250703 - iPhone 15 Pro/
    ├── video4.mp4
    └── video5_1.mp4  # 自动添加后缀避免重名
```

## 支持的视频格式

- .mp4, .avi, .mov, .mkv, .wmv, .flv, .webm
- .m4v, .3gp, .mpg, .mpeg, .ts, .mts, .m2ts, .insv

## 命令行参数

- `from_dir`: 源文件夹路径（包含要整理的视频文件）
- `to_dir`: 目标文件夹路径（整理后的文件存放位置）
- `device_name`: 设备名称（将作为文件夹名称的一部分）
- `-v, --verbose`: 显示详细日志信息

## 注意事项

1. **安全性**: 脚本只复制文件，不会删除或移动源文件
2. **重名处理**: 如果目标位置已存在同名文件，会自动添加数字后缀
3. **权限**: 确保对源文件夹有读取权限，对目标文件夹有写入权限
4. **空间**: 确保目标磁盘有足够空间存储复制的文件
5. **中断恢复**: 如果程序被中断，可以重新运行，已存在的文件不会被重复复制

## 错误处理

脚本包含完善的错误处理机制：

- 文件读取权限错误
- 磁盘空间不足
- 路径不存在
- 文件损坏等情况

所有错误都会被记录到日志中，方便排查问题。

## 日志记录

脚本会输出详细的处理信息：

- 处理进度
- 文件复制状态
- 错误信息
- 最终统计结果

使用 `-v` 参数可以显示更详细的调试信息。

## 示例输出

```text
2025-07-01 10:30:15 - INFO - 开始整理视频文件...
2025-07-01 10:30:15 - INFO - 源文件夹: /Users/username/Downloads/videos
2025-07-01 10:30:15 - INFO - 目标文件夹: /Users/username/Videos/organized
2025-07-01 10:30:15 - INFO - 设备名称: iPhone 15 Pro
2025-07-01 10:30:15 - INFO - 文件夹已创建或已存在: /Users/username/Videos/organized/20250630 - iPhone 15 Pro
2025-07-01 10:30:16 - INFO - 文件已复制: IMG_1234.mp4 -> /Users/username/Videos/organized/20250630 - iPhone 15 Pro/IMG_1234.mp4
2025-07-01 10:30:18 - INFO - 整理完成!
2025-07-01 10:30:18 - INFO - 总文件数: 50
2025-07-01 10:30:18 - INFO - 视频文件数: 15
2025-07-01 10:30:18 - INFO - 成功复制: 15
✅ 视频文件整理完成!
```
