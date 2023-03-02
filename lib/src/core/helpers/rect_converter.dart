import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

/// Provides json conversion for [Rect].
class RectConverter implements JsonConverter<Rect, Map> {
  const RectConverter();

  @override
  Rect fromJson(Map json) {
    return Rect.fromLTWH(
      json['left'] as double,
      json['top'] as double,
      json['width'] as double,
      json['height'] as double,
    );
  }

  @override
  Map<String, dynamic> toJson(Rect rect) {
    return {
      'left': rect.left,
      'top': rect.top,
      'width': rect.width,
      'height': rect.height,
    };
  }
}
