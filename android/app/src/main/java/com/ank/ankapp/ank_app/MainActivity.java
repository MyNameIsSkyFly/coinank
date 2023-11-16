package com.ank.ankapp.ank_app;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;

import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;
import com.ank.ankapp.ank_app.original.activity.CommonFragmentActivity;
import com.ank.ankapp.ank_app.original.language.LanguageUtil;
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

        @Override
        public void changeDarkMode(@NonNull Boolean isDark) {
            Config.getMMKV(getActivity()).putBoolean(Config.DAY_NIGHT_MODE, isDark);
            AppCompatDelegate.setDefaultNightMode(isDark ? AppCompatDelegate.MODE_NIGHT_YES : AppCompatDelegate.MODE_NIGHT_NO);

            Config.getMMKV(getActivity()).async();
        }

        @Override
        public void changeLanguage(@NonNull String languageCode) {
            if (languageCode.contains("en")) {
                LanguageUtil.changeAppLanguage(getContext(), "en");
            } else if (languageCode.contains("ja")) {
                LanguageUtil.changeAppLanguage(getContext(), "ja");
            } else if (languageCode.contains("ko")) {
                LanguageUtil.changeAppLanguage(getContext(), "ko");
            } else if (languageCode.contains("zh")) {
                if (languageCode.contains("Hans")) {
                    LanguageUtil.changeAppLanguage(getContext(), "zh_rCN");
                } else {
                    LanguageUtil.changeAppLanguage(getContext(), "zh_rTW");
                }
            }
        }

        @Override
        public void changeUpColor(@NonNull Boolean isGreenUp) {
            Config.getMMKV(getActivity()).putBoolean(Config.IS_GREEN_UP, isGreenUp);
        }
    }
}
