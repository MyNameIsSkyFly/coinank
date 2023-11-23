package com.ank.ankapp.original;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.Gravity;

import androidx.appcompat.app.AppCompatDelegate;

import com.ank.ankapp.original.bean.JsonVo;
import com.ank.ankapp.original.bean.UrlConfigVo;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.language.PrefUtils;
import com.ank.ankapp.original.service.WebService;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.OkHttpUtil;
import com.ank.ankapp.original.utils.SQLiteKV;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.hjq.toast.ToastUtils;
import com.hjq.toast.style.WhiteToastStyle;
import com.just.agentweb.AgentWebCompat;
import com.nostra13.universalimageloader.cache.disc.impl.UnlimitedDiskCache;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.cache.memory.impl.LruMemoryCache;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;


public class App extends Application {

    @Override
    public void onCreate() {
        super.onCreate();

//        Global.getAnalytics(this).setAnalyticsCollectionEnabled(true);
//        Global.getAnalytics(this).logEvent("user_action",
//                Global.createBundle("app oncreate", getClass().getSimpleName()));

        PushSetting.PackageName = getPackageName();

        /**
         * 说明， WebView 初处初始化耗时 250ms 左右。
         * 提前初始化WebView ，好处可以提升页面初始化速度，减少白屏时间，
         * 坏处，拖慢了App 冷启动速度，如果 WebView 配合 VasSonic 使用，
         * 建议不要在此处提前初始化 WebView 。
         */
//        WebView mWebView=new WebView(new MutableContextWrapper(this));

        mCot = this;
        PushSetting.app = this;
        PushSetting.cot = this;

        SQLiteKV kv = new SQLiteKV(getApplicationContext());
        kv.putString("test", "coinsoto.com");
        String s = kv.getString("test");
        MLog.d("kv:" + s);


        String dir = getFilesDir().getAbsolutePath() + "/mmkv";
        MLog.d("libmmkv dir:" + dir);
        Global.getAnalytics(this).logEvent("user_action",
                Global.createBundle("MMKV.initialize " + dir, getClass().getSimpleName()));

//        String rootDir = MMKV.initialize(this, dir, new MMKV.LibLoader() {
//            @Override
//            public void loadLibrary(String libName) {
//                ReLinker.loadLibrary(App.this, libName);
//            }
//        });


        //MMKV.initialize(this);//初始化腾讯的开源库mmkv,用于跨进程保存键值对配置数据

        LanguageUtil.changeAppLanguage(this, PrefUtils.getLanguage(getApplicationContext()));
//        PushSetting.initCloudChannel(this);//初始化推送通道channel
        initDayNight();
        OkHttpUtil.initOkHttp();
        getUrlConfig(false);

        // Normal app init code...
        initImageLoader(this);//初始化异步图片加载库

        WebService.enqueueWork(this, new Intent());
        //腾讯 bugly，日志上报，google play需要去掉，以防被下架
        //CrashReport.initCrashReport(getApplicationContext(), AppUtils.getMetaDataString(this, "app_bugly"), Config.isLogDebug);

        // 初始化吐司工具类
        ToastUtils.init(this, new WhiteToastStyle());
        ToastUtils.setGravity(Gravity.BOTTOM);
    }

    public void getUrlConfig(boolean fromLocal)
    {
        //从本地加载配置
        if (fromLocal)
        {
            String json = Config.getMMKV(getApplicationContext()).getString(Config.CONF_URL_CONFIG, "");
            if (TextUtils.isEmpty(json)) return;

            JsonVo<UrlConfigVo> jsonVo;

            Gson gson = new GsonBuilder().create();
            jsonVo = gson.fromJson(json, new TypeToken<JsonVo<UrlConfigVo>>() {}.getType());

            if (jsonVo != null && jsonVo.isSuccess() && jsonVo.getData().getApiPrefix() != null)
            {
                Config.setUrlConfig(jsonVo.getData());
            }
        }
        else
        {
            //从服务器加载配置
            OkHttpUtil.getJSON(Config.urlAppConfig, new OkHttpUtil.OnDataListener() {
                @Override
                public void onResponse(String url, Object obj,String json) {
                    //MLog.d("url config json:" + json);
                    JsonVo<UrlConfigVo> jsonVo;

                    Gson gson = new GsonBuilder().create();
                    jsonVo = gson.fromJson(json, new TypeToken<JsonVo<UrlConfigVo>>() {}.getType());

                    if (jsonVo.isSuccess())
                    {
                        Config.getMMKV(getApplicationContext()).putString(Config.CONF_URL_CONFIG, json);
                        Config.setUrlConfig(jsonVo.getData());
                    }
                }

                @Override
                public void onFailure(String url, String error) {
                }
            });
        }
    }

    public static void initImageLoader(Context context) {
        ImageLoaderConfiguration.Builder builder = new ImageLoaderConfiguration.Builder(context);
        builder.threadPoolSize(5); // 线程池大小
        builder.threadPriority(Thread.NORM_PRIORITY - 2); // 设置线程优先级
        builder.denyCacheImageMultipleSizesInMemory(); // 不允许在内存中缓存同一张图片的多个尺寸
        builder.tasksProcessingOrder(QueueProcessingType.LIFO); // 设置处理队列的类型，包括LIFO， FIFO
        builder.memoryCache(new LruMemoryCache(8 * 1024 * 1024)); // 内存缓存策略
        builder.memoryCacheSize(8 * 1024 * 1024);  // 内存缓存大小
        builder.memoryCacheExtraOptions(480, 800); // 内存缓存中每个图片的最大宽高
        builder.memoryCacheSizePercentage(50); // 内存缓存占总内存的百分比
        builder.diskCache(new UnlimitedDiskCache(getApplication().getFilesDir())); // 设置磁盘缓存策略
        builder.diskCacheSize(100 * 1024 * 1024); // 设置磁盘缓存的大小
        builder.diskCacheFileCount(500); // 磁盘缓存文件数量
        builder.diskCacheFileNameGenerator(new Md5FileNameGenerator()); // 磁盘缓存时图片名称加密方式
        ImageLoader.getInstance().init(builder.build());
    }


    private static Context mCot;
    public static App getApplication()
    {
        return (App)mCot;
    }

    public void initDayNight() {
        //默认初始化白色主题模式
        if (Config.getMMKV(getApplicationContext()).getBoolean(Config.DAY_NIGHT_MODE, false)) {
            Config.getMMKV(getApplicationContext()).putBoolean(Config.DAY_NIGHT_MODE, true);
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);
        } else {
            Config.getMMKV(getApplicationContext()).putBoolean(Config.DAY_NIGHT_MODE, false);
            AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
        }
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        AgentWebCompat.setDataDirectorySuffix(base);
    }

}
