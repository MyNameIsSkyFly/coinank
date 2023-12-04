package com.ank.ankapp;

import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.PersistableBundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;

import com.ank.ankapp.original.App;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.activity.SetFloatViewActivity;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.service.FloatViewService;
import com.ank.ankapp.original.utils.AppUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.pigeon_plugin.Messages;

import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    private Handler handler;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Messages.MessageHostApi.setUp(flutterEngine.getDartExecutor(), new HostMessageHandler());
        App.getApplication().messageFlutterApi = new Messages.MessageFlutterApi(flutterEngine.getDartExecutor());
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState, @Nullable PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);

    }

    public static boolean isServiceRunning(Context mContext, String className) {

        boolean isRunning = false;
        ActivityManager activityManager = (ActivityManager) mContext
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningServiceInfo> serviceList = activityManager
                .getRunningServices(50);//old is 30

        if (!(serviceList.size() > 0)) {
            return false;
        }

        //MLog.d("OnlineService：",className);
        for (int i = 0; i < serviceList.size(); i++) {
            // MLog.d("serviceName：",serviceList.get(i).service.getClassName());
            if (serviceList.get(i).service.getClassName().contains(className)) {
                isRunning = true;
                break;
            }
        }
        return isRunning;
    }

    @Override
    protected void onResume() {
        super.onResume();
        boolean b = isServiceRunning(getApplicationContext(), FloatViewService.class.getName());
        MLog.d("service is running:" + b);
        if (!b) {
            if (handler == null) {
                handler = new Handler(msg -> {
                    MLog.d("checkAndStartFloating##$$###");
                    checkAndStartFloating();
                    return false;
                });
            }
            handler.sendEmptyMessageDelayed(1, 1500);
        }
    }

    public void checkAndStartFloating() {
        Config.getMMKV(this).getLong(Config.CONF_CURR_TIMESNAMP, 0);
        if (Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_SHOW, false)) {
            startService(new Intent(this, FloatViewService.class));
        }
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
