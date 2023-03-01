import 'dart:io';

/// `FileOutput` import needed due to bug in package.
/// https://github.com/leisim/logger/issues/94
// ignore: implementation_imports
import 'package:logger/src/outputs/file_output.dart';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Globally available instance available for easy logging.
late final Logger log;

/// Manages logging for the app.
class LoggingManager {
  /// The file to which logs are saved.
  final File _logFile;

  /// Singleton instance for easy access.
  static late final LoggingManager instance;

  LoggingManager._(
    this._logFile,
  ) {
    instance = this;
  }

  static Future<LoggingManager> initialize({required bool verbose}) async {
    final testing = Platform.environment.containsKey('FLUTTER_TEST');
    if (testing) {
      // Set the logger to a dummy logger during unit tests.
      log = Logger(level: Level.nothing);
      return LoggingManager._(File(''));
    }

    final dataDir = await getApplicationSupportDirectory();
    final logFile = File('${dataDir.path}${Platform.pathSeparator}log.txt');
    await _clearLogs(logFile);

    final List<LogOutput> outputs = [
      ConsoleOutput(),
      FileOutput(file: logFile),
    ];

    log = Logger(
      filter: ProductionFilter(),
      level: (verbose) ? Level.verbose : Level.info,
      output: MultiOutput(outputs),
      // Colors false because it outputs ugly escape characters to log file.
      printer: PrefixPrinter(PrettyPrinter(colors: false)),
    );

    log.v('Logger initialized.');

    return LoggingManager._(
      logFile,
    );
  }

  /// Delete the log file.
  static Future<void> _clearLogs(File logFile) async {
    try {
      await logFile.delete();
    } catch (e) {
      // Ignore.
    } finally {
      await logFile.create();
    }
  }

  /// Read the logs from this run from the log file.
  Future<String> getLogs() async => await _logFile.readAsString();

  /// Close the logger and release resources.
  void close() => log.close();
}
