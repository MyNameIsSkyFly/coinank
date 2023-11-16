package com.ank.ankapp.ank_app.original.activity;

import android.os.Bundle;

import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;

import com.ank.ankapp.ank_app.R;
import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;
import com.ank.ankapp.ank_app.original.fragment.CominedKLineFragment;


public class MulKLineActivity extends BaseActivity {

	public static final String TYPE_KEY = "type_key";
	private FragmentManager mFragmentManager;
	private CominedKLineFragment kLineFragment01, kLineFragment02, kLineFragment03;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_mulkline);

		mFragmentManager = this.getSupportFragmentManager();
		openUrl();
		Global.getAnalytics(this).logEvent("user_action",
				Global.createBundle("oncreate", getClass().getSimpleName()));
		initToolBar();
		Global.mulKLineActivity = this;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Global.mulKLineActivity = null;
	}

	private void openUrl() {

		FragmentTransaction ft = mFragmentManager.beginTransaction();

		String currExchangeName = getIntent().getStringExtra(Config.TYPE_EXCHANGENAME);
		String currSymbol = getIntent().getStringExtra(Config.TYPE_SYMBOL);
		String currBaseCoin = getIntent().getStringExtra(Config.TYPE_BASECOIN);
		String currSwapType = getIntent().getStringExtra(Config.TYPE_SWAP);

		Bundle mBundle = new Bundle();
		mBundle.putString(Config.TYPE_EXCHANGENAME, "Binance");
		mBundle.putString(Config.TYPE_SYMBOL, "BTCUSDT");
		mBundle.putString(Config.TYPE_BASECOIN, "BTC");
		mBundle.putString(Config.TYPE_SWAP, "SWAP");
		mBundle.putString(Config.TYPE_CFG_PREFIX, "c1");

		ft.add(R.id.container_01,
				kLineFragment01 = CominedKLineFragment.getInstance(mBundle),
				CominedKLineFragment.class.getName());

		Bundle mBundle2 = new Bundle();
		mBundle2.putString(Config.TYPE_EXCHANGENAME, "Binance");
		mBundle2.putString(Config.TYPE_SYMBOL, "ETHUSDT");
		mBundle2.putString(Config.TYPE_BASECOIN, "ETH");
		mBundle2.putString(Config.TYPE_SWAP, "SWAP");
		mBundle2.putString(Config.TYPE_CFG_PREFIX, "c2");
		ft.add(R.id.container_02,
				kLineFragment02 = CominedKLineFragment.getInstance(mBundle2),
				CominedKLineFragment.class.getName());

		Bundle mBundle3 = new Bundle();
		mBundle3.putString(Config.TYPE_EXCHANGENAME, "Binance");
		mBundle3.putString(Config.TYPE_SYMBOL, "BNBUSDT");
		mBundle3.putString(Config.TYPE_BASECOIN, "BNB");
		mBundle3.putString(Config.TYPE_SWAP, "SWAP");
		mBundle3.putString(Config.TYPE_CFG_PREFIX, "c3");
		ft.add(R.id.container_03,
				kLineFragment03 = CominedKLineFragment.getInstance(mBundle3),
				CominedKLineFragment.class.getName());


		ft.commit();
	}
}
