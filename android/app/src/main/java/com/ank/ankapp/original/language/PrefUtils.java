package com.ank.ankapp.original.language;

import android.content.Context;
import android.text.TextUtils;

import com.ank.ankapp.original.Config;

import java.util.Locale;

/**
 * 存储、获取语言的工具类
 */
public class PrefUtils {

    private static final String PREF = "uukr_setting";
    private static final String KEY_LANGUAGE = "app_language";

    /**
     *
     * 获得存入sp的语言
     * */
    public static String getLanguage(Context context) {
        if (TextUtils.isEmpty(getSpf(context, KEY_LANGUAGE))) {
            return Locale.getDefault().getLanguage();
        }
        return getSpf(context, KEY_LANGUAGE);
    }

    /**
     * 语言存入sp
     * */
    public static void setLanguage(Context context, String value) {
        if (value == null) {
            value = "en";//context.getResources().getString(R.string.tv_english);
        }
        setSpf(context, KEY_LANGUAGE, value);
    }

    private static String getSpf(Context context, String key) {
        return Config.getMMKV(context).getString(key, "en");
    }

    private static void setSpf(Context context, String key, String value) {
        Config.getMMKV(context).putString(key, value);
    }

}