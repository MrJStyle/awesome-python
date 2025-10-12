#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
媒体文件整理工具 - 演示脚本
用于创建测试数据和演示工具功能
"""

import os
import shutil
from pathlib import Path
from datetime import datetime, timedelta
import random

def create_demo_files():
    """创建演示用的测试文件"""
    
    # 创建测试目录
    base_dir = Path.home() / "media_organizer_demo"
    source_dir = base_dir / "source"
    target_dir = base_dir / "organized"
    
    # 清理并创建目录
    if base_dir.exists():
        print(f"⚠️  目录已存在: {base_dir}")
        response = input("是否删除并重新创建？(y/n): ")
        if response.lower() == 'y':
            shutil.rmtree(base_dir)
        else:
            print("取消操作")
            return None
    
    source_dir.mkdir(parents=True, exist_ok=True)
    target_dir.mkdir(parents=True, exist_ok=True)
    
    print(f"✅ 创建演示目录: {base_dir}")
    print(f"   源文件夹: {source_dir}")
    print(f"   目标文件夹: {target_dir}")
    print()
    
    # 视频文件扩展名
    video_extensions = ['.mp4', '.mov', '.avi', '.mkv']
    
    # 图片文件扩展名
    image_extensions = ['.jpg', '.png', '.heic', '.raw']
    
    # 创建不同日期的测试文件
    base_date = datetime.now() - timedelta(days=30)
    
    file_count = 0
    
    # 创建 5 个不同日期的文件组
    for i in range(5):
        # 每组日期间隔几天
        date = base_date + timedelta(days=i*3)
        date_str = date.strftime('%Y%m%d')
        
        # 每个日期创建 2-4 个文件
        num_files = random.randint(2, 4)
        
        for j in range(num_files):
            # 随机选择视频或图片
            if random.random() > 0.5:
                ext = random.choice(video_extensions)
                file_type = "video"
            else:
                ext = random.choice(image_extensions)
                file_type = "photo"
            
            # 创建文件名
            filename = f"{file_type}_{date_str}_{j+1}{ext}"
            file_path = source_dir / filename
            
            # 创建空文件（用于演示）
            file_path.write_text(f"这是一个测试文件: {filename}\n创建日期: {date}\n")
            
            # 设置文件的修改时间（模拟创建日期）
            timestamp = date.timestamp()
            os.utime(file_path, (timestamp, timestamp))
            
            file_count += 1
            print(f"   创建文件 {file_count}: {filename}")
    
    print()
    print(f"✅ 成功创建 {file_count} 个测试文件")
    print()
    print("=" * 60)
    print("📋 演示准备完成！")
    print("=" * 60)
    print()
    print("🎯 接下来你可以：")
    print()
    print("1️⃣  使用 Web UI 整理这些文件：")
    print(f"   ./start_ui.sh")
    print(f"   然后在界面中填写：")
    print(f"   - 源文件夹: {source_dir}")
    print(f"   - 目标文件夹: {target_dir}")
    print(f"   - 设备名称: Demo Device")
    print()
    print("2️⃣  使用命令行整理这些文件：")
    print(f'   python video_organizer.py "{source_dir}" "{target_dir}" "Demo Device" --type all')
    print()
    print("=" * 60)
    
    return {
        'base_dir': str(base_dir),
        'source_dir': str(source_dir),
        'target_dir': str(target_dir),
        'file_count': file_count
    }

def cleanup_demo():
    """清理演示文件"""
    base_dir = Path.home() / "media_organizer_demo"
    
    if base_dir.exists():
        print(f"🗑️  正在删除演示目录: {base_dir}")
        shutil.rmtree(base_dir)
        print("✅ 清理完成")
    else:
        print("ℹ️  演示目录不存在，无需清理")

def main():
    """主函数"""
    print("=" * 60)
    print("🎬 媒体文件整理工具 - 演示脚本")
    print("=" * 60)
    print()
    print("此脚本将创建测试文件用于演示工具功能")
    print()
    
    print("请选择操作：")
    print("1. 创建演示文件")
    print("2. 清理演示文件")
    print("3. 退出")
    print()
    
    choice = input("请输入选项 (1/2/3): ")
    print()
    
    if choice == '1':
        create_demo_files()
    elif choice == '2':
        cleanup_demo()
    elif choice == '3':
        print("👋 再见！")
    else:
        print("❌ 无效的选项")

if __name__ == '__main__':
    main()
