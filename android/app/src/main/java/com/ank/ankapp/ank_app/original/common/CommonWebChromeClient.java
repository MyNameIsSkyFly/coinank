package com.ank.ankapp.ank_app.original.common;

import android.webkit.WebView;

import com.just.agentweb.WebChromeClient;

/**
 * @author cenxiaozhong
 * @date 2019/2/19
 * @since 1.0.0
 */
public class CommonWebChromeClient extends WebChromeClient {
	@Override
	public void onProgressChanged(WebView view, int newProgress) {
		  super.onProgressChanged(view, newProgress);
		//MLog.d("CommonWebChromeClient", "onProgressChanged:" + newProgress + "  view:" + view);
	}
}
