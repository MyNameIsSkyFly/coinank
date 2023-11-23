package com.ank.ankapp.original.fragment;

import android.graphics.Color;
import android.graphics.Picture;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.original.activity.BaseActivity;
import com.ank.ankapp.original.common.AndroidInterface;
import com.ank.ankapp.original.common.UIController;
import com.ank.ankapp.original.widget.WebLayout;
import com.just.agentweb.AgentWeb;
import com.just.agentweb.DefaultWebClient;
import com.just.agentweb.IWebLayout;

/**
 * Created by cenxiaozhong on 2017/7/1.
 * source code  https://github.com/Justson/AgentWeb
 */

public class BounceWebFragment extends AgentWebFragment {

	public static BounceWebFragment getInstance(Bundle bundle) {
		BounceWebFragment mBounceWebFragment = new BounceWebFragment();
		if (mBounceWebFragment != null){
			mBounceWebFragment.setArguments(bundle);
		}
		return mBounceWebFragment;
	}


	@Override
	public String getUrl() {
		return super.getUrl();
	}

	@Override
	public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {

		BaseActivity baseActivity = (BaseActivity)getActivity();
		baseActivity.setCookieValue();

		hideLoadingView(view);//下拉刷新webview隐藏中间的加载动画

		mAgentWeb = AgentWeb.with(this)
				.setAgentWebParent((ViewGroup) view.findViewById(R.id.ll_rootview), new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
				//.useDefaultIndicator(-1, 2)
				.useDefaultIndicator(Color.TRANSPARENT, 2)
				.setAgentWebWebSettings(getSettings())
				.setWebViewClient(mWebViewClient)
				.setWebChromeClient(mWebChromeClient)
				.setWebLayout(getWebLayout())
				.setSecurityType(AgentWeb.SecurityType.STRICT_CHECK)
				.setAgentWebUIController(new UIController(getActivity())) //自定义UI  AgentWeb3.0.0 加入。
				.interceptUnkownUrl()
				.additionalHttpHeader(getUrl(), "coinsohoweb", "coinsohoweb")
				.setOpenOtherPageWays(DefaultWebClient.OpenOtherPageWays.ASK)
				.setMainFrameErrorView(R.layout.agentweb_error_page, -1)
				.createAgentWeb()//
				.ready().get();//设置 WebSettings。

		if(mAgentWeb!=null){
			//注入对象给js调用，重要功能
			mAgentWeb.getJsInterfaceHolder().addJavaObject("coinsoto",new AndroidInterface(mAgentWeb, getActivity()));
		}


		mAgentWeb.getAgentWebSettings().getWebSettings().setDefaultFontSize(14);
		mAgentWeb.getAgentWebSettings().getWebSettings().setMinimumFontSize(8);

		mAgentWeb.getAgentWebSettings().getWebSettings().setAllowFileAccess(true);
		mAgentWeb.getAgentWebSettings().getWebSettings().setAllowFileAccessFromFileURLs(true);
		// 允许通过 file url 加载的 Javascript 可以访问其他的源，包括其他的文件和 http，https 等其他的源
		mAgentWeb.getAgentWebSettings().getWebSettings().setAllowUniversalAccessFromFileURLs(true);

		mAgentWeb.getWebCreator().getWebView().setPictureListener(new WebView.PictureListener() {
			@Override
			public void onNewPicture(WebView webView, @Nullable Picture picture) {
				//Log.i("info", "test2 setPictureListener");
				hideLoadingView(view);
			}
		});

		mAgentWeb.getWebCreator().getWebView().setBackgroundColor(0x00000000);
		mAgentWeb.getWebCreator().getWebView().setBackgroundResource(R.color.colorPrimary);
		mAgentWeb.getWebCreator().getWebView().loadUrl(getUrl());

		// 得到 AgentWeb 最底层的控件
		addBGChild((FrameLayout) mAgentWeb.getWebCreator().getWebParentLayout());
		initView(view);

		// AgentWeb 没有把WebView的功能全面覆盖 ，所以某些设置 AgentWeb 没有提供 ， 请从WebView方面入手设置。
		mAgentWeb.getWebCreator().getWebView().setOverScrollMode(WebView.OVER_SCROLL_NEVER);
	}

	protected IWebLayout getWebLayout() {
		return new WebLayout(getActivity());
	}

	protected void addBGChild(FrameLayout frameLayout) {

		TextView mTextView = new TextView(frameLayout.getContext());
		mTextView.setText("Coinsoto.com App");
		mTextView.setTextSize(16);
		mTextView.setTextColor(Color.parseColor("#727779"));
		frameLayout.setBackgroundColor(Color.parseColor("#272b2d"));
		FrameLayout.LayoutParams mFlp = new FrameLayout.LayoutParams(-2, -2);
		mFlp.gravity = Gravity.CENTER_HORIZONTAL;
		final float scale = frameLayout.getContext().getResources().getDisplayMetrics().density;
		mFlp.topMargin = (int) (15 * scale + 0.5f);
		frameLayout.addView(mTextView, 0, mFlp);
	}


}
