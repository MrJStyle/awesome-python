import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

const Set<String> videoExtensions = {
  '.mp4', '.avi', '.mov', '.mkv', '.wmv', '.flv', '.webm',
  '.m4v', '.3gp', '.mpg', '.mpeg', '.ts', '.mts', '.m2ts', '.insv', '.lrv', '.xml'
};

const Set<String> imageExtensions = {
  '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.webp',
  '.svg', '.ico', '.raw', '.cr2', '.nef', '.arw', '.dng', '.orf', '.rw2',
  '.pef', '.srw', '.x3f', '.raf', '.3fr', '.fff', '.dcr', '.kdc', '.srf',
  '.mrw', '.nrw', '.rwl', '.iiq', '.heic', '.heif', '.avif'
};

bool isMediaFile(File file, String fileType) {
  final ext = p.extension(file.path).toLowerCase();
  if (fileType == 'video') {
    return videoExtensions.contains(ext);
  } else if (fileType == 'image') {
    return imageExtensions.contains(ext);
  } else if (fileType == 'all') {
    return videoExtensions.contains(ext) || imageExtensions.contains(ext);
  }
  return false;
}

Future<void> organizeMedia({
  required String fromDir,
  required String toDir,
  required String deviceName,
  required String fileType,
  DateTime? startDate,
  DateTime? endDate,
  required Function(String) onLog,
  required Function() onDone,
  required Function(String) onError,
}) async {
  try {
    final fromPath = Directory(fromDir);
    final toPath = Directory(toDir);

    if (!await fromPath.exists()) {
      onLog("❌ 源文件夹不存在: $fromDir");
      onError("源文件夹不存在");
      return;
    }

    if (!await toPath.exists()) {
      await toPath.create(recursive: true);
      onLog("ℹ️ 目标文件夹已创建或已存在: $toDir");
    }

    int totalFiles = 0;
    int processedFiles = 0;
    int copiedFiles = 0;
    int skippedFiles = 0;

    String fileTypeName = fileType == 'video' ? '视频' : (fileType == 'image' ? '图片' : '媒体');

    onLog("🚀 开始整理${fileTypeName}文件...");
    onLog("📂 源文件夹: $fromDir");
    onLog("📂 目标文件夹: $toDir");
    onLog("📱 设备名称: $deviceName");
    onLog("📋 文件类型: $fileType");
    if (startDate != null) onLog("📅 起始日期: ${DateFormat('yyyy-MM-dd').format(startDate)}");
    if (endDate != null) onLog("📅 终止日期: ${DateFormat('yyyy-MM-dd').format(endDate)}");

    await for (final entity in fromPath.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        totalFiles++;

        if (isMediaFile(entity, fileType)) {
          processedFiles++;

          final stat = await entity.stat();
          // 在 macOS 上，modified 通常能够较好反映照片/视频的原始创建时间或拷贝时间
          final creationDate = stat.modified;

          // 日期过滤
          if (startDate != null && creationDate.isBefore(startDate)) continue;
          if (endDate != null && creationDate.isAfter(endDate.add(const Duration(days: 1)))) continue;

          // 构造目标文件夹
          final dateStr = DateFormat('yyyyMMdd').format(creationDate);
          final folderName = "$dateStr - $deviceName";
          final targetFolder = Directory(p.join(toPath.path, folderName));

          if (!await targetFolder.exists()) {
            await targetFolder.create(recursive: true);
            onLog("ℹ️ 创建文件夹: $folderName");
          }

          final targetFile = File(p.join(targetFolder.path, p.basename(entity.path)));

          if (await targetFile.exists()) {
            onLog("⏭️ 文件已存在，跳过: ${p.basename(entity.path)}");
            skippedFiles++;
          } else {
            await entity.copy(targetFile.path);
            onLog("✅ 文件已复制: ${p.basename(entity.path)} -> $folderName");
            copiedFiles++;
          }
        }
      }
    }

    onLog("🎉 整理完成!");
    onLog("📊 总文件数: $totalFiles");
    onLog("📊 ${fileTypeName}文件数: $processedFiles");
    onLog("✅ 成功复制: $copiedFiles");
    onLog("⏭️ 跳过文件: $skippedFiles");
    onDone();

  } catch (e, stack) {
    onLog("❌ 发生错误: $e");
    onError(e.toString());
  }
}
