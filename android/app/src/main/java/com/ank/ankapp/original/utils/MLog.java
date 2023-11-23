package com.ank.ankapp.original.utils;

import android.util.Log;

import com.ank.ankapp.original.Config;

public class MLog {


    public static void d(String msg)
    {
        if (Config.isLogDebug) System.out.println(msg);
    }

    public static void d(String tag, String msg)
    {
        if (Config.isLogDebug) System.out.println(tag + ":" + msg);
    }

    public static void e(String tag, String msg)
    {
        if (Config.isLogDebug) d(tag, msg);
    }

    public static void e(String msg)
    {
        if (Config.isLogDebug) d("uukr", msg);
    }

    public static void e1(String msg)
    {
        if (Config.isLogDebug) Log.e("uukr", msg);
    }

    public static void i(String tag, String msg)
    {
        if (Config.isLogDebug) d(tag, msg);
    }
}
