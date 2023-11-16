package com.ank.ankapp.ank_app;

import android.content.Intent;

import androidx.annotation.NonNull;

import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;
import com.ank.ankapp.ank_app.original.activity.CommonFragmentActivity;
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

    class HostMessageHandler implements Messages.MessageHostApi {

        @Override
        public void toTotalOi() {
            Intent i = new Intent();
            i.setClass(getActivity(), CommonFragmentActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.putExtra(Config.INDEX_TYPE, Config.TYPE_EXCHANGE_OI_FRAGMENT);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_open_interest));
            Global.showActivity(getActivity(), i);
        }
    }
}
