#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
媒体文件整理脚本 - Web UI
使用 Gradio 提供友好的图形界面
"""

import gradio as gr
import os
from pathlib import Path
from datetime import datetime
import logging
import json
from video_organizer import (
    organize_videos,
    parse_date,
    setup_logging,
    VIDEO_EXTENSIONS,
    IMAGE_EXTENSIONS
)

# 设置日志
setup_logging()

# 预设配置文件路径
PRESETS_FILE = Path(__file__).parent / "presets.json"

def load_presets():
    """加载预设配置"""
    try:
        if PRESETS_FILE.exists():
            with open(PRESETS_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        return []
    except Exception as e:
        logging.error(f"加载预设配置失败: {e}")
        return []

def save_preset(name, from_dir, to_dir, device_name, file_type):
    """保存新的预设配置"""
    try:
        presets = load_presets()
        
        # 检查是否已存在同名预设
        existing_index = None
        for i, preset in enumerate(presets):
            if preset.get("name") == name:
                existing_index = i
                break
        
        new_preset = {
            "name": name,
            "from_dir": from_dir,
            "to_dir": to_dir,
            "device_name": device_name,
            "file_type": file_type
        }
        
        if existing_index is not None:
            # 更新现有预设
            presets[existing_index] = new_preset
            message = f"✅ 预设 '{name}' 已更新"
        else:
            # 添加新预设
            presets.append(new_preset)
            message = f"✅ 预设 '{name}' 已保存"
        
        with open(PRESETS_FILE, 'w', encoding='utf-8') as f:
            json.dump(presets, f, ensure_ascii=False, indent=4)
        
        return True, message
    except Exception as e:
        logging.error(f"保存预设配置失败: {e}")
        return False, f"❌ 保存失败: {str(e)}"

def delete_preset(name):
    """删除预设配置"""
    try:
        presets = load_presets()
        presets = [p for p in presets if p.get("name") != name]
        
        with open(PRESETS_FILE, 'w', encoding='utf-8') as f:
            json.dump(presets, f, ensure_ascii=False, indent=4)
        
        return True, f"✅ 预设 '{name}' 已删除"
    except Exception as e:
        logging.error(f"删除预设配置失败: {e}")
        return False, f"❌ 删除失败: {str(e)}"

def format_log_output(message, level="INFO"):
    """格式化日志输出"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    return f"[{timestamp}] {level}: {message}\n"

def organize_files_wrapper(
    from_dir,
    to_dir,
    device_name,
    file_type,
    start_date,
    end_date,
    progress=gr.Progress()
):
    """
    包装整理文件函数，用于 Gradio 界面
    """
    log_output = ""
    
    # 验证输入
    if not from_dir or not os.path.exists(from_dir):
        error_msg = "❌ 源文件夹不存在或未指定"
        log_output += format_log_output(error_msg, "ERROR")
        return log_output, None
    
    if not to_dir:
        error_msg = "❌ 目标文件夹未指定"
        log_output += format_log_output(error_msg, "ERROR")
        return log_output, None
    
    if not device_name:
        error_msg = "❌ 设备名称未指定"
        log_output += format_log_output(error_msg, "ERROR")
        return log_output, None
    
    # 解析日期
    start_date_obj = None
    end_date_obj = None
    
    try:
        if start_date:
            start_date_obj = parse_date(start_date)
            log_output += format_log_output(f"起始日期: {start_date_obj}")
        
        if end_date:
            end_date_obj = parse_date(end_date)
            log_output += format_log_output(f"终止日期: {end_date_obj}")
        
        if start_date_obj and end_date_obj and start_date_obj > end_date_obj:
            error_msg = "起始日期不能晚于终止日期"
            log_output += format_log_output(error_msg, "ERROR")
            return log_output, None
            
    except ValueError as e:
        log_output += format_log_output(f"日期解析错误: {e}", "ERROR")
        return log_output, None
    
    # 记录配置信息
    log_output += format_log_output(f"源文件夹: {from_dir}")
    log_output += format_log_output(f"目标文件夹: {to_dir}")
    log_output += format_log_output(f"设备名称: {device_name}")
    log_output += format_log_output(f"文件类型: {file_type}")
    
    # 创建自定义日志处理器来捕获日志
    class GradioLogHandler(logging.Handler):
        def __init__(self):
            super().__init__()
            self.logs = []
        
        def emit(self, record):
            log_entry = self.format(record)
            self.logs.append(log_entry)
    
    handler = GradioLogHandler()
    handler.setFormatter(logging.Formatter('%(message)s'))
    logger = logging.getLogger()
    logger.addHandler(handler)
    
    try:
        # 执行整理操作
        progress(0, desc="正在扫描文件...")
        
        success = organize_videos(
            from_dir,
            to_dir,
            device_name,
            file_type,
            start_date_obj,
            end_date_obj
        )
        
        # 获取日志输出
        for log_entry in handler.logs:
            log_output += log_entry + "\n"
        
        if success:
            file_type_name = '视频' if file_type == 'video' else '图片' if file_type == 'image' else '媒体'
            success_msg = f"✅ {file_type_name}文件整理完成!"
            log_output += format_log_output(success_msg, "SUCCESS")
            
            # 返回成功状态和日志
            return log_output, f"✅ 整理成功！文件已保存到: {to_dir}"
        else:
            error_msg = "❌ 文件整理失败"
            log_output += format_log_output(error_msg, "ERROR")
            return log_output, None
            
    except Exception as e:
        error_msg = f"发生错误: {str(e)}"
        log_output += format_log_output(error_msg, "ERROR")
        return log_output, None
    finally:
        logger.removeHandler(handler)

def get_supported_formats():
    """获取支持的文件格式列表"""
    video_formats = ", ".join(sorted(VIDEO_EXTENSIONS))
    image_formats = ", ".join(sorted(IMAGE_EXTENSIONS))
    return f"**支持的视频格式**: {video_formats}\n\n**支持的图片格式**: {image_formats}"

def create_ui():
    """创建 Gradio 界面"""
    
    # 自定义 CSS
    custom_css = """
    .container {
        max-width: 1200px;
        margin: auto;
    }
    .success-msg {
        color: green;
        font-weight: bold;
        padding: 10px;
        border-radius: 5px;
        background-color: #d4edda;
    }
    .info-box {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 5px;
        border-left: 4px solid #007bff;
    }
    """
    
    with gr.Blocks(
        title="媒体文件整理工具",
        theme=gr.themes.Soft(),
        css=custom_css
    ) as app:
        
        gr.Markdown(
            """
            # 📁 媒体文件整理工具
            
            这个工具可以帮助你按照创建日期和设备名称自动整理视频和图片文件。
            整理后的文件会按照 `YYYYMMDD - 设备名称` 的格式存放在不同的文件夹中。
            
            ---
            """
        )
        
        with gr.Row():
            with gr.Column(scale=2):
                # 基本配置
                gr.Markdown("### ⚙️ 基本配置")
                
                from_dir = gr.Textbox(
                    label="源文件夹路径",
                    placeholder="例如: /Users/username/Downloads/photos",
                    info="包含要整理的媒体文件的文件夹路径"
                )
                
                to_dir = gr.Textbox(
                    label="目标文件夹路径",
                    placeholder="例如: /Users/username/Photos/organized",
                    info="整理后的文件存放位置"
                )
                
                device_name = gr.Textbox(
                    label="设备名称",
                    placeholder="例如: iPhone 15, Canon EOS R5, DJI Mavic",
                    info="将作为文件夹名称的一部分"
                )
                
                file_type = gr.Radio(
                    choices=[
                        ("仅视频文件", "video"),
                        ("仅图片文件", "image"),
                        ("所有媒体文件", "all")
                    ],
                    value="video",
                    label="文件类型",
                    info="选择要整理的文件类型"
                )
                
                # 高级选项
                gr.Markdown("### 📅 日期过滤（可选）")
                
                with gr.Row():
                    start_date = gr.DateTime(
                        include_time=False,
                        type="datetime",
                        label="起始日期",
                        info="只处理此日期之后的文件（留空表示不限制）",
                        value=None
                    )
                    
                    end_date = gr.DateTime(
                        include_time=False,
                        type="datetime",
                        label="终止日期",
                        info="只处理此日期之前的文件（留空表示不限制）",
                        value=None
                    )
                
                # 操作按钮
                with gr.Row():
                    organize_btn = gr.Button(
                        "🚀 开始整理",
                        variant="primary",
                        size="lg"
                    )
                    clear_btn = gr.Button(
                        "🔄 清除",
                        variant="secondary"
                    )
            
            with gr.Column(scale=1):
                # 帮助信息
                gr.Markdown("### 📖 使用说明")
                gr.Markdown(
                    """
                    1. **源文件夹**: 选择包含要整理文件的文件夹
                    2. **目标文件夹**: 选择整理后文件的存放位置
                    3. **设备名称**: 输入拍摄设备的名称（如：iPhone 15）
                    4. **文件类型**: 选择要整理的文件类型
                    5. **日期过滤**: 可选，只处理特定日期范围内的文件
                    
                    **日期格式支持**:
                    - `YYYY-MM-DD` (2024-01-15)
                    - `YYYY/MM/DD` (2024/01/15)
                    - `YYYYMMDD` (20240115)
                    - `MM-DD-YYYY` (01-15-2024)
                    
                    **注意**: 
                    - 操作不会删除源文件，只会复制
                    - 如果目标文件已存在，会自动添加数字后缀
                    """
                )
        
        # 输出区域
        gr.Markdown("---")
        gr.Markdown("### 📊 执行日志")
        
        log_output = gr.Textbox(
            label="日志输出",
            lines=15,
            max_lines=20,
            interactive=False,
            show_copy_button=True
        )
        
        result_msg = gr.Markdown(visible=False)
        
        # 支持的格式信息
        with gr.Accordion("📋 支持的文件格式", open=False):
            gr.Markdown(get_supported_formats())
        
        # 预设配置管理
        with gr.Accordion("💡 预设配置", open=True):
            gr.Markdown("### 使用预设配置")
            gr.Markdown("点击预设按钮可以快速填充表单（不包括日期）")
            
            # 动态生成预设按钮
            presets = load_presets()
            
            if presets:
                preset_buttons = []
                with gr.Row():
                    for preset in presets:
                        btn = gr.Button(
                            f"📌 {preset['name']}", 
                            variant="secondary",
                            size="sm"
                        )
                        preset_buttons.append((btn, preset))
                
                # 删除预设区域
                gr.Markdown("---")
                gr.Markdown("### 删除预设配置")
                with gr.Row():
                    delete_preset_dropdown = gr.Dropdown(
                        choices=[p['name'] for p in presets],
                        label="选择要删除的预设",
                        interactive=True
                    )
                    delete_preset_btn = gr.Button("🗑️ 删除", variant="stop", size="sm")
                
                delete_result = gr.Markdown(visible=False)
            else:
                gr.Markdown("*暂无预设配置，请先保存一个预设。*")
                preset_buttons = []
            
            # 保存新预设
            gr.Markdown("---")
            gr.Markdown("### 保存新预设配置")
            gr.Markdown("将当前表单值保存为预设（不包括日期）")
            
            with gr.Row():
                preset_name = gr.Textbox(
                    label="预设名称",
                    placeholder="例如: 我的 iPhone 视频",
                    scale=3
                )
                save_preset_btn = gr.Button("💾 保存预设", variant="primary", size="sm", scale=1)
            
            save_result = gr.Markdown(visible=False)
        
        # 事件处理
        def update_result_visibility(log, result):
            """更新结果消息的可见性"""
            if result:
                return gr.Markdown(value=result, visible=True)
            return gr.Markdown(visible=False)
        
        def load_preset_values(preset_data):
            """加载预设值到表单"""
            return (
                preset_data.get('from_dir', ''),
                preset_data.get('to_dir', ''),
                preset_data.get('device_name', ''),
                preset_data.get('file_type', 'video')
            )
        
        def save_preset_handler(name, from_dir_val, to_dir_val, device_name_val, file_type_val):
            """保存预设处理器"""
            if not name or not name.strip():
                return gr.Markdown(value="❌ 请输入预设名称", visible=True)
            
            if not from_dir_val or not to_dir_val or not device_name_val:
                return gr.Markdown(value="❌ 请先填写完整的表单信息", visible=True)
            
            success, message = save_preset(name.strip(), from_dir_val, to_dir_val, device_name_val, file_type_val)
            return gr.Markdown(value=message, visible=True)
        
        def delete_preset_handler(preset_name):
            """删除预设处理器"""
            if not preset_name:
                return gr.Markdown(value="❌ 请选择要删除的预设", visible=True)
            
            success, message = delete_preset(preset_name)
            return gr.Markdown(value=message, visible=True)
        
        # 为每个预设按钮绑定点击事件
        for btn, preset in preset_buttons:
            btn.click(
                fn=lambda p=preset: load_preset_values(p),
                outputs=[from_dir, to_dir, device_name, file_type]
            )
        
        # 保存预设按钮事件
        save_preset_btn.click(
            fn=save_preset_handler,
            inputs=[preset_name, from_dir, to_dir, device_name, file_type],
            outputs=[save_result]
        )
        
        # 删除预设按钮事件
        if presets:
            delete_preset_btn.click(
                fn=delete_preset_handler,
                inputs=[delete_preset_dropdown],
                outputs=[delete_result]
            )
        
        organize_btn.click(
            fn=organize_files_wrapper,
            inputs=[
                from_dir,
                to_dir,
                device_name,
                file_type,
                start_date,
                end_date
            ],
            outputs=[log_output, result_msg]
        ).then(
            fn=update_result_visibility,
            inputs=[log_output, result_msg],
            outputs=[result_msg]
        )
        
        clear_btn.click(
            fn=lambda: ("", "", "", "video", None, None, "", gr.Markdown(visible=False)),
            outputs=[
                from_dir,
                to_dir,
                device_name,
                file_type,
                start_date,
                end_date,
                log_output,
                result_msg
            ]
        )
        
        # 页脚
        gr.Markdown(
            """
            ---
            <div style="text-align: center; color: #666; font-size: 0.9em;">
                💡 提示: 本工具采用复制模式，不会修改或删除源文件
            </div>
            """
        )
    
    return app

def main():
    """主函数"""
    app = create_ui()
    
    # 启动应用
    app.launch(
        server_name="0.0.0.0",
        server_port=7860,
        share=False,
        inbrowser=True,
        show_error=True
    )

if __name__ == '__main__':
    main()
