package com.ank.ankapp.original.common;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Looper;
import android.webkit.JavascriptInterface;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.activity.CommonFragmentActivity;
import com.ank.ankapp.original.activity.CommonWebActivity;
import com.ank.ankapp.original.bean.SymbolVo;
import com.ank.ankapp.original.utils.MLog;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.just.agentweb.AgentWeb;

/**
 * Created by cenxiaozhong on 2017/5/14.
 *  source code  https://github.com/Justson/AgentWeb
 */

public class AndroidInterface {

    private Handler deliver = new Handler(Looper.getMainLooper());
    private AgentWeb agent;
    private Context context;

    public AndroidInterface(AgentWeb agent, Context context) {
        this.agent = agent;
        this.context = context;
    }


    @JavascriptInterface
    public String getUserInfo() {

        String s = Config.getMMKV(context).getString(Config.CONF_LOGIN_USER_INFO, "");
        //MLog.d("login info:" + s);
        return s;
    }

    @JavascriptInterface
    public void openKLineChart(String json) {
        MLog.d("openKLineChart:" + json);
        //Toast.makeText(context, "openKLineChart", Toast.LENGTH_SHORT).show();
        Gson gson = new GsonBuilder().create();
        SymbolVo symbol = gson.fromJson(json, new TypeToken<SymbolVo>() {}.getType());
        if (symbol != null && symbol.getSymbol() != null
                && symbol.getExchangeName() != null
                && symbol.getBaseCoin() != null
        )
        {
//            Intent i = new Intent();
//            i.setClass(context, KLineActivity.class);
//            i.putExtra(Config.TYPE_EXCHANGENAME, symbol.getExchangeName());
//            i.putExtra(Config.TYPE_SYMBOL, symbol.getSymbol());
//            i.putExtra(Config.TYPE_SWAP, symbol.getDeliveryType());
//            i.putExtra(Config.TYPE_BASECOIN, symbol.getBaseCoin());
//            Global.showActivity(context, i);
        }
    }

    @JavascriptInterface
    public void openUrl(String url) {
        MLog.d("openUrl url on new window:" + url);
        Intent i = new Intent();
        i.setClass(context, CommonWebActivity.class);
        i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        i.putExtra(Config.TYPE_URL, Config.h5Prefix + url);
        i.putExtra(Config.TYPE_TITLE, context.getResources().getString(R.string.s_chart));
        Global.showActivity(context, i);
    }

    @JavascriptInterface
    public void openLogin() {
        MLog.d("\n#####js openLogin#####\n");
        Intent i = new Intent();
        i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        i.setClass(context, CommonFragmentActivity.class);
        i.putExtra(Config.INDEX_TYPE, Config.TYPE_LOGIN);
        i.putExtra(Config.TYPE_TITLE, context.getResources().getString(R.string.s_login));
        Global.showActivity(context, i);
    }

    @JavascriptInterface
    public void callAndroid(final String msg) {

    }

}
