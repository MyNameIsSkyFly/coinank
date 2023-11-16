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
public class WebService extends JobIntentService {

    public static final int JOB_ID = 1;
    private static final String TAG = WebService.class.getSimpleName();
    private WebView mWebView;
    @Override
    public void onCreate() {
        super.onCreate();
        MLog.d("init process");
    }


    public static void enqueueWork(Context context, Intent work) {
        enqueueWork(context, WebService.class, JOB_ID, work);
    }

    @Override
    protected void onHandleWork(@NonNull Intent intent) {
        // your code
        try {
            MLog.d("WebService onCreate");
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
