package com.ank.ankapp.original.activity;

import android.os.Bundle;

import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.ank.ankapp.R;
import com.ank.ankapp.original.Config;
import com.ank.ankapp.original.Global;
import com.ank.ankapp.original.fragment.ExchangeOIFragment;
import com.ank.ankapp.original.fragment.LongsShortAccountsRatioFragment;
import com.ank.ankapp.original.fragment.TakerBuyLongShortFragment;


public class CommonFragmentActivity extends BaseActivity {

	private FragmentManager mFragmentManager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		setContentView(R.layout.activity_common_index_setting);
		initToolBar();
		int indexType = getIntent().getIntExtra(Config.INDEX_TYPE, Config.INDEX_MA);
		mFragmentManager = this.getSupportFragmentManager();
		openFragment(indexType);

		Global.getAnalytics(this).logEvent("user_action",
				Global.createBundle("oncreate fg type:" + indexType, getClass().getSimpleName()));
	}

	private void openFragment(int key) {

		FragmentTransaction ft = mFragmentManager.beginTransaction();
		Bundle mBundle = null;

		switch (key) {
//			case Config.INDEX_MA:
//				ft.add(R.id.fragment_view, MaSettingFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.INDEX_EMA:
//				ft.add(R.id.fragment_view, EMaSettingFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.INDEX_RSI:
//				ft.add(R.id.fragment_view, RsiSettingFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.INDEX_KDJ:
//				ft.add(R.id.fragment_view, KdjSettingFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.INDEX_MACD:
//				ft.add(R.id.fragment_view, MacdSettingFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.INDEX_BOLL:
//				ft.add(R.id.fragment_view, BollSettingFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.TYPE_LOGIN:
//				ft.add(R.id.fragment_view, LoginFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.TYPE_REGISTER:
//			case Config.TYPE_FORGOT_PASSWD:
//				ft.add(R.id.fragment_view, RegisterFragment.getInstance(mBundle = new Bundle()));
//				break;
//			case Config.TYPE_CHANGE_PASSWD:
//				ft.add(R.id.fragment_view, ChangePasswordFragment.getInstance(mBundle = new Bundle()));
//				break;
			case Config.TYPE_EXCHANGE_OI_FRAGMENT:
				ft.add(R.id.fragment_view, ExchangeOIFragment.getInstance(mBundle = new Bundle()));
				break;
			case Config.TYPE_TAKERBUY_LONGSSHORTS_FRAGMENT:
				ft.add(R.id.fragment_view, TakerBuyLongShortFragment.getInstance(mBundle = new Bundle()));
				break;
			case Config.TYPE_LONGSHORT_ACCOUNTS_RATIO_FRAGMENT:
				ft.add(R.id.fragment_view, LongsShortAccountsRatioFragment.getInstance(mBundle = new Bundle()));
				break;
		}
		ft.commit();

	}
}
