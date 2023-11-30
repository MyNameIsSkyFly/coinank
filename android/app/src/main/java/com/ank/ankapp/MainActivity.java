package com.ank.ankapp;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatDelegate;

import com.ank.ankapp.original.App;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.activity.CommonWebActivity;
import com.ank.ankapp.original.activity.SetFloatViewActivity;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.utils.AppUtils;
import com.ank.ankapp.original.utils.UrlGet;
import com.ank.ankapp.pigeon_plugin.Messages;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Messages.MessageHostApi.setUp(flutterEngine.getDartExecutor(), new HostMessageHandler());
        App.getApplication().messageFlutterApi = new Messages.MessageFlutterApi(flutterEngine.getDartExecutor());
        System.out.println("App.getApplication().messageFlutterApi = " + App.getApplication().messageFlutterApi);
    }

    class HostMessageHandler implements Messages.MessageHostApi {


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

        @Override
        public void toChartWeb(@NonNull String url, @NonNull String title) {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, Config.h5Prefix + url);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_chart));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void saveLoginInfo(@NonNull String userInfoWithBaseEntityJson) {
            Config.getMMKV(getContext()).putString(Config.CONF_LOGIN_USER_INFO, userInfoWithBaseEntityJson);
            AppUtils.setCookieValue(getContext());
        }

        @Override
        public void toAndroidFloatingWindow() {
            Intent i = new Intent();
            i.setClass(getActivity(), SetFloatViewActivity.class);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_floatviewsetting));
            Global.showActivity(getActivity(), i);
        }
    }
}
