#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
媒体文件整理脚本
用于将视频和图片文件按照创建日期和设备名称整理到指定文件夹
"""

import os
import shutil
import argparse
from datetime import datetime, date
from pathlib import Path
import logging

# 支持的视频文件扩展名
VIDEO_EXTENSIONS = {
    '.mp4', '.avi', '.mov', '.mkv', '.wmv', '.flv', '.webm', 
    '.m4v', '.3gp', '.mpg', '.mpeg', '.ts', '.mts', '.m2ts', '.insv', '.lrv', '.xml'
}

# 支持的图片文件扩展名
IMAGE_EXTENSIONS = {
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.tif', '.webp',
    '.svg', '.ico', '.raw', '.cr2', '.nef', '.arw', '.dng', '.orf', '.rw2',
    '.pef', '.srw', '.x3f', '.raf', '.3fr', '.fff', '.dcr', '.kdc', '.srf',
    '.mrw', '.nrw', '.rwl', '.iiq', '.heic', '.heif', '.avif'
}

def setup_logging():
    """设置日志记录"""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

def parse_date(date_string):
    """解析日期字符串，支持多种格式"""
    if date_string is None or date_string == "":
        return None
    
    if isinstance(date_string, datetime):
        return date_string.date()
    if isinstance(date_string, date):
        return date_string
    
    if isinstance(date_string, str):
        date_string = date_string.strip()
        if not date_string:
            return None
    else:
        raise ValueError(f"无法解析日期类型: {type(date_string)}")
    
    # 支持的日期格式
    date_formats = [
        '%Y-%m-%d',      # 2024-01-15
        '%Y/%m/%d',      # 2024/01/15
        '%Y%m%d',        # 20240115
        '%m-%d-%Y',      # 01-15-2024
        '%m/%d/%Y',      # 01/15/2024
        '%d-%m-%Y',      # 15-01-2024
        '%d/%m/%Y',      # 15/01/2024
    ]
    
    for fmt in date_formats:
        try:
            return datetime.strptime(date_string, fmt).date()
        except ValueError:
            continue
    
    raise ValueError(f"无法解析日期格式: {date_string}。支持的格式: YYYY-MM-DD, YYYY/MM/DD, YYYYMMDD, MM-DD-YYYY, MM/DD/YYYY, DD-MM-YYYY, DD/MM/YYYY")

def is_video_file(file_path):
    """检查文件是否为视频文件"""
    return file_path.suffix.lower() in VIDEO_EXTENSIONS

def is_image_file(file_path):
    """检查文件是否为图片文件"""
    return file_path.suffix.lower() in IMAGE_EXTENSIONS

def is_media_file(file_path, file_type):
    """根据指定类型检查文件是否为媒体文件"""
    if file_type == 'video':
        return is_video_file(file_path)
    elif file_type == 'image':
        return is_image_file(file_path)
    elif file_type == 'all':
        return is_video_file(file_path) or is_image_file(file_path)
    return False

def get_file_creation_date(file_path):
    """获取文件创建时间"""
    try:
        # 在 macOS 和 Linux 上使用 stat().st_birthtime (如果可用) 或 st_ctime
        stat_info = file_path.stat()
        
        # 尝试获取真正的创建时间 (macOS)
        if hasattr(stat_info, 'st_birthtime'):
            creation_time = stat_info.st_birthtime
        else:
            # 在 Linux 上使用 ctime
            creation_time = stat_info.st_ctime
            
        return datetime.fromtimestamp(creation_time)
    except Exception as e:
        logging.warning(f"无法获取文件 {file_path} 的创建时间: {e}")
        # 回退到修改时间
        return datetime.fromtimestamp(file_path.stat().st_mtime)

def create_date_folder_name(date, device_name):
    """创建日期文件夹名称"""
    date_str = date.strftime('%Y%m%d')
    return f"{date_str} - {device_name}"

def ensure_folder_exists(folder_path):
    """确保文件夹存在，如果不存在则创建"""
    folder_path.mkdir(parents=True, exist_ok=True)
    logging.info(f"文件夹已创建或已存在: {folder_path}")

def copy_media_file(source_file, destination_folder):
    """复制媒体文件到目标文件夹"""
    try:
        destination_file = destination_folder / source_file.name
        
        # 如果目标文件已存在，添加数字后缀
        counter = 1
        original_name = destination_file.stem
        extension = destination_file.suffix
        
        while destination_file.exists():
            new_name = f"{original_name}_{counter}{extension}"
            destination_file = destination_folder / new_name
            counter += 1
        
        shutil.copy2(source_file, destination_file)
        logging.info(f"文件已复制: {source_file.name} -> {destination_file}")
        return True
        
    except Exception as e:
        logging.error(f"复制文件失败 {source_file} -> {destination_folder}: {e}")
        return False

def organize_videos(from_dir, to_dir, device_name, file_type='video', start_date=None, end_date=None):
    """整理媒体文件的主要函数"""
    from_path = Path(from_dir)
    to_path = Path(to_dir)
    
    # 检查源文件夹是否存在
    if not from_path.exists():
        logging.error(f"源文件夹不存在: {from_dir}")
        return False
    
    # 确保目标文件夹存在
    ensure_folder_exists(to_path)
    
    # 统计信息
    total_files = 0
    processed_files = 0
    copied_files = 0
    
    file_type_name = '视频' if file_type == 'video' else '图片' if file_type == 'image' else '媒体'
    
    logging.info(f"开始整理{file_type_name}文件...")
    logging.info(f"源文件夹: {from_dir}")
    logging.info(f"目标文件夹: {to_dir}")
    logging.info(f"设备名称: {device_name}")
    logging.info(f"文件类型: {file_type}")
    if start_date:
        logging.info(f"起始日期: {start_date.strftime('%Y-%m-%d')}")
    if end_date:
        logging.info(f"终止日期: {end_date.strftime('%Y-%m-%d')}")
    
    # 遍历源文件夹中的所有文件
    for file_path in from_path.rglob('*'):
        if file_path.is_file():
            total_files += 1
            
            # 检查是否为指定类型的媒体文件
            if is_media_file(file_path, file_type):
                processed_files += 1
                
                # 获取文件创建日期
                creation_date = get_file_creation_date(file_path)
                
                # 检查日期是否在指定范围内
                if start_date and creation_date.date() < start_date:
                    continue
                if end_date and creation_date.date() > end_date:
                    continue
                
                # 创建目标文件夹名称
                folder_name = create_date_folder_name(creation_date, device_name)
                target_folder = to_path / folder_name
                
                # 确保目标文件夹存在
                ensure_folder_exists(target_folder)
                
                # 复制文件
                if copy_media_file(file_path, target_folder):
                    copied_files += 1
    
    # 输出统计信息
    logging.info(f"整理完成!")
    logging.info(f"总文件数: {total_files}")
    logging.info(f"{file_type_name}文件数: {processed_files}")
    logging.info(f"成功复制: {copied_files}")
    
    return True

def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='媒体文件整理脚本',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
使用示例:
  python video_organizer.py /path/to/source /path/to/destination "iPhone 15"
  python video_organizer.py ~/Downloads/photos ~/Photos/organized "Canon EOS R5" --type image
  python video_organizer.py ~/Downloads/media ~/Media/organized "GoPro Hero12" --type all
  python video_organizer.py ~/Downloads/videos ~/Videos/organized "DJI Mavic" --start-date 2024-01-01 --end-date 2024-12-31
  python video_organizer.py ~/Downloads/photos ~/Photos/organized "iPhone 15" --start-date 2024/06/01
        """
    )
    
    parser.add_argument(
        'from_dir',
        help='源文件夹路径（包含要整理的媒体文件）'
    )
    
    parser.add_argument(
        'to_dir',
        help='目标文件夹路径（整理后的文件存放位置）'
    )
    
    parser.add_argument(
        'device_name',
        help='设备名称（将作为文件夹名称的一部分）'
    )
    
    parser.add_argument(
        '-t', '--type',
        choices=['video', 'image', 'all'],
        default='video',
        help='要整理的文件类型: video (视频), image (图片), all (全部媒体文件，默认: video)'
    )
    
    parser.add_argument(
        '--start-date',
        type=str,
        help='起始日期，只处理此日期之后的文件。支持格式: YYYY-MM-DD, YYYY/MM/DD, YYYYMMDD 等'
    )
    
    parser.add_argument(
        '--end-date',
        type=str,
        help='终止日期，只处理此日期之前的文件。支持格式: YYYY-MM-DD, YYYY/MM/DD, YYYYMMDD 等'
    )
    
    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='显示详细日志信息'
    )
    
    args = parser.parse_args()
    
    # 设置日志
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    setup_logging()
    
    # 解析日期参数
    start_date = None
    end_date = None
    
    try:
        if args.start_date:
            start_date = parse_date(args.start_date)
            logging.info(f"设置起始日期: {start_date}")
        
        if args.end_date:
            end_date = parse_date(args.end_date)
            logging.info(f"设置终止日期: {end_date}")
        
        # 验证日期范围
        if start_date and end_date and start_date > end_date:
            logging.error("起始日期不能晚于终止日期")
            return 1
            
    except ValueError as e:
        logging.error(f"日期解析错误: {e}")
        return 1
    
    # 执行整理操作
    try:
        success = organize_videos(args.from_dir, args.to_dir, args.device_name, args.type, start_date, end_date)
        if success:
            file_type_name = '视频' if args.type == 'video' else '图片' if args.type == 'image' else '媒体'
            print(f"✅ {file_type_name}文件整理完成!")
        else:
            print("❌ 文件整理失败!")
            return 1
    except KeyboardInterrupt:
        print("\n⚠️  操作被用户中断")
        return 1
    except Exception as e:
        logging.error(f"发生未预期的错误: {e}")
        return 1
    
    return 0

if __name__ == '__main__':
    exit(main())
