# 摄影素材整理工具 (macOS 原生版)

一个强大的 macOS 原生媒体文件整理应用，能够根据文件的修改/创建时间和您指定的设备名称自动整理您的视频和图片素材。

项目现已使用 **Flutter / Dart** 完全重写为纯粹的 macOS 桌面端应用，拥有极速启动体验、完整的系统权限沙盒管理、以及原生的文件与目录交互逻辑。告别冗杂的 Python 虚拟环境和命令行界面！

## ✨ 核心功能特点

- 🍎 **纯正的 macOS 体验**：极速启动、系统级窗口、Dock 栏常驻图标，完美契合 Mac 用户习惯。
- 📂 **原生文件选择器**：一键调用 Finder 选择源文件夹和目标文件夹，告别手动复制粘贴路径。
- 💾 **本地预设管理**：支持保存常用的设备和路径配置（如“我的 GoPro 视频”、“iPhone 15 照片”），一键快捷填充。
- 🎥 **广泛的视频支持**：涵盖 30+ 种主流格式（`.mp4`, `.mov`, `.mkv`, `.avi`, `.ts`, `.insv` 等）。
- 📷 **全面的图片支持**：涵盖 40+ 种主流格式（`.jpg`, `.heic`, `.raw`, `.cr2`, `.dng`, `.png` 等）。
- 📅 **智能日期建档**：自动读取文件的修改时间，按照 `YYYYMMDD - 设备名` 格式生成对应的素材文件夹。
- 🎯 **原生日期区间过滤**：支持通过日历组件精准筛选需要整理的起止日期。
- 🔄 **冲突自动重命名**：智能处理重名文件，自动追加数字后缀避免覆盖。
- 📊 **实时彩色日志台**：内置运行日志输出区，成功（绿色）、跳过（黄色）、错误（红色）状态一目了然。
- 🚫 **安全复制模式**：采用纯 Copy 策略，绝对不删除或移动原始文件，保障素材安全。

## 🚀 快速体验与安装

如果你已经拿到了编译好的应用程序：

1. 打开终端（Terminal）执行以下命令，或者直接在访达 (Finder) 中双击打开：
   ```bash
   open photography_organizer_mac/build/macos/Build/Products/Release/photography_organizer_mac.app
   ```
2. **（强烈推荐）** 为了以后使用更方便，你可以将 `photography_organizer_mac.app` 拖动到你 Mac 的 **“应用程序” (Applications)** 文件夹中。

## 💻 开发与源码编译

如果你想要修改界面样式或添加新功能，你需要配置 Flutter 桌面端开发环境。

### 1. 环境准备
- 安装 [Flutter SDK](https://docs.flutter.dev/get-started/install/macos) (建议 3.0+ 版本)
- 安装最新版 **Xcode** (以支持 macOS 原生桌面端编译和沙盒签名)

### 2. 获取依赖
```bash
cd photography_organizer_mac
flutter pub get
```

### 3. 本地调试运行
在开发模式下运行应用，享受 Flutter 丝滑的 Hot Reload（热重载）体验：
```bash
flutter run -d macos
```

### 4. 打包发布版应用
当开发完成，执行以下命令构建 Release 版本的 `.app` 程序：
```bash
flutter build macos
```
编译成功后，应用本体将生成在 `build/macos/Build/Products/Release/` 目录下。

## 📁 项目源码结构

```
photography_organizer_mac/
├── lib/
│   ├── main.dart             # 应用程序入口与主题配置
│   ├── home_page.dart        # 核心 UI 界面、交互逻辑与日志面板
│   ├── organizer.dart        # 素材扫描、时间提取与文件复制引擎
│   └── preset_manager.dart   # 基于 SharedPreferences 的预设持久化管理
├── macos/                    # macOS 原生工程目录（包含 Xcode 配置和权限声明）
├── pubspec.yaml              # Flutter 依赖配置文件
└── README.md                 # 本文档
```

## 🛠 技术栈

本项目 100% 使用 Dart 语言开发。

- **框架**：[Flutter](https://flutter.dev/) - 跨平台原生渲染框架
- **原生文件选择**：[`file_picker`](https://pub.dev/packages/file_picker)
- **本地缓存**：[`shared_preferences`](https://pub.dev/packages/shared_preferences)
- **日期处理**：[`intl`](https://pub.dev/packages/intl)
- **路径解析**：[`path`](https://pub.dev/packages/path)

## ⚠️ 权限与安全性声明

本应用已经在 macOS 的 Sandbox (沙盒) 配置中（`*.entitlements`）声明了如下权限，以确保能够正常访问和整理你的素材：
- `com.apple.security.files.user-selected.read-write` (允许读写用户通过对话框手动选择的文件夹)
- `com.apple.security.files.downloads.read-write` (允许读写下载文件夹)
- 本应用没有任何网络请求，所有文件处理均在本地离线完成，100% 保护您的隐私。

## 📜 许可证
MIT License