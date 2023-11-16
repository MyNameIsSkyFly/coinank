package com.github.mikephil.charting.utils;

import android.util.Log;

public class MLog {
    private static boolean isDebug = true;

    public static void d(String msg)
    {
        if (isDebug) System.out.println(msg);
    }

    public static void d(String tag, String msg)
    {
        if (isDebug) System.out.println(tag + ":" + msg);
    }

    public static void e(String tag, String msg)
    {
        if (isDebug) d(tag, msg);
    }

    public static void e(String msg)
    {
        if (isDebug) d("uukr", msg);
    }

    public static void e1(String msg)
    {
        if (isDebug) Log.e("uukr", msg);
    }

    public static void i(String tag, String msg)
    {
        if (isDebug) d(tag, msg);
    }
}
