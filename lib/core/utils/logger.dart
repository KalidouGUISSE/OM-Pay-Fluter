import 'package:logging/logging.dart';

/// Configuration et instance du logger global.
class AppLogger {
    static final Logger _logger = Logger('OMPayConsole');

    static void setup() {
        Logger.root.level = Level.ALL;
        Logger.root.onRecord.listen((record) {
            print('${record.level.name}: ${record.time}: ${record.message}');
        });
    }

    static Logger get logger => _logger;
}