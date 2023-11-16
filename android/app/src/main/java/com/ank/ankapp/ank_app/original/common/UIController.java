package com.ank.ankapp.ank_app.original.common;

import android.app.Activity;
import android.os.Handler;
import android.webkit.WebView;

import com.ank.ankapp.ank_app.original.utils.MLog;
import com.just.agentweb.AgentWebUIControllerImplBase;

/**
 * Created by cenxiaozhong on 2017/12/23.
 */

/**
 * 如果你需要修改某一个AgentWeb 内部的某一个弹窗 ，请看下面的例子
 * 注意写法一定要参照 DefaultUIController 的写法 ，因为UI自由定制，但是回调的方式是固定的，并且一定要回调。
 */
public class UIController extends AgentWebUIControllerImplBase {

    private Activity mActivity;

    public UIController(Activity activity) {
        this.mActivity = activity;
    }

    @Override
    public void onShowMessage(String message, String from) {
        super.onShowMessage(message, from);
       MLog.d("message:" + message);
    }

    @Override
    public void onSelectItemsPrompt(WebView view, String url, String[] items, Handler.Callback callback) {
        super.onSelectItemsPrompt(view, url, items, callback); // 使用默认的UI
    }

    @Override
    public void onMainFrameError(WebView view, int errorCode, String description, String failingUrl) {
        super.onMainFrameError(view, errorCode, description, failingUrl);
        MLog.d("onMainFrameError:");
    }
}
