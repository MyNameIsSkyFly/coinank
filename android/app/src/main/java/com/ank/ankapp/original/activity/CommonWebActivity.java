package com.ank.ankapp.original.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.widget.FrameLayout;

import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.common.FragmentKeyDown;
import com.ank.ankapp.original.fragment.AgentWebFragment;
import com.ank.ankapp.original.fragment.SmartRefreshWebFragment;
import com.ank.ankapp.original.utils.MLog;


public class CommonWebActivity extends BaseActivity {

	private FrameLayout mFrameLayout;
	public static final String TYPE_KEY = "type_key";
	private FragmentManager mFragmentManager;
	private AgentWebFragment mAgentWebFragment;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		String url = getIntent().getStringExtra(Config.TYPE_URL);
		if (TextUtils.isEmpty(url))
		{
			finish();
			return;
		}

		setContentView(R.layout.activity_common);
		mFrameLayout = (FrameLayout) this.findViewById(R.id.container_framelayout);

		mFragmentManager = this.getSupportFragmentManager();
		openUrl(url);

		Global.getAnalytics(this).logEvent("user_action",
				Global.createBundle("oncreate", getClass().getSimpleName()));
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);
		String url = getIntent().getStringExtra(Config.TYPE_URL);
		if (TextUtils.isEmpty(url))
		{
			finish();
			return;
		}

		Bundle bundle = new Bundle();
		bundle.putString(AgentWebFragment.URL_KEY, url);
		mAgentWebFragment.setArguments(bundle);
		mAgentWebFragment.loadUrl(url);
		MLog.d("onNewIntent loadUrl:" + url);
	}



	private void openUrl(String url) {

		FragmentTransaction ft = mFragmentManager.beginTransaction();
		Bundle mBundle = null;
		mBundle = new Bundle();
		mBundle.putString(AgentWebFragment.URL_KEY, url);
		//普通的webview
		ft.add(R.id.container_framelayout,
				mAgentWebFragment = AgentWebFragment.getInstance(mBundle),
				AgentWebFragment.class.getName());


		//下拉刷新webview
		//ft.add(R.id.container_framelayout,
		//		mAgentWebFragment = SmartRefreshWebFragment.getInstance(mBundle = new Bundle()), AgentWebFragment.class.getName());

		//腾讯秒开webview，看不出明显作用
		//ft.add(R.id.container_framelayout, mAgentWebFragment = VasSonicFragment.create(mBundle = new Bundle()), AgentWebFragment.class.getName());
		//mBundle.putLong(Config.PARAM_CLICK_TIME, getIntent().getLongExtra(Config.PARAM_CLICK_TIME, -1L));

		ft.commit();
	}


	private void openFragment(int key) {

		FragmentTransaction ft = mFragmentManager.beginTransaction();
		Bundle mBundle = null;

		switch (key) {
			case Config.FLAG_GUIDE_DICTIONARY_PULL_DOWN_REFRESH:
				ft.add(R.id.container_framelayout,
						mAgentWebFragment = SmartRefreshWebFragment.getInstance(mBundle = new Bundle()), SmartRefreshWebFragment.class.getName());
				mBundle.putString(AgentWebFragment.URL_KEY, Config.h5Prefix);
				break;
			case Config.FLAG_GUIDE_DICTIONARY_USE_IN_FRAGMENT:
				ft.add(R.id.container_framelayout,
						mAgentWebFragment = AgentWebFragment.getInstance(mBundle = new Bundle()), AgentWebFragment.class.getName());
				mBundle.putString(AgentWebFragment.URL_KEY, Config.h5Prefix);
				break;
//			case Config.FLAG_GUIDE_DICTIONARY_VASSONIC_SAMPLE:
//				ft.add(R.id.container_framelayout, mAgentWebFragment = VasSonicFragment.create(mBundle = new Bundle()), AgentWebFragment.class.getName());
//				mBundle.putLong(Config.PARAM_CLICK_TIME, getIntent().getLongExtra(Config.PARAM_CLICK_TIME, -1L));
//				mBundle.putString(AgentWebFragment.URL_KEY, Config.h5Prefix);
//				break;
			default:
				break;

		}
		ft.commit();

	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		//一定要保证 mAentWebFragemnt 回调
//		mAgentWebFragment.onActivityResult(requestCode, resultCode, data);
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {

		AgentWebFragment mAgentWebFragment = this.mAgentWebFragment;
		if (mAgentWebFragment != null) {
			FragmentKeyDown mFragmentKeyDown = (FragmentKeyDown) mAgentWebFragment;
			if (mFragmentKeyDown.onFragmentKeyDown(keyCode, event)) {
				return true;
			} else {
				return super.onKeyDown(keyCode, event);
			}
		}

		return super.onKeyDown(keyCode, event);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		//System.exit(0);//退出webview所在进程
	}
}
