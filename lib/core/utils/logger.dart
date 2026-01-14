/// Utility untuk logging aplikasi
/// Membantu dalam debugging dan monitoring
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 5,
    lineLength: 75,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);


/// Logging dengan level berbeda
void logInfo(String message) => logger.i(message);
void logDebug(String message) => logger.d(message);
void logWarning(String message) => logger.w(message);
void logError(String message, [dynamic error, StackTrace? stackTrace]) {
  logger.e(message, error: error, stackTrace: stackTrace);
}
