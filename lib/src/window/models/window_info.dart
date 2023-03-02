import 'dart:ui';

import 'package:desktop_notes/src/src.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'window_info.freezed.dart';
part 'window_info.g.dart';

/// Collection of information about the app window.
@freezed
class WindowInfo with _$WindowInfo {
  factory WindowInfo({
    /// The window's frame.
    ///
    /// Represents the window's position and size in screen coordinates.
    @RectConverter() required Rect frame,

    /// Unique ID for the current configuration of screens.
    required String screensConfigId,
  }) = _WindowInfo;

  factory WindowInfo.fromJson(Map<String, dynamic> json) =>
      _$WindowInfoFromJson(json);
}
