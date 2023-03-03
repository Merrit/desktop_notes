import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Set path_provider Method Channel to use a mock implementation.
void setMockPathProviderPlatform() {
  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/path_provider',
  );
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    final workingDirectory = Directory.current;
    final testTempDirectory = Directory('${workingDirectory.path}/test/tmp');

    if (!testTempDirectory.existsSync()) {
      testTempDirectory.createSync();
    }

    if (methodCall.method == 'getApplicationSupportDirectory') {
      return testTempDirectory.path;
    }

    return null;
  });
}
