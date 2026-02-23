import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Preset {
  final String name;
  final String fromDir;
  final String toDir;
  final String deviceName;
  final String fileType;

  Preset({
    required this.name,
    required this.fromDir,
    required this.toDir,
    required this.deviceName,
    required this.fileType,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'from_dir': fromDir,
        'to_dir': toDir,
        'device_name': deviceName,
        'file_type': fileType,
      };

  factory Preset.fromJson(Map<String, dynamic> json) => Preset(
        name: json['name'] ?? '',
        fromDir: json['from_dir'] ?? '',
        toDir: json['to_dir'] ?? '',
        deviceName: json['device_name'] ?? '',
        fileType: json['file_type'] ?? 'video',
      );
}

class PresetManager {
  static const _key = 'app_presets';

  static Future<List<Preset>> loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final String? presetsJson = prefs.getString(_key);
    if (presetsJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(presetsJson);
      return decoded.map((e) => Preset.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> savePreset(Preset newPreset) async {
    final presets = await loadPresets();
    final index = presets.indexWhere((p) => p.name == newPreset.name);
    
    if (index >= 0) {
      presets[index] = newPreset;
    } else {
      presets.add(newPreset);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(presets.map((e) => e.toJson()).toList()));
  }

  static Future<void> deletePreset(String name) async {
    final presets = await loadPresets();
    presets.removeWhere((p) => p.name == name);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(presets.map((e) => e.toJson()).toList()));
  }
}
