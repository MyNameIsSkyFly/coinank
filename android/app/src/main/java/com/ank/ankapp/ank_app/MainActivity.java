package com.ank.ankapp.ank_app;

import androidx.annotation.NonNull;

import com.ank.ankapp.ank_app.pigeon_plugin.Messages;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    Messages.MessageFlutterApi messageFlutterApi;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Messages.MessageHostApi.setUp(flutterEngine.getDartExecutor(), new HostMessageHandler());
        messageFlutterApi = new Messages.MessageFlutterApi(flutterEngine.getDartExecutor());
    }

    static class HostMessageHandler implements Messages.MessageHostApi {

        @Override
        public void toTotalOi() {

        }
    }
}
