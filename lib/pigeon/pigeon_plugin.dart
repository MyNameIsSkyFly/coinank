import 'dart:async';

import 'package:ank_app/pigeon/host_api.g.dart';

class PigeonPlugin {
  static final _api = MessageHostApi();

  static Future<void> get toTotalOi async {
    await _api.toTotalOi();
  }
}
