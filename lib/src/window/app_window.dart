import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../logs/logging_manager.dart';
import '../storage/storage_repository.dart';

/// Represents the main window of the app.
class AppWindow {
  static late final AppWindow instance;

  AppWindow._() {
    instance = this;
  }

  static Future<AppWindow> init() async {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      title: 'Desktop Notes',
      size: Size(500, 500),
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(
      windowOptions,
      () async {
        await windowManager.show();
      },
    );

    return AppWindow._();
  }

  /// Closes the app.
  void close() => exit(0);

  /// Returns if available the last window size and position.
  Future<Rect?> getSavedWindowSize() async {
    String? rectJson = await StorageRepository.instance.get('windowSize');
    if (rectJson == null) return null;
    log.v('Retrieved saved window info:\n$rectJson');
    final windowRect = _rectFromJson(rectJson);
    return windowRect;
  }

  /// Hides the app window.
  Future<void> hide() async {
    await saveWindowSize();
    await windowManager.hide();
  }

  Future<void> resetPosition() async {
    await windowManager.center();
  }

  Future<void> saveWindowSize() async {
    final windowInfo = await windowManager.getBounds();
    final rectJson = windowInfo.toJson();
    log.v('Saving window info:\n$rectJson');
    await StorageRepository.instance.save(key: 'windowSize', value: rectJson);
  }

  /// Shows the app window.
  Future<void> show() async {
    final Rect? savedWindowSize = await getSavedWindowSize();
    if (savedWindowSize != null) windowManager.setBounds(savedWindowSize);
    await windowManager.show();
  }
}

extension RectHelper on Rect {
  /// Returns a Map representation of the Rect using the keys: left, top, width,
  /// height.
  Map<String, double> toMap() {
    return {
      'left': left,
      'top': top,
      'width': width,
      'height': height,
    };
  }

  /// Returns a JSON representation of the Rect.
  String toJson() => jsonEncode(toMap());
}

/// Returns a Rect from a Map representation.
Rect _rectFromMap(Map<String, double> map) {
  return Rect.fromLTWH(
    map['left']!,
    map['top']!,
    map['width']!,
    map['height']!,
  );
}

/// Returns a Rect from a JSON representation.
Rect _rectFromJson(String json) {
  final map = jsonDecode(json) as Map<String, dynamic>;
  return _rectFromMap(map.cast<String, double>());
}
