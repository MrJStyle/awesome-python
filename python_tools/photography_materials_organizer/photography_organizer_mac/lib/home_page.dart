import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';
import 'preset_manager.dart';
import 'organizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _fromDirController = TextEditingController();
  final TextEditingController _toDirController = TextEditingController();
  final TextEditingController _deviceController = TextEditingController();
  final TextEditingController _presetNameController = TextEditingController();

  String _selectedType = 'video';
  DateTime? _startDate;
  DateTime? _endDate;

  List<Preset> _presets = [];
  List<String> _logs = [];
  final ScrollController _logScrollController = ScrollController();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadPresets();
    _appendLog("欢迎使用媒体整理工具 macOS 版!");
  }

  // ── Data helpers ──────────────────────────────────────────────────────────

  Future<void> _loadPresets() async {
    final presets = await PresetManager.loadPresets();
    setState(() => _presets = presets);
  }

  void _appendLog(String message) {
    setState(() {
      final ts = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      _logs.add("[$ts] $message");
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_logScrollController.hasClients) {
        _logScrollController.animateTo(
          _logScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickDirectory(TextEditingController c) async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir != null) setState(() => c.text = dir);
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => isStart ? _startDate = picked : _endDate = picked);
    }
  }

  void _applyPreset(Preset p) {
    setState(() {
      _fromDirController.text = p.fromDir;
      _toDirController.text = p.toDir;
      _deviceController.text = p.deviceName;
      _selectedType = p.fileType;
    });
    _appendLog("✅ 预设 '${p.name}' 已加载");
  }

  Future<void> _savePresetDialog() async {
    _presetNameController.text = "";
    return showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text(
              '保存预设',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            content: TextField(
              controller: _presetNameController,
              decoration: const InputDecoration(hintText: "请输入预设名称"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: GlassTokens.of(context).textSecondary,
                  ),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final name = _presetNameController.text.trim();
                  if (name.isNotEmpty) {
                    await PresetManager.savePreset(
                      Preset(
                        name: name,
                        fromDir: _fromDirController.text,
                        toDir: _toDirController.text,
                        deviceName: _deviceController.text,
                        fileType: _selectedType,
                      ),
                    );
                    await _loadPresets();
                    _appendLog("✅ 预设 '$name' 已保存");
                  }
                  if (mounted) Navigator.of(ctx).pop();
                },
                child: const Text('保存'),
              ),
            ],
          ),
    );
  }

  Future<void> _deletePreset(String name) async {
    await PresetManager.deletePreset(name);
    await _loadPresets();
    _appendLog("🗑️ 预设 '$name' 已删除");
  }

  void _startOrganizing() async {
    if (_fromDirController.text.isEmpty ||
        _toDirController.text.isEmpty ||
        _deviceController.text.isEmpty) {
      _appendLog("❌ 错误: 请填写源文件夹、目标文件夹和设备名称");
      return;
    }
    setState(() {
      _isProcessing = true;
      _logs.clear();
    });
    _appendLog("启动整理任务...");
    await organizeMedia(
      fromDir: _fromDirController.text,
      toDir: _toDirController.text,
      deviceName: _deviceController.text,
      fileType: _selectedType,
      startDate: _startDate,
      endDate: _endDate,
      onLog: (msg) => _appendLog(msg),
      onDone: () => setState(() => _isProcessing = false),
      onError: (msg) => setState(() => _isProcessing = false),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final t = GlassTokens.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Ambient background blobs (for glass refraction effect) ──
          _buildAmbientBackground(t),
          // ── Content ──
          Column(
            children: [
              _buildHeader(t),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      // ── Left: Form + Logs ──
                      Expanded(flex: 5, child: _buildLeftPanel(t)),
                      const SizedBox(width: 16),
                      // ── Right: Presets ──
                      Expanded(flex: 2, child: _buildRightPanel(t)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Ambient background ──

  Widget _buildAmbientBackground(GlassTokens t) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Top-left gradient blob
          Positioned(
            top: -80,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    t.primary.withValues(alpha: t.isDark ? 0.12 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Bottom-right gradient blob
          Positioned(
            bottom: -100,
            right: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (t.isDark
                            ? const Color(0xFF64D2FF)
                            : const Color(0xFF34C759))
                        .withValues(alpha: t.isDark ? 0.08 : 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──

  Widget _buildHeader(GlassTokens t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 17,
                color: t.primary.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 10),
              Text(
                '摄影素材整理工具',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: t.textSecondary,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(width: 8),
              _buildPillBadge('macOS', t),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, t.inputBorder, Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillBadge(String text, GlassTokens t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: t.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: t.primary.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: t.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  // ── Left Panel ──

  Widget _buildLeftPanel(GlassTokens t) {
    return GlassPanel(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('配置参数', Icons.tune_rounded, t),
          const SizedBox(height: 20),

          // Source dir
          _buildDirRow(_fromDirController, '源文件夹', '包含未整理的文件', t),
          const SizedBox(height: 14),

          // Target dir
          _buildDirRow(_toDirController, '目标文件夹', '整理后存放的位置', t),
          const SizedBox(height: 14),

          // Device + type
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _deviceController,
                  decoration: const InputDecoration(
                    labelText: '设备名称',
                    hintText: '如: iPhone 15',
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(labelText: '文件类型'),
                  dropdownColor:
                      t.isDark
                          ? const Color(0xFF1E1E36)
                          : const Color(0xFFF5F5FA),
                  borderRadius: BorderRadius.circular(14),
                  items: const [
                    DropdownMenuItem(
                      value: 'video',
                      child: Text('视频  Video', style: TextStyle(fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: 'image',
                      child: Text('图片  Image', style: TextStyle(fontSize: 13)),
                    ),
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('全部  All', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedType = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Date filters
          Row(
            children: [
              Expanded(child: _buildDateCell(true, t)),
              const SizedBox(width: 14),
              Expanded(child: _buildDateCell(false, t)),
              if (_startDate != null || _endDate != null) ...[
                const SizedBox(width: 8),
                _glassIconBtn(Icons.close_rounded, '清除日期', t, () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                  });
                }),
              ],
            ],
          ),
          const SizedBox(height: 28),

          // Action buttons
          _buildActionRow(t),
          const SizedBox(height: 28),

          // Log section
          _sectionLabel(
            '运行日志',
            Icons.terminal_rounded,
            t,
            trailing:
                _isProcessing
                    ? SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: t.primary.withValues(alpha: 0.7),
                      ),
                    )
                    : Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: t.logSuccess.withValues(alpha: 0.65),
                        shape: BoxShape.circle,
                      ),
                    ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildLogArea(t)),
        ],
      ),
    );
  }

  // ── Directory row ──

  Widget _buildDirRow(
    TextEditingController c,
    String label,
    String hint,
    GlassTokens t,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: c,
            decoration: InputDecoration(labelText: label, hintText: hint),
          ),
        ),
        const SizedBox(width: 10),
        _glassIconBtn(
          Icons.folder_open_rounded,
          '选择文件夹',
          t,
          () => _pickDirectory(c),
        ),
      ],
    );
  }

  // ── Date cell ──

  Widget _buildDateCell(bool isStart, GlassTokens t) {
    final date = isStart ? _startDate : _endDate;
    return InkWell(
      onTap: () => _pickDate(isStart),
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: isStart ? '起始日期' : '终止日期',
          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 15,
            color: t.textSecondary,
          ),
        ),
        child: Text(
          date != null ? DateFormat('yyyy-MM-dd').format(date) : '可选',
          style: TextStyle(
            color: date != null ? t.textPrimary : t.textTertiary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ── Action buttons ──

  Widget _buildActionRow(GlassTokens t) {
    return Row(
      children: [
        // Gradient start button
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient:
                  _isProcessing
                      ? null
                      : LinearGradient(colors: t.primaryGradient),
              color: _isProcessing ? t.inputFill : null,
            ),
            child: FilledButton.icon(
              onPressed: _isProcessing ? null : _startOrganizing,
              icon:
                  _isProcessing
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: t.textSecondary,
                          strokeWidth: 1.8,
                        ),
                      )
                      : const Icon(Icons.play_arrow_rounded, size: 20),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 13),
                child: Text('开始整理'),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Save preset button
        OutlinedButton.icon(
          onPressed: _isProcessing ? null : _savePresetDialog,
          icon: const Icon(Icons.bookmark_add_outlined, size: 17),
          label: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text('保存预设'),
          ),
        ),
      ],
    );
  }

  // ── Log area ──

  Widget _buildLogArea(GlassTokens t) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: t.logBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.glassBorderOuter, width: 0.5),
          ),
          padding: const EdgeInsets.all(14),
          child: ListView.builder(
            controller: _logScrollController,
            itemCount: _logs.length,
            itemBuilder: (_, i) {
              final log = _logs[i];
              Color c = t.logDefault;
              if (log.contains('❌') || log.contains('错误')) {
                c = t.logError;
              } else if (log.contains('⏭️')) {
                c = t.logWarning;
              } else if (log.contains('✅') || log.contains('完成')) {
                c = t.logSuccess;
              } else if (log.contains('ℹ️') ||
                  log.contains('🚀') ||
                  log.contains('📂') ||
                  log.contains('启动')) {
                c = t.logInfo;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  log,
                  style: TextStyle(
                    color: c,
                    fontFamily: 'Menlo',
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Right Panel: Presets ──

  Widget _buildRightPanel(GlassTokens t) {
    return GlassPanel(
      fillOverride: t.panelFillAlt,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('已保存的预设', Icons.bookmarks_outlined, t),
          const SizedBox(height: 16),
          if (_presets.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 36,
                      color: t.textTertiary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '暂无预设',
                      style: TextStyle(color: t.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '在左侧填写配置后保存',
                      style: TextStyle(color: t.textTertiary, fontSize: 11),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _presets.length,
                itemBuilder:
                    (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildPresetCard(_presets[i], t),
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPresetCard(Preset p, GlassTokens t) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _applyPreset(p),
        borderRadius: BorderRadius.circular(14),
        hoverColor: t.primary.withValues(alpha: 0.05),
        splashColor: t.primary.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: t.cardFill,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: t.glassBorderOuter, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bookmark_rounded,
                    size: 15,
                    color: t.primary.withValues(alpha: 0.65),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: t.textPrimary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _deletePreset(p.name),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close_rounded,
                        size: 13,
                        color: t.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _presetMeta(Icons.devices_rounded, p.deviceName, t),
              const SizedBox(height: 3),
              _presetMeta(
                Icons.filter_rounded,
                p.fileType == 'video'
                    ? '视频'
                    : p.fileType == 'image'
                    ? '图片'
                    : '全部',
                t,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _presetMeta(IconData icon, String text, GlassTokens t) {
    return Row(
      children: [
        Icon(icon, size: 11, color: t.textTertiary),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 11, color: t.textSecondary)),
      ],
    );
  }

  // ── Shared widgets ──

  Widget _sectionLabel(
    String title,
    IconData icon,
    GlassTokens t, {
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15, color: t.primary.withValues(alpha: 0.55)),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: t.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing],
      ],
    );
  }

  Widget _glassIconBtn(
    IconData icon,
    String tooltip,
    GlassTokens t,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: t.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.inputBorder, width: 0.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 17, color: t.textSecondary),
        onPressed: onTap,
        tooltip: tooltip,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(),
      ),
    );
  }
}
