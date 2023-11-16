package com.ank.ankapp.ank_app.original.service;

import android.content.Context;
import android.content.Intent;
import android.content.MutableContextWrapper;
import android.os.IBinder;
import android.webkit.WebView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.JobIntentService;

import com.ank.ankapp.ank_app.original.utils.MLog;

/**
 * 提前初始化进程减少白屏
 */
public class MainWebService extends JobIntentService {

    public static final int JOB_ID = 2;
    private static final String TAG = MainWebService.class.getSimpleName();
    private WebView mWebView;
    @Override
    public void onCreate() {
        super.onCreate();
        MLog.d("init process");
    }

    public static void enqueueWork(Context context, Intent work) {
        enqueueWork(context, MainWebService.class, JOB_ID, work);
    }

    @Override
    protected void onHandleWork(@NonNull Intent intent) {
        // your code
        try {
            MLog.d("MainWebService onCreate");
            mWebView = new WebView(new MutableContextWrapper(this.getApplicationContext()));
        }catch (Throwable throwable){
            throwable.printStackTrace();
        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
