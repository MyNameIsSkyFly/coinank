package com.ank.ankapp.original.service;

import static androidx.core.app.NotificationCompat.PRIORITY_MAX;

import android.annotation.SuppressLint;
import android.app.ActivityOptions;
import android.app.KeyguardManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.PowerManager;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.content.ContextCompat;

import com.ank.ankapp.MainActivity;
import com.ank.ankapp.R;
import com.ank.ankapp.original.App;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.activity.SelectFloatViewSymbolActivity;
import com.ank.ankapp.original.bean.SymbolRealPriceVo;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.language.LanguageUtil;
import com.ank.ankapp.original.language.PrefUtils;
import com.ank.ankapp.original.utils.MLog;
import com.ank.ankapp.original.utils.WebSocketUtils;
import com.ank.ankapp.pigeon_plugin.Messages;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.ruffian.library.widget.RLinearLayout;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import okhttp3.WebSocket;

public class FloatViewService extends Service implements View.OnClickListener {
    private static WindowManager windowManager;
    private static WindowManager.LayoutParams layoutParams;
    private static View floatView;
    //key-val args pos
    private static final HashMap<String, Integer> subscribeMap = new HashMap<>();
    private static List<SymbolVo> symbolList;
    private static Handler mHandler;
    private static boolean isGreenUp = true;//绿涨红跌

    private static LinearLayout ll_add_market;

    private RLinearLayout ll_float_bg;
    protected LinearLayout ll_float_01, ll_float_02, ll_float_03, ll_float_04, ll_float_05, ll_float_06;
    private final LinearLayout[] llItemArr = {ll_float_01, ll_float_02, ll_float_03, ll_float_04, ll_float_05, ll_float_06};
    protected TextView tv_floatview_01, tv_floatview_02, tv_floatview_03, tv_floatview_04, tv_floatview_05, tv_floatview_06;
    private final TextView[] tvPriceArr = {tv_floatview_01, tv_floatview_02, tv_floatview_03, tv_floatview_04, tv_floatview_05, tv_floatview_06};
    protected TextView tv_sybol_01, tv_sybol_02, tv_sybol_03, tv_sybol_04, tv_sybol_05, tv_sybol_06;
    private final TextView[] tvSymbolArr = {tv_sybol_01, tv_sybol_02, tv_sybol_03, tv_sybol_04, tv_sybol_05, tv_sybol_06};

    private final int[] res_ll = {R.id.ll_float_01, R.id.ll_float_02, R.id.ll_float_03, R.id.ll_float_04, R.id.ll_float_05, R.id.ll_float_06};
    private final int[] res_price = {R.id.tv_floatview_01, R.id.tv_floatview_02, R.id.tv_floatview_03, R.id.tv_floatview_04, R.id.tv_floatview_05, R.id.tv_floatview_06};
    private final int[] res_symbol = {R.id.tv_sybol_01, R.id.tv_sybol_02, R.id.tv_sybol_03, R.id.tv_sybol_04, R.id.tv_sybol_05, R.id.tv_sybol_06};

    private final int[] priceFontRes = {R.dimen.font_size_small, R.dimen.font_size_mid, R.dimen.font_size_big};
    private final int[] symbolFontRes = {R.dimen.font_size_small_symbol, R.dimen.font_size_mid_symbol, R.dimen.font_size_big_symbol};

    private static int testVar = 0;

    @Override
    public void onCreate() {
        super.onCreate();


        LanguageUtil.changeAppLanguage(this, PrefUtils.getLanguage(this));
        Config.getMMKV(this).putBoolean(Config.CONF_STOP_STATUS, false);
        registerBroadcast();
        if (testVar == 0) {
            if (windowManager == null) {
                //MLog.d("service new windowManager");
                windowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
            }

            if (layoutParams == null) {
                //MLog.d("service new layoutParams");

                layoutParams = new WindowManager.LayoutParams();
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    layoutParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY;
                } else {
                    layoutParams.type = WindowManager.LayoutParams.TYPE_PHONE;
                }

                layoutParams.format = PixelFormat.RGBA_8888;
                layoutParams.gravity = Gravity.LEFT | Gravity.TOP;
                layoutParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
                layoutParams.width = ViewGroup.LayoutParams.WRAP_CONTENT;
                layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                layoutParams.x = Config.getMMKV(this).getInt(Config.FLOAT_VIEW_X, 0);
                layoutParams.y = Config.getMMKV(this).getInt(Config.FLOAT_VIEW_Y, 100);
            }

            if (mHandler == null) {
                // MLog.d("service new mHandler");
                mHandler = new Handler(new Handler.Callback() {
                    @Override
                    public boolean handleMessage(Message msg) {
                        if (mHandler == null) return false;

                        if (msg.what == 0) {

                            //getScreenStatus();
                            SymbolRealPriceVo<List<Object>> responseVo = (SymbolRealPriceVo<List<Object>>) msg.obj;
                            updateView(responseVo.getArgs(), responseVo.getData().get(3).toString());
                        } else if (msg.what == 1) {
                            doSubscribe();
                        } else if (msg.what == 4) {
                            setTextSize();
                        } else if (msg.what == 5) {
                            setBgAlpha();
                        } else if (msg.what == 2)//屏幕状态变化处理
                        {
                            int status = getScreenStatus();
                            if (status == 0)//亮屏
                            {
                                doSubscribe();
                            } else if (status == 1)//暗屏
                            {
                                WebSocketUtils.getInstance().removeAllSubscribe();
                                mHandler.sendEmptyMessageDelayed(2, 5000);
                            } else if (status == 2)//正在解锁
                            {

                            }

                            //mHandler.sendEmptyMessageDelayed(2, 5000);
                        }
                        return false;
                    }
                });
            }
        }

        //MLog.d("code:" + windowManager.hashCode() + " " + layoutParams.hashCode() + " " + mHandler.hashCode());

        MLog.i("coinsoho", "****floatview service create");

        isGreenUp = Config.getMMKV(this).getBoolean(Config.IS_GREEN_UP, true);
    }


    //0亮，1暗 2正在解锁
    private int getScreenStatus() {
        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        boolean isOn = pm.isInteractive();//如果为true，则表示屏幕“亮”了，否则屏幕“暗”了。
        //屏幕“亮”，表示有两种状态：a、未锁屏 b、目前正处于解锁状态 。这两种状态屏幕都是亮的
        //屏幕“暗”，表示目前屏幕是黑的 。

        KeyguardManager mKeyguardManager = (KeyguardManager) getSystemService(Context.KEYGUARD_SERVICE);
        boolean flag = mKeyguardManager.inKeyguardRestrictedInputMode();
        // MLog.d("isScreenOn:" + flag);
        //如果flag为true，表示有两种状态：a、屏幕是黑的 b、目前正处于解锁状态 。
        //如果flag为false，表示目前未锁屏
        if (isOn && flag) {
            MLog.d("screen unlocking");
            return 2;
        }

        if (isOn && !flag) {
            MLog.d("screen on");
            return 0;
        }

        if (!isOn && flag) {
            MLog.d("screen off");
            return 1;
        }

        return 1;
    }

    private void deinit() {
        testVar = 0;
        Config.getMMKV(this).putBoolean(Config.CONF_STOP_STATUS, false);
        WebSocketUtils.getInstance().closeWebSocket();
        Config.getMMKV(this).putInt(Config.FLOAT_VIEW_X, layoutParams.x);
        Config.getMMKV(this).putInt(Config.FLOAT_VIEW_Y, layoutParams.y);
        hideFlotView();
    }

    private void startForge() {
        showNotify();
    }

    /**
     * 启动前台服务
     */
    private void showNotify() {
        String channelId = null;
        // 8.0 以上需要特殊处理
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel();
            channelId = "4";
        } else {
            channelId = "";
        }

        Intent nfIntent = new Intent(getApplicationContext(), MainActivity.class);
        nfIntent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        nfIntent.setAction(Intent.ACTION_MAIN);
        nfIntent.addCategory(Intent.CATEGORY_LAUNCHER);
        PendingIntent pendingIntent;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            pendingIntent = PendingIntent.getActivity(this, 0, nfIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
        } else {
            pendingIntent = PendingIntent.getActivity(this, 0, nfIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
        }

        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, channelId);
        Notification notification = builder.setOngoing(true)
                .setContentIntent(pendingIntent)
                //.setLargeIcon(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher))
                .setSmallIcon(R.mipmap.ic_launcher_round)
                //.setContentTitle("Uukr")
                .setContentText(getResources().getString(R.string.s_floating_notify))// 设置上下文内容
                .setPriority(PRIORITY_MAX)
                .setCategory(Notification.CATEGORY_SERVICE)
                .build();

        notification.defaults = Notification.DEFAULT_SOUND; //设置为默认的声音
        //notification.flags |= Notification.FLAG_NO_CLEAR;
        NotificationManager service = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        startForeground(100, notification);
    }

    /**
     * 创建通知通道
     */
    @RequiresApi(Build.VERSION_CODES.O)
    private void createNotificationChannel() {
        NotificationChannel chan = new NotificationChannel("4",
                "Floating Window", NotificationManager.IMPORTANCE_NONE);
        chan.setLightColor(Color.BLUE);
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);
        NotificationManager service = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        service.createNotificationChannel(chan);
    }


    @SuppressLint("WrongConstant")
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        MLog.d("service ****** onStartCommand");

        if (testVar == 0) {
            doFloatView();
        }

        startForge();

        testVar++;
        MLog.d("testVar:" + testVar);
        flags = START_STICKY;
        return super.onStartCommand(intent, flags, startId);
    }

    private void doFloatView() {
        Config.getMMKV(this).putBoolean(Config.IS_FLOAT_VIEW_SHOW, true);
        showFloatView();
        WebSocketUtils.getInstance().createWebSocket();
        doSubscribe();
        WebSocketUtils.getInstance().setOnMsgListener(new WebSocketUtils.OnMessageListener() {

            private long lastTime = 0;

            @Override
            public void onMsg(WebSocket webSocket, String json) {

            }

            @Override
            public void onMsg(String json) {

                if (System.currentTimeMillis() - lastTime > 2000) {
                    lastTime = System.currentTimeMillis();
                    doEvent();
                }

                if (json.contains("pong")) {
                    //MLog.d("onMsg:" + json);
                    return;
                }

                if (json.contains("kline@") &&
                        json.contains("true") &&
                        json.contains("push")) {
                    SymbolRealPriceVo<List<String>> responseVo;

                    Gson gson = new GsonBuilder().create();
                    responseVo = gson.fromJson(json, new TypeToken<SymbolRealPriceVo<List<String>>>() {
                    }.getType());

                    Message msg = new Message();
                    msg.what = 0;
                    msg.obj = responseVo;
                    mHandler.sendMessage(msg);
                }
            }

            @Override
            public void doEvent() {
                //MLog.d("curr timesnamp:" + System.currentTimeMillis());
                //Config.getMMKV(getApplicationContext()).putLong(Config.CONF_CURR_TIMESNAMP,
                //       System.currentTimeMillis());
            }
        });
    }

    private void showFloatView() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) { // 没有权限
                return;
            }
        }

        LayoutInflater layoutInflater = LayoutInflater.from(this);
        floatView = layoutInflater.inflate(R.layout.float_view, null);
        floatView.setOnTouchListener(new FloatingOnTouchListener());
        windowManager.addView(floatView, layoutParams);
        //changeImageHandler.sendEmptyMessageDelayed(0, 2000);

        initView(floatView);
    }

    private void initView(View v) {
        ll_float_bg = v.findViewById(R.id.ll_float_bg);
        ll_add_market = v.findViewById(R.id.ll_add_market);
        ll_add_market.setOnClickListener(this);

        for (int i = 0; i < res_ll.length; i++) {
            tvPriceArr[i] = v.findViewById(res_price[i]);
            tvSymbolArr[i] = v.findViewById(res_symbol[i]);
            llItemArr[i] = v.findViewById(res_ll[i]);
            llItemArr[i].setOnClickListener(this);
            tvSymbolArr[i].setOnClickListener(this);
            tvPriceArr[i].setOnClickListener(this);
            llItemArr[i].setClickable(true);
            tvPriceArr[i].setClickable(true);
            tvSymbolArr[i].setClickable(true);
        }

        setTextSize();
        setBgAlpha();
    }

    private void setBgAlpha() {
        int iAlpha = Config.getMMKV(getApplicationContext()).getInt(Config.CONF_FLOATING_BG_ALPHA, 0xaf);
        int color = Color.argb(iAlpha, 0, 0, 0);
        ll_float_bg.getHelper().setBackgroundColorNormal(color);
    }

    private void setTextSize() {
        int idx = Config.getMMKV(getApplicationContext()).getInt(Config.CONF_FLOATING_TEXT_SIZE, 0);
        int len = tvPriceArr.length;
        for (int i = 0; i < len; i++) {
            int dimen = getResources().getDimensionPixelSize(priceFontRes[idx]);
            tvPriceArr[i].setTextSize(TypedValue.COMPLEX_UNIT_PX, dimen);
            dimen = getResources().getDimensionPixelSize(symbolFontRes[idx]);
            tvSymbolArr[i].setTextSize(TypedValue.COMPLEX_UNIT_PX, dimen);
        }
    }

    private int getColorById(int colorId) {
        return ContextCompat.getColor(getApplicationContext(), colorId);
    }

    private void updateView(String args, String price) {
        Integer intVal = subscribeMap.get(args);
        if (intVal != null) {
            int upColor, downColor;
            ll_add_market.setVisibility(View.GONE);
            llItemArr[intVal.intValue()].setVisibility(View.VISIBLE);
            tvPriceArr[intVal.intValue()].setText(price);

            if (isGreenUp) {
                upColor = getColorById(R.color.green4C);
                downColor = getColorById(R.color.redEB);
            } else {
                upColor = getColorById(R.color.redEB);
                downColor = getColorById(R.color.green4C);
            }

            SymbolVo symbol = symbolList.get(intVal.intValue());
            if (Double.valueOf(price) > Double.valueOf(symbol.getLastPrice())) {
                tvPriceArr[intVal.intValue()].setTextColor(upColor);
            } else {
                tvPriceArr[intVal.intValue()].setTextColor(downColor);
            }

            symbol.setLastPrice(price);

            String s = "[%s]%s %s %s";
            String str = LanguageUtil.getSwapString(getApplicationContext(), symbol.getDeliveryType());
            if (TextUtils.isEmpty(symbol.getQuoteAsset())) {
                if (symbol.getSymbol().contains("USDT") ||
                        symbol.getSymbol().contains("USDC") ||
                        symbol.getSymbol().contains("BUSD")) {
                    symbol.setQuoteAsset("USDT");
                } else if (symbol.getSymbol().contains("USD")) {
                    symbol.setQuoteAsset("USD");
                } else {
                    symbol.setQuoteAsset("");
                }
            }

            s = String.format(s, symbol.getBaseCoin(), symbol.getExchangeName(), symbol.getQuoteAsset(), str);
            tvSymbolArr[intVal.intValue()].setText(s);
        }
    }

    private void doClick(View v) {
        int len = res_ll.length;
        for (int i = 0; i < len; i++) {
            if (
                    v.getId() == res_ll[i] ||
                            v.getId() == res_price[i] ||
                            v.getId() == res_symbol[i]
            ) {
                SymbolVo symbolVo = symbolList.get(i);

                MLog.d("doclick item:" + i);
                Intent firstIntent = new Intent(this, MainActivity.class);
                firstIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                firstIntent.setAction(Intent.ACTION_MAIN);
                firstIntent.addCategory(Intent.CATEGORY_LAUNCHER);
//                firstIntent.putExtra(Config.CONF_HIDE_WELCOME_PAGE, true);//此种方式，隐藏启动页
                firstIntent.putExtra("klineExchangeName", symbolVo.getExchangeName());
                firstIntent.putExtra("klineSymbol", symbolVo.getSymbol());
                firstIntent.putExtra("klineBaseCoin", symbolVo.getBaseCoin());
                firstIntent.putExtra("klineProductType", symbolVo.getProductType());

//                Intent kIntent = new Intent(this, KLineActivity.class);
//                kIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                kIntent.putExtra(Config.TYPE_EXCHANGENAME, symbolList.get(i).getExchangeName());
//                kIntent.putExtra(Config.TYPE_SYMBOL, symbolList.get(i).getSymbol());
//                kIntent.putExtra(Config.TYPE_TITLE, symbolList.get(i).getSymbol());
//                kIntent.putExtra(Config.TYPE_SWAP, symbolList.get(i).getDeliveryType());
//                kIntent.putExtra(Config.TYPE_BASECOIN, symbolList.get(i).getBaseCoin());
                //String str = LanguageUtil.getSwapString(getApplicationContext(), symbol.getDeliveryType());

//                kIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                //getApplicationContext().startActivity(kIntent);//此种方式启动在某些系统版本上面会延时5秒，所以弃用

                //Global.notifyBaseActivityMsg(getApplicationContext(), 0);

//                Intent[] intents = new Intent[]{firstIntent, kIntent};
                Intent[] intents = new Intent[]{firstIntent};

                PendingIntent pi = null;

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    pi = PendingIntent.getActivities(getApplicationContext(), 0, intents,
                            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);//PendingIntent.FLAG_UPDATE_CURRENT|
                } else {
                    pi = PendingIntent.getActivities(getApplicationContext(), 0, intents,
                            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);
                }

                try {
                    pi.send();//后台服务可立即启动目标activity,部分手机还是会延时5秒
                    if (App.getApplication().messageFlutterApi == null) return;
                    App.getApplication().messageFlutterApi.toKLine(symbolVo.getExchangeName(), symbolVo.getSymbol(), symbolVo.getBaseCoin(), symbolVo.getProductType(), new Messages.VoidResult() {
                        @Override
                        public void success() {

                        }

                        @Override
                        public void error(@NonNull Throwable error) {

                        }
                    });
                } catch (PendingIntent.CanceledException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void doSubscribe() {
        String json = Config.getMMKV(getApplicationContext()).getString(Config.FLOAT_VIEW_TICKERS_JSON, "");
        Gson gson = new GsonBuilder().create();
        symbolList = gson.fromJson(json, new TypeToken<List<SymbolVo>>() {
        }.getType());
        if (symbolList == null)
            symbolList = new ArrayList<>();

        if (ll_add_market != null)
        {
            //ll_add_market = floatView.findViewById(R.id.ll_add_market);
            if (symbolList.size() <= 0) {
                ll_add_market.setVisibility(View.VISIBLE);
            } else {
                ll_add_market.setVisibility(View.GONE);
            }
        }

        //取消之前所有的订阅
        WebSocketUtils.getInstance().removeAllSubscribe();

        String[] strArr = new String[6];
        for (int i = 0; i < 6; i++) {
            strArr[i] = tvPriceArr[i].getText().toString();
        }

        HashMap<String, Integer> oldMap = new HashMap<>();
        for (String key : subscribeMap.keySet()) {
            oldMap.put(key, subscribeMap.get(key));
        }

        subscribeMap.clear();
        for (int i = 0; i < symbolList.size(); i++) {
            String key = symbolList.get(i).getSubscribeArgs();
            int idx = 0;
            if (oldMap.get(key) != null) {
                idx = oldMap.get(key).intValue();
                symbolList.get(i).setLastPrice(strArr[idx]);//取原位置上的值
            } else {
                symbolList.get(i).setLastPrice("0");
            }

            subscribeMap.put(key, i);
            updateView(symbolList.get(i).getSubscribeArgs(), symbolList.get(i).getLastPrice());
        }

        for (int i = 0; i < symbolList.size(); i++) {
            WebSocketUtils.getInstance().addSubscribe(symbolList.get(i).getSubscribeArgs());
        }

        for (int i = 5; i >= symbolList.size(); i--) {
            llItemArr[i].setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.ll_add_market) {
            Intent i = new Intent();
            i.setClass(getApplicationContext(), SelectFloatViewSymbolActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_add_market));
            getApplicationContext().startActivity(i);
        }

        doClick(v);
    }

    public void hideFlotView() {
        if (floatView != null) {
            windowManager.removeView(floatView);
            floatView = null;
        }
    }

    @Override
    public void onDestroy() {
        mHandler = null;
        stopForeground(true);
        super.onDestroy();
        unregisterBroadcast();
        MLog.d("*********service onDestroy*******");
        //如果是调用stopService，则销毁
        if (Config.getMMKV(this).getBoolean(Config.CONF_STOP_STATUS, false)) {
            MLog.d("*********service stop deinit*******");
            deinit();
        }
    }

    private class FloatingOnTouchListener implements View.OnTouchListener {
        boolean bLocked = false;
        int lastX = 0, lastY = 0;
        float sw = 0, sh = 0;
        float vw = 0, vh = 0;

        @Override
        public boolean onTouch(View view, MotionEvent event) {

            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    //MLog.d("onTouch down******");
                    break;
                case MotionEvent.ACTION_MOVE:
                    if (lastX == 0 && lastY == 0) {
                        vw = floatView.getWidth();
                        vh = floatView.getHeight();
                        sw = windowManager.getDefaultDisplay().getWidth();
                        sh = windowManager.getDefaultDisplay().getHeight();

                        lastX = (int) event.getRawX();
                        lastY = (int) event.getRawY();
                        bLocked = Config.getMMKV(getApplicationContext()).getBoolean(Config.IS_FLOAT_VIEW_LOCK, false);
                    }

                    int nowX = (int) event.getRawX();
                    int nowY = (int) event.getRawY();
                    int movedX = nowX - lastX;
                    int movedY = nowY - lastY;
                    lastX = nowX;
                    lastY = nowY;
                    if (!bLocked) {
                        layoutParams.x = layoutParams.x + movedX;
                        layoutParams.y = layoutParams.y + movedY;
                        if (layoutParams.x < 0) layoutParams.x = 0;
                        if (layoutParams.x > sw - vw) layoutParams.x = (int) (sw - vw);
                        if (layoutParams.y < 0) layoutParams.y = 0;
                        if (layoutParams.y > sh - vh) layoutParams.y = (int) (sh - vh);
                        windowManager.updateViewLayout(view, layoutParams);
                    }
                    break;
                case MotionEvent.ACTION_UP:
                    lastX = 0;
                    lastY = 0;

                    Config.getMMKV(getApplicationContext()).putInt(Config.FLOAT_VIEW_X, layoutParams.x);
                    Config.getMMKV(getApplicationContext()).putInt(Config.FLOAT_VIEW_Y, layoutParams.y);
                    break;
                default:
                    break;
            }

            return true;//true表明消费了该事件
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void registerBroadcast() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Config.ACTION_SERVICE_BROADCAST);
        filter.addAction(Intent.ACTION_SCREEN_ON);
        filter.addAction(Intent.ACTION_SCREEN_OFF);
        filter.addAction(Intent.ACTION_USER_PRESENT);
        registerReceiver(myBroadcast, filter);
    }

    private void unregisterBroadcast() {
        unregisterReceiver(myBroadcast);
    }

    private final MyBroadcast myBroadcast = new MyBroadcast();

    private class MyBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Config.ACTION_SERVICE_BROADCAST)) {
                int arg = intent.getIntExtra(Config.TYPE_ARG, 0);
                MLog.d("onReceive:" + arg);
                if (arg == 1)//update subscribe
                {
                    Message msg = new Message();
                    msg.what = 1;
                    mHandler.sendMessage(msg);
                } else if (arg == 2) {
                    isGreenUp = Config.getMMKV(getApplicationContext()).getBoolean(Config.IS_GREEN_UP, true);
                } else if (arg == 3) {
                    //无效果
                    //LanguageUtil.changeAppLanguage(getApplicationContext(), PrefUtils.getLanguage(getApplicationContext()));
                } else if (arg == 4)//设置悬浮窗字体大小
                {
                    Message msg = new Message();
                    msg.what = 4;
                    mHandler.sendMessage(msg);
                } else if (arg == 5)//设置悬浮窗背景透明度
                {
                    Message msg = new Message();
                    msg.what = 5;
                    mHandler.sendMessage(msg);
                }
            } else {
                String action = intent.getAction();
                if (Intent.ACTION_SCREEN_ON.equals(action)) {
                    // 亮屏
                    MLog.d("onReceive screen on");
                } else if (Intent.ACTION_SCREEN_OFF.equals(action)) {
                    // 锁屏
                    MLog.d("onReceive screen off");
                } else if (Intent.ACTION_USER_PRESENT.equals(action)) {
                    // 解锁
                    MLog.d("onReceive screen unlocking");
                }

                Message msg = new Message();
                msg.what = 2;
                mHandler.sendMessage(msg);
            }
        }
    }
}
