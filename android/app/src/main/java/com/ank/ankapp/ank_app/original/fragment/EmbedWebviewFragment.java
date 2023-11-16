package com.ank.ankapp.ank_app.original.fragment;


import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Picture;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.AnimationUtils;
import android.webkit.CookieManager;
import android.webkit.SslErrorHandler;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.Fragment;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;
import com.ank.ankapp.ank_app.original.activity.BaseActivity;
import com.ank.ankapp.ank_app.original.client.MiddlewareChromeClient;
import com.ank.ankapp.ank_app.original.client.MiddlewareWebViewClient;
import com.ank.ankapp.ank_app.original.common.AndroidInterface;
import com.ank.ankapp.ank_app.original.common.CommonWebChromeClient;
import com.ank.ankapp.ank_app.original.common.FragmentKeyDown;
import com.ank.ankapp.ank_app.original.common.UIController;
import com.ank.ankapp.ank_app.original.utils.MLog;
import com.just.agentweb.AbsAgentWebSettings;
import com.just.agentweb.AgentWeb;
import com.just.agentweb.AgentWebConfig;
import com.just.agentweb.DefaultWebClient;
import com.just.agentweb.IAgentWebSettings;
import com.just.agentweb.MiddlewareWebChromeBase;
import com.just.agentweb.MiddlewareWebClientBase;
import com.just.agentweb.PermissionInterceptor;
import com.just.agentweb.WebChromeClient;

import java.util.HashMap;
import java.util.Locale;


//首页下边的4个标签，行情标签里面嵌套的webview fragment
public class EmbedWebviewFragment extends Fragment implements FragmentKeyDown {

    protected ImageView mBackImageView;
    protected TextView mTitleTextView;
    protected AgentWeb mAgentWeb;
    public static final String URL_KEY = "url_key";
    protected RelativeLayout  mRlLoadingView;
    /**
     * 用于方便打印测试
     */
    public static final String TAG = EmbedWebviewFragment.class.getSimpleName();
    protected MiddlewareWebClientBase mMiddleWareWebClient;
    protected MiddlewareWebChromeBase mMiddleWareWebChrome;
    private View rootView;
    protected boolean isOpenSelf = true;

    public boolean isOpenSelf() {
        return isOpenSelf;
    }

    public void setOpenSelf(boolean openSelf) {
        isOpenSelf = openSelf;
    }


    public static EmbedWebviewFragment getInstance(Bundle bundle) {

        EmbedWebviewFragment mAgentWebFragment = new EmbedWebviewFragment();
        if (bundle != null) {
            mAgentWebFragment.setArguments(bundle);
        }

        return mAgentWebFragment;

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        symbolInfo = "";
        rootView = inflater.inflate(R.layout.fragment_home_tab_webview, container, false);
        rootView.findViewById(R.id.iv_webloading).
                 startAnimation(AnimationUtils.loadAnimation(getContext(), R.anim.rotate));
         return rootView;
    }


    @Override
    public void onViewCreated(View view,Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Global.getAnalytics(getContext()).logEvent("user_action",
                Global.createBundle("oncreate", getClass().getSimpleName()));
        BaseActivity baseActivity = (BaseActivity)getActivity();
        baseActivity.setCookieValue();
        mAgentWeb = AgentWeb.with(this)//
                .setAgentWebParent((LinearLayout) view.findViewById(R.id.ll_rootview), -1, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))//传入AgentWeb的父控件。
                //.useDefaultIndicator(-1, 3)//设置进度条颜色与高度，-1为默认值，高度为2，单位为dp。
                .useDefaultIndicator(Color.TRANSPARENT, 2)//把进度条设置为透明达到隐藏效果
                .setAgentWebWebSettings(getSettings())//设置 IAgentWebSettings。
                .setWebViewClient(mWebViewClient)//WebViewClient ， 与 WebView 使用一致 ，但是请勿获取WebView调用setWebViewClient(xx)方法了,会覆盖AgentWeb DefaultWebClient,同时相应的中间件也会失效。
                .setWebChromeClient(new CommonWebChromeClient()) //WebChromeClient
                .setPermissionInterceptor(mPermissionInterceptor) //权限拦截 2.0.0 加入。
                .setSecurityType(AgentWeb.SecurityType.STRICT_CHECK) //严格模式 Android 4.2.2 以下会放弃注入对象 ，使用AgentWebView没影响。
                .setAgentWebUIController(new UIController(getActivity())) //自定义UI  AgentWeb3.0.0 加入。
                .setMainFrameErrorView(R.layout.agentweb_error_page, -1) //参数1是错误显示的布局，参数2点击刷新控件ID -1表示点击整个布局都刷新， AgentWeb 3.0.0 加入。
                .useMiddlewareWebChrome(getMiddlewareWebChrome()) //设置WebChromeClient中间件，支持多个WebChromeClient，AgentWeb 3.0.0 加入。
                .useMiddlewareWebClient(getMiddlewareWebClient())
                .additionalHttpHeader(getUrl(), "coinsohoweb", "coinsohoweb")
                .setOpenOtherPageWays(DefaultWebClient.OpenOtherPageWays.ASK)//打开其他页面时，弹窗质询用户前往其他应用 AgentWeb 3.0.0 加入。
                .interceptUnkownUrl() //拦截找不到相关页面的Url AgentWeb 3.0.0 加入。
                .createAgentWeb()//创建AgentWeb。
                .ready().get();//设置 WebSettings。

        if(mAgentWeb!=null){
            //注入对象
            mAgentWeb.getJsInterfaceHolder().addJavaObject("coinsoto",new AndroidInterface(mAgentWeb, getActivity()));
        }


        // mAgentWeb.getJsAccessEntrace().quickCallJs("callByAndroidParam","Hello ! Agentweb");


        mAgentWeb.getAgentWebSettings().getWebSettings().setDefaultFontSize(14);
        mAgentWeb.getAgentWebSettings().getWebSettings().setMinimumFontSize(8);

        mAgentWeb.getAgentWebSettings().getWebSettings().setAllowFileAccess(true);
        mAgentWeb.getAgentWebSettings().getWebSettings().setAllowFileAccessFromFileURLs(true);

        mAgentWeb.getWebCreator().getWebView().setPictureListener(new WebView.PictureListener() {
            @Override
            public void onNewPicture(WebView webView, @Nullable Picture picture) {
                //MLog.d("info", "test setPictureListener");
                hideLoadingView(rootView);
            }
        });

        mAgentWeb.getWebCreator().getWebView().setBackgroundColor(0x00000000);
        mAgentWeb.getWebCreator().getWebView().setBackgroundResource(R.color.colorPrimary);
       // mLoadingView = LayoutInflater.from(getContext()).inflate(R.layout.layout_rootview, (ViewGroup) view, false);
         //mAgentWeb.getWebCreator().getWebParentLayout().addView(mLoadingView, -1);
        mRlLoadingView = (RelativeLayout)view.findViewById(R.id.rl_root);


        //mAgentWeb.getWebCreator().getWebView().loadUrl("sssss");
        mAgentWeb.getWebCreator().getWebView().loadUrl(getUrl());

        AgentWebConfig.debug();
        initView(view);
        // AgentWeb 没有把WebView的功能全面覆盖 ，所以某些设置 AgentWeb 没有提供 ， 请从WebView方面入手设置。
        mAgentWeb.getWebCreator().getWebView().setOverScrollMode(WebView.OVER_SCROLL_NEVER);

        //MLog.d("cookie:" + getCookie(getUrl()));

        Global.getAnalytics(getActivity()).logEvent("user_action",
                Global.createBundle(getUrl(), getClass().getSimpleName()));
    }

    private static String symbolInfo = "";
    public void setSymbolInfo(String param)
    {
        symbolInfo = param;
    }

    public void changeSymbolInfo(String param)
    {
        //MLog.d("changeSymbolInfo:" + param);
        //mAgentWeb.getWebCreator().getWebView().loadUrl(url);
        if (mAgentWeb.getJsAccessEntrace() != null)
        {
            mAgentWeb.getJsAccessEntrace().quickCallJs("changeSymbolInfo",param);
            setSymbolInfo(param);
        }
    }

    public void pauseMarketTickers()
    {
        mAgentWeb.getJsAccessEntrace().quickCallJs("pause");
    }

    public void resumeMarketTickers()
    {
        mAgentWeb.getJsAccessEntrace().quickCallJs("resurme");
    }

    private String getCookie(String url)
    {
        CookieManager cookieManager = CookieManager.getInstance();
        return cookieManager.getCookie(url);
    }

    protected void hideLoadingView(View v)
    {
        ImageView iv = rootView.findViewById(R.id.iv_webloading);
        if(iv != null)
        {
            iv.clearAnimation();
            iv.setVisibility(View.GONE);
        }
    }


    protected PermissionInterceptor mPermissionInterceptor = new PermissionInterceptor() {

        /**
         * PermissionInterceptor 能达到 url1 允许授权， url2 拒绝授权的效果。
         * @param url
         * @param permissions
         * @param action
         * @return true 该Url对应页面请求权限进行拦截 ，false 表示不拦截。
         */
        @Override
        public boolean intercept(String url, String[] permissions, String action) {
           // Log.i(TAG, "mUrl:" + url + "  permission:" + mGson.toJson(permissions) + " action:" + action);
            return false;
        }
    };


    /**
     * @return IAgentWebSettings
     */
    public IAgentWebSettings getSettings() {
        return new AbsAgentWebSettings() {
            private AgentWeb mAgentWeb;
            @Override
            protected void bindAgentWebSupport(AgentWeb agentWeb) {
                this.mAgentWeb = agentWeb;
            }
        };
    }

    /**
     * 页面空白，请检查scheme是否加上， scheme://host:port/path?query&query 。
     *
     * @return mUrl
     */
    public String getUrl() {
        String target = "";

        if (TextUtils.isEmpty(target = this.getArguments().getString(URL_KEY))) {
            target = Config.h5Prefix;
        }

//		return "http://ggzy.sqzwfw.gov.cn/WebBuilderDS/WebbuilderMIS/attach/downloadZtbAttach.jspx?attachGuid=af982055-3d76-4b00-b5ab-36dee1f90b11&appUrlFlag=sqztb&siteGuid=7eb5f7f1-9041-43ad-8e13-8fcb82ea831a";
        return target;
    }

    protected WebChromeClient mWebChromeClient = new WebChromeClient() {
        @Override
        public void onProgressChanged(WebView view, int newProgress) {
            super.onProgressChanged(view, newProgress);
            Log.i(TAG, "onProgressChanged:" + newProgress + "  view:" + view);
        }

        @Override
        public void onReceivedTitle(WebView view, String title) {
            super.onReceivedTitle(view, title);
            if (mTitleTextView != null && !TextUtils.isEmpty(title)) {
                if (title.length() > 10) {
                    title = title.substring(0, 10).concat("...");
                }
            }
            mTitleTextView.setText(title);
        }
    };
    /**
     * 注意，重写WebViewClient的方法,super.xxx()请务必正确调用， 如果没有调用super.xxx(),则无法执行DefaultWebClient的方法
     * 可能会影响到AgentWeb自带提供的功能,尽可能调用super.xxx()来完成洋葱模型
     */
    protected com.just.agentweb.WebViewClient mWebViewClient = new com.just.agentweb.WebViewClient()
    {
        private HashMap<String, Long> timer = new HashMap<>();

        @Override
        public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
            super.onReceivedError(view, request, error);
            MLog.d("onReceivedError");
            hideLoadingView(view);
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            return super.shouldOverrideUrlLoading(view, request);
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
            return super.shouldInterceptRequest(view, request);
        }

        @Override
        public boolean shouldOverrideUrlLoading(final WebView view, String url) {
            return super.shouldOverrideUrlLoading(view, url);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
            MLog.d(TAG, "mUrl:" + url + " onPageStarted  target:" + getUrl());
            timer.put(url, System.currentTimeMillis());
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            if (timer.get(url) != null) {
                long overTime = System.currentTimeMillis();
                Long startTime = timer.get(url);
                MLog.d(TAG, "  page mUrl:" + url + "  used time:" + (overTime - startTime));
            }

            if (!TextUtils.isEmpty(symbolInfo))
            {
                EmbedWebviewFragment.this.changeSymbolInfo(symbolInfo);
            }
            MLog.d("webview onPageFinished");
        }

        /*错误页回调该方法 ， 如果重写了该方法， 上面传入了布局将不会显示 ， 交由开发者实现，注意参数对齐。*/
	   /* public void onMainFrameError(AbsAgentWebUIController agentWebUIController, WebView view, int errorCode, String description, String failingUrl) {

            Log.i(TAG, "AgentWebFragment onMainFrameError");
            agentWebUIController.onMainFrameError(view,errorCode,description,failingUrl);

        }*/

        @Override
        public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
            super.onReceivedHttpError(view, request, errorResponse);

//			Log.i(TAG, "onReceivedHttpError:" + 3 + "  request:" + mGson.toJson(request) + "  errorResponse:" + mGson.toJson(errorResponse));
        }

        @Override
        public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
           // handler.proceed();
            //super.onReceivedSslError(view, handler, error);
            final AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
            builder.setMessage(R.string.agentweb_message_show_ssl_error);
            builder.setPositiveButton("Continue", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    handler.proceed();
                }
            });
            builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                   handler.cancel();
                   // handler.proceed();
                }
            });
            final AlertDialog dialog = builder.create();
            dialog.show();
        }

        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            super.onReceivedError(view, errorCode, description, failingUrl);

//			Log.i(TAG, "onReceivedError:" + errorCode + "  description:" + description + "  errorResponse:" + failingUrl);
        }
    };

    protected void initView(View view) {
        mBackImageView = (ImageView) view.findViewById(R.id.iv_back);
        if (Config.getMMKV(getActivity()).getBoolean(Config.DAY_NIGHT_MODE, false))
        {
            mBackImageView.setImageResource(R.drawable.btn_back_night);
        }

        String strTitle = getActivity().getIntent().getStringExtra(Config.TYPE_TITLE);

        if (strTitle == null || strTitle.equals(""))
        {
            strTitle = getResources().getString(R.string.app_name);
        }

        mTitleTextView = (TextView) view.findViewById(R.id.toolbar_title);
        mTitleTextView.setText(strTitle);

        mBackImageView.setOnClickListener(mOnClickListener);
    }

    private View.OnClickListener mOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.iv_back:
                    EmbedWebviewFragment.this.getActivity().finish();
                    break;
                default:
                    break;
            }
        }

    };

    /**
     * 打开浏览器
     *
     * @param targetUrl 外部浏览器打开的地址
     */
    private void openBrowser(String targetUrl) {
        if (TextUtils.isEmpty(targetUrl) || targetUrl.startsWith("file://")) {
            Toast.makeText(getActivity(), targetUrl + " 该链接无法使用浏览器打开。", Toast.LENGTH_SHORT).show();
            return;
        }

        Intent intent = new Intent();
        intent.setAction("android.intent.action.VIEW");
        Uri mUri = Uri.parse(targetUrl);
        intent.setData(mUri);
        startActivity(intent);
    }


    /**
     * 显示更多菜单
     *
     * @param view 菜单依附在该View下面
     */
    private void showPoPup(View view) {

    }

    /**
     * 测试错误页的显示
     */
    private void loadErrorWebSite() {
        if (mAgentWeb != null) {
            mAgentWeb.getUrlLoader().loadUrl("http://www.unkownwebsiteblog.me");
        }
    }

    /**
     * 清除 WebView 缓存
     */
    private void toCleanWebCache() {

        if (this.mAgentWeb != null) {

            //清理所有跟WebView相关的缓存 ，数据库， 历史记录 等。
            this.mAgentWeb.clearWebCache();
            Toast.makeText(getActivity(), "已清理缓存", Toast.LENGTH_SHORT).show();
            //清空所有 AgentWeb 硬盘缓存，包括 WebView 的缓存 , AgentWeb 下载的图片 ，视频 ，apk 等文件。
//            AgentWebConfig.clearDiskCache(this.getContext());
        }

    }


    /**
     * 复制字符串
     *
     * @param context
     * @param text
     */
    private void toCopy(Context context, String text) {

        ClipboardManager mClipboardManager = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
        mClipboardManager.setPrimaryClip(ClipData.newPlainText(null, text));

    }

    @Override
    public void onResume() {
        mAgentWeb.getWebLifeCycle().onResume();//恢复
        super.onResume();
    }

    @Override
    public void onPause() {
        mAgentWeb.getWebLifeCycle().onPause(); //暂停应用内所有WebView ， 调用mWebView.resumeTimers();/mAgentWeb.getWebLifeCycle().onResume(); 恢复。
        super.onPause();
    }

    @Override
    public boolean onFragmentKeyDown(int keyCode, KeyEvent event) {
        return mAgentWeb.handleKeyEvent(keyCode, event);
    }

    @Override
    public void onDestroyView() {
        mAgentWeb.getWebLifeCycle().onDestroy();
       // FileCompressor.getInstance().unregisterFileCompressEngine(this);
        super.onDestroyView();
    }

    /**
     * MiddlewareWebClientBase 是 AgentWeb 3.0.0 提供一个强大的功能，
     * 如果用户需要使用 AgentWeb 提供的功能， 不想重写 WebClientView方
     * 法覆盖AgentWeb提供的功能，那么 MiddlewareWebClientBase 是一个
     * 不错的选择 。
     *
     * @return
     */
    protected MiddlewareWebClientBase getMiddlewareWebClient() {
        return this.mMiddleWareWebClient = new MiddlewareWebViewClient() {
            /**
             *
             * @param view
             * @param url
             * @return
             */
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
				/*if (url.startsWith("agentweb")) { // 拦截 url，不执行 DefaultWebClient#shouldOverrideUrlLoading
					Log.i(TAG, "agentweb scheme ~");
					return true;
				}*/

                if (super.shouldOverrideUrlLoading(view, url)) { // 执行 DefaultWebClient#shouldOverrideUrlLoading
                    return true;
                }
                // do you work
                return false;
            }

            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
                //MLog.d(TAG, "222shouldOverrideUrlLoading request url:" + request.getUrl().toString());
                return super.shouldOverrideUrlLoading(view, request);
            }

            @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
            @Override
            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (request.isForMainFrame() && error.getErrorCode() != -1) {
                        super.onReceivedError(view, request, error);
                    }
                }
            }
        };
    }

    protected MiddlewareWebChromeBase getMiddlewareWebChrome() {
        return this.mMiddleWareWebChrome = new MiddlewareChromeClient() {
        };
    }

    private static String byte2FitMemorySize(final long byteNum) {
        if (byteNum < 0) {
            return "shouldn't be less than zero!";
        } else if (byteNum < 1024) {
            return String.format(Locale.getDefault(), "%.1fB", (double) byteNum);
        } else if (byteNum < 1048576) {
            return String.format(Locale.getDefault(), "%.1fKB", (double) byteNum / 1024);
        } else if (byteNum < 1073741824) {
            return String.format(Locale.getDefault(), "%.1fMB", (double) byteNum / 1048576);
        } else {
            return String.format(Locale.getDefault(), "%.1fGB", (double) byteNum / 1073741824);
        }
    }
}
