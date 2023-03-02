import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart' as window_size;

import '../logs/logging_manager.dart';
import '../storage/storage_repository.dart';
import 'models/models.dart';

/// Represents the main window of the app.
class AppWindow {
  static late final AppWindow instance;

  AppWindow._() {
    instance = this;
    _init();
  }

  static Future<AppWindow> create() async {
    await windowManager.ensureInitialized();
    return AppWindow._();
  }

  /// Initializes the window.
  Future<void> _init() async {
    const windowOptions = WindowOptions(
      title: 'Desktop Notes',
      size: Size(500, 500),
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(
      windowOptions,
      () async {
        await _restoreWindowSizeAndPosition();
        await windowManager.setAlwaysOnBottom(true);
        // We set the window's title bar style to hidden here because
        // with it only set in the WindowOptions, the title bar sometimes
        // shows up temporarily when the window is first shown.
        await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        await windowManager.show();
      },
    );
  }

  /// Closes the app.
  void close() => exit(0);

  /// Hides the app window.
  Future<void> hide() async {
    await saveWindowSizeAndPosition();
    await windowManager.hide();
  }

  Future<void> resetPosition() async {
    await windowManager.center();
  }

  /// Saves the window's position and size.
  Future<void> saveWindowSizeAndPosition() async {
    final frame = await windowManager.getBounds();
    final screensConfigId = await _getScreensConfigId();
    final windowInfo = WindowInfo(
      frame: frame,
      screensConfigId: screensConfigId,
    );
    await StorageRepository.instance.save(
      key: screensConfigId,
      value: windowInfo.toJson(),
      storageArea: 'window',
    );
  }

  /// Returns the saved window info for the current configuration of screens.
  ///
  /// If no saved window info is found, returns null.
  Future<WindowInfo?> _getSavedWindowInfo() async {
    final screensConfigId = await _getScreensConfigId();
    final windowInfoJson = await StorageRepository.instance.get(
      screensConfigId,
      storageArea: 'window',
    );

    if (windowInfoJson == null) {
      return null;
    }

    return WindowInfo.fromJson(Map<String, dynamic>.from(windowInfoJson));
  }

  /// Returns a unique ID for the current configuration of screens.
  ///
  /// We use this ID to save the window's position and size for this specific
  /// configuration of screens. This way we can restore the window's position
  /// and size when the user switches back to this configuration of screens.
  Future<String> _getScreensConfigId() async {
    final screens = await window_size.getScreenList();
    final screenFrames = screens.map((s) => s.frame.toString()).toList();
    return base64.encode(utf8.encode(screenFrames.join()));
  }

  /// Restores the window's position and size from the saved window info.
  ///
  /// If no saved window info is found, the window is centered.
  Future<void> _restoreWindowSizeAndPosition() async {
    final savedWindowInfo = await _getSavedWindowInfo();
    if (savedWindowInfo == null) {
      await resetPosition();
      return;
    }

    final screensConfigId = await _getScreensConfigId();
    if (screensConfigId != savedWindowInfo.screensConfigId) {
      await resetPosition();
      return;
    }

    log.i('''
Restoring window size and position
top: ${savedWindowInfo.frame.top}, left: ${savedWindowInfo.frame.left}
width: ${savedWindowInfo.frame.width}, height: ${savedWindowInfo.frame.height}
screensConfigId: $screensConfigId''');
    await windowManager.setBounds(savedWindowInfo.frame);
  }
}
