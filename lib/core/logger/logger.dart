import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {

  SimpleLogPrinter({
    this.printCallingFunctionName = true,
    this.printCallStack = false,
    this.excludeLogsFromClasses = const [],
    this.showOnlyClass,
  });
  final bool printCallingFunctionName;
  final bool printCallStack;
  final List<String> excludeLogsFromClasses;
  final String? showOnlyClass;

  @override
  List<String> log(LogEvent event) {
    final prettyPrinter = PrettyPrinter(methodCount: 0);

    final color = prettyPrinter.levelColors?[event.level] ?? const AnsiColor.none();
    final emoji = prettyPrinter.levelEmojis?[event.level] ?? 'ℹ️';

    final callerInfo = _getCallerInfo();

    if (callerInfo != null && excludeLogsFromClasses.contains(callerInfo.split('.').first)) {
      return []; // Exclude logs from specified classes
    }

    if (showOnlyClass != null && callerInfo != null && !callerInfo.startsWith(showOnlyClass!)) {
      return []; // Show only logs from the specified class
    }

    final classAndMethod = printCallingFunctionName && callerInfo != null ? ' | $callerInfo' : '';
    final stackTraceSection = (printCallStack && event.stackTrace != null) ? '\nSTACKTRACE:\n${event.stackTrace}' : '';

    final output = '$emoji$classAndMethod - ${event.message}$stackTraceSection';

    return _splitAndColorLog(output, color);
  }

  List<String> _splitAndColorLog(String logMessage, AnsiColor color) {
    const chunkSize = 800;
    final result = <String>[];

    for (final line in logMessage.split('\n')) {
      for (var i = 0; i < line.length; i += chunkSize) {
        final chunk = line.substring(i, i + chunkSize > line.length ? line.length : i + chunkSize);
        result.add(kReleaseMode ? chunk : color(chunk));
      }
    }
    return result;
  }

  String? _getCallerInfo() {
    try {
      final currentStack = StackTrace.current.toString().split('\n');
      if (currentStack.length > 2) {
        final callerFrame = currentStack[2];
        final match = RegExp(r'#\d+\s+(\S+)\.(\S+)').firstMatch(callerFrame);
        if (match != null) {
          final className = match.group(1);
          final methodName = match.group(2)?.replaceAll('<anonymous closure>', '');
          return '$className.$methodName';
        }
      }
    } catch (_) {}
    return null;
  }
}
