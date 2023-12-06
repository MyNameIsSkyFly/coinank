package com.ank.ankapp.original;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

//import com.google.firebase.analytics.FirebaseAnalytics;

public class Global {

    public static Bundle createBundle(String itemid, String className)
    {
        Bundle bundle = new Bundle();
        //bundle.putString(FirebaseAnalytics.Param.ITEM_ID, itemid);
        //bundle.putString(FirebaseAnalytics.Param.CONTENT_TYPE, className);
        bundle.putString("action_data", itemid);
        bundle.putString("action_page", className);
        return bundle;
    }

//    public static FirebaseAnalytics getAnalytics(Context cot)
//    {
//        FirebaseAnalytics firebaseAnalytics= FirebaseAnalytics.getInstance(cot);
//        return firebaseAnalytics;
//    }

//    public static FirstActivity firstActivity;
    public static void notifyMsg(Context cot, int arg)
    {
        Intent intent = new Intent();
        intent.setAction(Config.ACTION_SERVICE_BROADCAST);
        intent.putExtra(Config.TYPE_ARG, arg);
        cot.sendBroadcast(intent);
    }

    public static void notifyBaseActivityMsg(Context cot, int arg)
    {
        Intent intent = new Intent();
        intent.setAction(Config.ACTION_BASEACTIVITY_BROADCAST);
        intent.putExtra(Config.TYPE_ARG, arg);
        cot.sendBroadcast(intent);
    }

    public static void broadcastMsg(Context cot, String action)
    {
        Intent intent = new Intent();
        intent.setAction(action);
        cot.sendBroadcast(intent);
    }


    public static void showActivity(Activity activity, Intent intent)
    {
        activity.startActivity(intent);
        //activity.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public static void showActivity(Context cot, Intent intent)
    {
        cot.startActivity(intent);
    }

}
