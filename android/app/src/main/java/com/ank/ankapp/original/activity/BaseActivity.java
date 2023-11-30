package com.ank.ankapp.original.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.ColorRes;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.ContextCompat;


import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.ank.ankapp.R;
import com.ank.ankapp.original.App;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.language.PrefUtils;
import com.ank.ankapp.original.service.FloatViewService;
import com.ank.ankapp.original.utils.AppUtils;
import com.ank.ankapp.original.utils.MLog;
import com.huawei.hms.aaid.HmsInstanceId;
import com.huawei.hms.common.ApiException;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public abstract class BaseActivity extends AppCompatActivity {

    protected ImageView mBackImageView, iv_favorite, iv_switch_symbol, iv_mul_kline;
    protected TextView mTitleTextView, tv_swap_type;
    protected String strTitle = "";
    protected RelativeLayout rl_title;

    private Handler handler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        MLog.d("language:" + PrefUtils.getLanguage(this));
        LanguageUtil.changeAppLanguage(this, PrefUtils.getLanguage(this));
        setCookieValue();//设置webview theme
        super.onCreate(savedInstanceState);
        setStatusColor(this, false, !Config.getMMKV(this).getBoolean(Config.DAY_NIGHT_MODE, false), R.color.colorPrimary);

        strTitle = getIntent().getStringExtra(Config.TYPE_TITLE);

        handler = new Handler(new Handler.Callback() {
            @Override
            public boolean handleMessage(@NonNull Message msg) {
                MLog.d("checkAndStartFloating##$$###");
                checkAndStartFloating();
                return false;
            }
        });

        // MLog.d("\nlen:" + AppUtils.getPrecision("1.0E-6"));
    }

    public void checkAndStartFloating() {
        Config.getMMKV(this).getLong(Config.CONF_CURR_TIMESNAMP, 0);
        if (Config.getMMKV(this).getBoolean(Config.IS_FLOAT_VIEW_SHOW, false)) {
            startService(new Intent(this, FloatViewService.class));
        }
    }

    /*
     * 判断服务是否启动,context上下文对象 ，className服务的name
     */
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
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
//        Config.DeviceID = PushServiceFactory.getCloudPushService().getDeviceId();
    }

    private boolean bPause = false;

    public boolean isPause() {
        return bPause;
    }

    @Override
    protected void onPause() {
        super.onPause();
        bPause = true;
        Config.isNightMode = Config.getMMKV(this).getBoolean(Config.DAY_NIGHT_MODE, false);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        bPause = true;
        //fixInputMethodManagerLeak(this);
    }

    @Override
    protected void onResume() {
        LanguageUtil.changeAppLanguage(this, PrefUtils.getLanguage(this));
        super.onResume();

        new Thread(new Runnable() {
            @Override
            public void run() {
                String token = null;
                try {
                    token = HmsInstanceId.getInstance(getApplicationContext()).getToken("106593271", "HCM");
                    MLog.d("\nhuawei push token:" + token);
                } catch (ApiException e) {
                    e.printStackTrace();
                }

                /*

                 */
            }
        }).start();

        bPause = false;
        Config.DeviceID = PushServiceFactory.getCloudPushService().getDeviceId();
        MLog.d("push id:" + Config.DeviceID);

        Config.isNightMode = Config.getMMKV(this).getBoolean(Config.DAY_NIGHT_MODE, false);

        if (Config.getMMKV(this).getBoolean(Config.IS_GREEN_UP, true)) {
            Config.greenColor = ContextCompat.getColor(this, R.color.green4C);
            Config.redColor = ContextCompat.getColor(this, R.color.redEB);
        } else {
            Config.greenColor = ContextCompat.getColor(this, R.color.redEB);
            Config.redColor = ContextCompat.getColor(this, R.color.green4C);
        }

        boolean b = isServiceRunning(getApplicationContext(), FloatViewService.class.getName());
        MLog.d("service is running:" + b);
        if (!b) {
            handler.sendEmptyMessageDelayed(1, 1500);
        }
    }

    public static void setStatusColor(Activity activity, boolean isTranslate, boolean isDarkText, @ColorRes int bgColor) {
        //如果系统为6.0及以上，就可以使用Android自带的方式
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Window window = activity.getWindow();
            View decorView = window.getDecorView();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS); //可有可无
            decorView.setSystemUiVisibility((isTranslate ? View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN : 0) | (isDarkText ? View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR : 0));
            window.setStatusBarColor(isTranslate ? Color.TRANSPARENT : ContextCompat.getColor(activity, bgColor)); //Android5.0就可以用
        }
    }

    protected void initToolBar() {
        iv_mul_kline = this.findViewById(R.id.iv_mul_kline);
        iv_favorite = this.findViewById(R.id.iv_favorite);
        iv_switch_symbol = this.findViewById(R.id.iv_switch_symbol);
        mBackImageView = this.findViewById(R.id.iv_back);
        if (Config.getMMKV(this).getBoolean(Config.DAY_NIGHT_MODE, false)) {
            mBackImageView.setImageResource(R.drawable.btn_back_night);
            iv_switch_symbol.setImageResource(R.drawable.switch_symbol_night);
            iv_mul_kline.setImageResource(R.drawable.mul_kline_icon_night);
        }

        rl_title = this.findViewById(R.id.rl_title);
        tv_swap_type = this.findViewById(R.id.tv_swap_type);
        mTitleTextView = this.findViewById(R.id.toolbar_title);
        if (TextUtils.isEmpty(strTitle))
            strTitle = getResources().getString(R.string.app_name);
        mTitleTextView.setText(strTitle);
        mBackImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    /**
     * 同步cookie
     *
     * @param domain     地址
     * @param cookieList 需要添加的Cookie值,以键值对的方式:key=value
     */
    private void syncCookie(String domain, ArrayList<String> cookieList) {
        if (domain == null) return;
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        if (cookieList != null && cookieList.size() > 0) {
            for (String cookie : cookieList) {
                //MLog.d(domain + ":" + cookie);
                cookieManager.setCookie(domain, cookie);
            }
        }

        cookieManager.setCookie(domain, "Domain=" + domain);
        cookieManager.setCookie(domain, "Path=/");
        String cookies = cookieManager.getCookie(domain);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.flush();
        } else {
            CookieSyncManager.createInstance(this);
            CookieSyncManager.getInstance().sync();
        }
    }

    public void setCookieValue() {
        ArrayList<String> cookieList = new ArrayList<>();
        if (Config.getMMKV(this).getBoolean(Config.DAY_NIGHT_MODE, false)) {
            //cookieList.add("theme=dark");//网站用的是dark
            cookieList.add("theme=night");//app night
        } else {
            cookieList.add("theme=light");
        }

        if (AppUtils.getLoginInfo(this) != null) {
            cookieList.add("COINSOHO_KEY=" + AppUtils.getToken(this));
        } else {
            cookieList.add("COINSOHO_KEY=" + "");
        }

        if (Config.getMMKV(this).getBoolean(Config.IS_GREEN_UP, true)) {
            cookieList.add("green-up=true");
        } else {
            cookieList.add("green-up=false");
        }


        syncCookie(Config.strDomain, cookieList);
        String s = LanguageUtil.getShortLanguageName(this);
        cookieList.add("i18n_redirected=" + s);

        syncCookie(Config.depthOrderDomain, cookieList);//实时挂单数据url cookie

        //uni-app写入cookie
        syncCookie(Config.uniappDomain, cookieList);
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        setCookieValue();//设置webview theme
        App.getApplication().initDayNight();
    }

    @SuppressLint("BlockedPrivateApi")
    public static void fixInputMethodManagerLeak(Context destContext) {
        if (destContext == null) {
            return;
        }

        InputMethodManager imm = (InputMethodManager) destContext.getSystemService(Context.INPUT_METHOD_SERVICE);
        if (imm == null) {
            return;
        }

        String[] arr = new String[]{"mCurRootView", "mServedView", "mNextServedView"};
        Field f = null;
        Object obj_get = null;
        for (int i = 0; i < arr.length; i++) {
            String param = arr[i];
            try {
                f = imm.getClass().getDeclaredField(param);
                if (!f.isAccessible()) {
                    f.setAccessible(true);
                } // author: sodino mail:[email protected]
                obj_get = f.get(imm);
                if (obj_get != null && obj_get instanceof View) {
                    View v_get = (View) obj_get;
                    if (v_get.getContext() == destContext) { // 被InputMethodManager持有引用的context是想要目标销毁的
                        f.set(imm, null); // 置空，破坏掉path to gc节点
                    } else {
                        // 不是想要目标销毁的，即为又进了另一层界面了，不要处理，避免影响原逻辑,也就不用继续for循环了
                        //if (QLog.isColorLevel()) {
                        //QLog.d(ReflecterHelper.class.getSimpleName(), QLog.CLR, "fixInputMethodManagerLeak break, context is not suitable, get_context=" + v_get.getContext()+" dest_context=" + destContext);
                        //}
                        break;
                    }
                }
            } catch (Throwable t) {
                t.printStackTrace();
            }
        }
    }


}