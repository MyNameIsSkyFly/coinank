flutter pub run pigeon \
  --input pigeons/pigeon_api.dart \
  --dart_out lib/pigeon/host_api.g.dart \
  --swift_out ios/Runner/Messages.g.swift \
  --objc_header_out ios/Classes/messages.h \
  --objc_source_out ios/Classes/messages.m \
  --objc_prefix FLT \
  --java_out android/app/src/main/java/com/ank/ankapp/pigeon_plugin/Messages.java \
  --java_package "com.ank.ankapp.pigeon_plugin"
