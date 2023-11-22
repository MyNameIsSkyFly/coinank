package com.ank.ankapp.ank_app;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatDelegate;

import com.ank.ankapp.ank_app.original.Config;
import com.ank.ankapp.ank_app.original.Global;
import com.ank.ankapp.ank_app.original.activity.CommonFragmentActivity;
import com.ank.ankapp.ank_app.original.activity.CommonWebActivity;
import com.ank.ankapp.ank_app.original.activity.OIChgActivity;
import com.ank.ankapp.ank_app.original.activity.PriceChgActivity;
import com.ank.ankapp.ank_app.original.language.LanguageUtil;
import com.ank.ankapp.ank_app.original.utils.UrlGet;
import com.ank.ankapp.ank_app.pigeon_plugin.Messages;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
    Messages.MessageFlutterApi messageFlutterApi;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Messages.MessageHostApi.setUp(flutterEngine.getDartExecutor(), new HostMessageHandler());
        messageFlutterApi = new Messages.MessageFlutterApi(flutterEngine.getDartExecutor());
    }

    class HostMessageHandler implements Messages.MessageHostApi {

        @Override
        public void toTotalOi() {
            Intent i = new Intent();
            i.setClass(getActivity(), CommonFragmentActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.putExtra(Config.INDEX_TYPE, Config.TYPE_EXCHANGE_OI_FRAGMENT);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_open_interest));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void changeDarkMode(@NonNull Boolean isDark) {
            Config.getMMKV(getActivity()).putBoolean(Config.DAY_NIGHT_MODE, isDark);
            AppCompatDelegate.setDefaultNightMode(isDark ? AppCompatDelegate.MODE_NIGHT_YES : AppCompatDelegate.MODE_NIGHT_NO);

            Config.getMMKV(getActivity()).async();
        }

        @Override
        public void changeLanguage(@NonNull String languageCode) {
            if (languageCode.contains("en")) {
                LanguageUtil.changeAppLanguage(getContext(), "en");
            } else if (languageCode.contains("ja")) {
                LanguageUtil.changeAppLanguage(getContext(), "ja");
            } else if (languageCode.contains("ko")) {
                LanguageUtil.changeAppLanguage(getContext(), "ko");
            } else if (languageCode.contains("zh")) {
                if (languageCode.contains("Hans")) {
                    LanguageUtil.changeAppLanguage(getContext(), "zh_rCN");
                } else {
                    LanguageUtil.changeAppLanguage(getContext(), "zh_rTW");
                }
            }
        }

        @Override
        public void changeUpColor(@NonNull Boolean isGreenUp) {
            Config.getMMKV(getActivity()).putBoolean(Config.IS_GREEN_UP, isGreenUp);
        }

        @Override
        public void toLiqMap() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, UrlGet.getUrl(Config.urlLiqMap,
                    LanguageUtil.getWebLanguage(getContext())));
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_liqmap));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toLongShortAccountRatio() {
            Intent i = new Intent();
            i.setClass(getActivity(), CommonFragmentActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.putExtra(Config.INDEX_TYPE, Config.TYPE_LONGSHORT_ACCOUNTS_RATIO_FRAGMENT);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_longshort_person));
            Global.showActivity(getActivity(), i);

        }

        @Override
        public void toTakerBuyLongShortRatio() {
            Intent i = new Intent();
            i.setClass(getActivity(), CommonFragmentActivity.class);
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.putExtra(Config.INDEX_TYPE, Config.TYPE_TAKERBUY_LONGSSHORTS_FRAGMENT);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_buysel_longshort_ratio));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toOiChange() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), OIChgActivity.class);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_oi_chg));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toPriceChange() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), PriceChgActivity.class);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_price_chg));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toGreedIndex() {
            Intent i = new Intent();
            String url = "file:///android_asset/t7.html";
            url = Config.urlGreedIndex;
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, UrlGet.getUrl(url,
                    LanguageUtil.getWebLanguage(getContext())));
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_greed_index));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toBtcMarketRatio() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, UrlGet.getUrl(Config.urlBTCMarketCap,
                    LanguageUtil.getWebLanguage(getContext())));
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_marketcap_ratio));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toFuturesVolume() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, UrlGet.getUrl(Config.url24HOIVol,
                    LanguageUtil.getWebLanguage(getContext())));
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_futures_vol_24h));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toBtcProfitRate() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, UrlGet.getUrl(Config.urlBTCProfit,
                    LanguageUtil.getWebLanguage(getContext())));
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_btc_profit));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toGrayScaleData() {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, UrlGet.getUrl(Config.urlGrayscale,
                    LanguageUtil.getWebLanguage(getContext())));
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_grayscale_data));
            Global.showActivity(getActivity(), i);
        }

        @Override
        public void toFundRate() {

        }

        @Override
        public void toChartWeb(@NonNull String url, @NonNull String title) {
            Intent i = new Intent();
            i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            i.setClass(getActivity(), CommonWebActivity.class);
            i.putExtra(Config.TYPE_URL, Config.h5Prefix + url);
            i.putExtra(Config.TYPE_TITLE, getResources().getString(R.string.s_chart));
            Global.showActivity(getActivity(), i);
        }
    }
}
