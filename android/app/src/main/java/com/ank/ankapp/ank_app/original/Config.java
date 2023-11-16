package com.ank.ankapp.ank_app.original;

import android.content.Context;
import android.text.TextUtils;

import com.ank.ankapp.ank_app.original.bean.UrlConfigVo;
import com.ank.ankapp.ank_app.original.utils.SQLiteKV;


public class Config {

    //如果是google play上架的aab版本，则设置本参数为true,如果是放在网站下载的apk版本，则设置为false
    //如果是要上架google 的aab版本，必须设置为true
    public static boolean isGooglePlayVersion = true;//请看上面的说明 ，aab格式上架的时候，需要拷贝上面so到指定目录

    public static boolean isLogDebug = false;//system.out日志开关,对外发布版本的时候可以关闭

    public static float FrictionCoef = 0.96F;//K线图滑动惯性因子,加速度
    public static float highlightTextSize = 1.0F;
    public static float barOffset = 0.0F;
    public static float highlightWidth = 0.5F;//0.5F

    public final static int FLAG_GUIDE_DICTIONARY_PULL_DOWN_REFRESH = 1;
    public final static int FLAG_GUIDE_DICTIONARY_USE_IN_FRAGMENT = 2;
    public final static int FLAG_GUIDE_DICTIONARY_VASSONIC_SAMPLE = 3;
    public static final String PARAM_CLICK_TIME = "clickTime";
    public static String DeviceID = "";

    public static String ACTION_SERVICE_BROADCAST = "ACTION_SERVICE_BROADCAST";
    public static String ACTION_BASEACTIVITY_BROADCAST = "ACTION_BASEACTIVITY_BROADCAST";
    public static String ACTION_KLINE_ADJUST_HEIGHT = "ACTION_KLINE_ADJUST_HEIGHT";
    public static String ACTION_KLINE_CHANGE_KLINE_STYLE = "ACTION_KLINE_CHANGE_KLINE_STYLE";
    public static String ACTION_CHANGE_MA_LINE_WIDTH_ = "ACTION_CHANGE_MA_LINE_WIDTH_";
    public static String TYPE_TITLE = "str_title";
    public static String TYPE_ARG = "arg";
    public static String TYPE_EXCHANGENAME = "TYPE_EXCHANGENAME";
    public static String TYPE_SYMBOL = "TYPE_SYMBOL";
    public static String TYPE_URL = "TYPE_URL";
    public static String TYPE_SWAP = "TYPE_SWAP";//合约类型
    public static String TYPE_BASECOIN = "TYPE_BASECOIN";//basecoin
    public static String TYPE_CFG_PREFIX = "TYPE_BASECOIN";//K线分屏界面配置前缀，c1, c2, c3


    public static String DAY_NIGHT_MODE = "dayNightMode";//夜间模式key
    public static String CONFIG_NAME = "uukr_setting";
    public static String IS_GREEN_UP = "is_green_up";
    public static String CONF_KLINE_PERIOD = "CONF_KLINE_PERIOD";
    public static String CONF_IS_MIN_PERIOD = "CONFIG_IS_MIN_PERIOD";//保存分时状态
    public static String CONF_VISIBLE_XRANGE = "CONF_VISIBLE_XRANGE";
    public static String CONF_MAIN_CHART_INDIC = "CONF_MAIN_CHART_INDIC";//主图指标int
    public static String CONF_SUB_CHART_INDIC = "CONF_SUB_CHART_INDIC";//副图指标int json数组
    public static String CONF_CURR_TIMESNAMP = "CONF_CURR_TIMESNAMP";//service tick update the timesnamp
    public static String CONF_STOP_STATUS = "CONF_STOP_STATUS";//boolean 临时数据，标识app内是否主动stop Float Service
    public static String CONF_TMP_TIMESTAMP_LONG = "CONF_TMP_TIMESTAMP";//注册界面发送验证码按钮倒计时用的时间戳(秒)
    public static String CONF_LOGIN_USER_INFO = "CONF_LOGIN_USER_INFO";
    public static String CONF_LOGIN_PWD = "CONF_LOGIN_PWD";
    public static String CONF_LOGIN_USERNAME = "CONF_LOGIN_USERNAME";
    public static String CONF_HIDE_WELCOME_PAGE = "CONF_HIDE_WELCOME_PAGE";//boolean主题切换的时候，暂时隐藏启动页
    public static String CONF_KLINE_FAVORITE_SYMBOL = "CONF_KLINE_FAVORITE_SYMBOL";//k线界面自选列表
    public static String CONF_FAVORITE_TAB_IDX = "CONF_FAVORITE_TAB_IDX";//K线自选框界面当前选中的标签
    public static String CONF_HOME_LONGS_SHORTS_PERIOD = "CONF_HOME_LONGS_SHORTS_PERIOD";//首页多空比周期
    public static String CONF_MARKET_SORT_BY = "CONF_MARKET_SORT_BY";
    public static String CONF_MARKET_SORT_TYPE = "CONF_MARKET_SORT_TYPE";//asc desc
    public static String CONF_DEVICEID = "CONF_DEVICEID";//PUSH id
    public static String CONF_MARKETS_DATA = "CONF_MARKETS_DATA";//保存行情json数据给搜索界面调用
    public static String CONF_BASE_COINS = "CONF_BASE_COINS";//保存币总数据给搜索界面调用
    public static String CONF_FLOATING_TEXT_SIZE = "CONF_FLOATING_TEXT_SIZE";//int类型
    public static String CONF_FLOATING_BG_ALPHA = "CONF_FLOATING_BG_ALPHA";//int类型
    public static String CONF_MARKET_IS_FAVORITE_SEL = "CONF_MARKET_IS_FAVORITE_SEL";//行情标签 自选按钮状态配置
    public static String CONF_ALL_SYMBOLS = "CONF_ALL_SYMBOLS";//所有交易对信息
    public static String CONF_LEFT_NAV_MENU_JSON = "CONF_LEFT_NAV_MENU_JSON";//导航菜单json数据
    public static String CONF_URL_CONFIG = "CONF_URL_CONFIG";
    public static String CONF_KCHART_HEIGHT = "CONF_KCHART_HEIGHT";//int
    public static String CONF_UP_CANDLE_STYLE = "CONF_UP_CANDLE_STYLE";//int 1 solid 0 hollow
    public static String CONF_MA_LINE_WIDTH = "CONF_MA_LINE_WIDTH";//int 0,1,2
    public static String CONF_IS_FIRST_ENTER_KLINE_PAGE = "CONF_IS_FIRST_ENTER_KLINE_PAGE";//boolean
    public final static float line_width_small = 1.0F;
    public final static float line_width_middle = 1.5F;
    public final static float line_width_large = 2.0F;

    public static String FLOAT_VIEW_X = "float_x";
    public static String FLOAT_VIEW_Y = "float_y";
    public static String IS_FLOAT_VIEW_SHOW = "is_float_view_show";//是否显示悬浮窗
    public static String IS_FLOAT_VIEW_LOCK = "is_float_view_lock";//悬浮窗是否可以触摸移动
    public static String FLOAT_VIEW_TICKERS_JSON = "FLOAT_VIEW_TICKERS_JSON";//悬浮窗显示的symbol数据

    //原生界面混合webview用echarts框架快速显示图表用的html，可以在服务器改配置文件实现替换本地的html
    public static String urlCommonChart = "file:///android_asset/t18.html";
    public static String urlImagePrefix = "https://cdn01.coinsoto.com/image/coin/64/";

    //app版本检测版本更新文件
    public static String urlVersionCheck = "https://coinsoho.s3.us-east-2.amazonaws.com/app/androidwebversion.txt";
    //安卓和ios通用配置文件，包括域名等参数
    public static String urlAppConfig = "https://coinsoho.s3.us-east-2.amazonaws.com/app/config.txt";
    public static String websocketUrl = "wss://coinsoto.com/wsKline/wsKline";
    public static String strDomain = "coinsoto.com";
    public static String h5Prefix = "https://" + strDomain;
    public static String apiPrefix = "https://coinsoto.com";


    public static String urlDepth = "https://cdn01.coinsoto.com/mview2/nested/depth.html";
    //此域名用于K线界面挂单及最新成交url，用来保存cookie用
    public static String depthOrderDomain = "cdn01.coinsoto.com";

    //uni-app 爆仓，持仓，资金费率页面域名配置
    public static String uniappDomain = "coinsoto-h5.s3.ap-northeast-1.amazonaws.com";

    //
    //H5页面url配置
    public static String urlFuturesMarkets = h5Prefix + "/%sm/contracts/instruments";
    public static String urlChart = h5Prefix + "/%sm/charts";
    public static String urlPrivacy = h5Prefix + "/%sprivacy";
    public static String urlDisclaimer = h5Prefix + "/%sdisclaimer";
    public static String urlAbout = h5Prefix + "/%sabout";
    public static String urlPortfolio = h5Prefix + "/%susers/portfolio";
    public static String urlGreedIndex = h5Prefix + "/%sindexdata/feargreedIndex";
    public static String urlAddAlert = h5Prefix + "/%susers/noticeConfig";
    public static String urlOI = h5Prefix + "/%sopenInterest/contract";
    public static String urlBTCMarketCap = h5Prefix + "/%sindexdata/btcMarketCap";
    public static String url24HOIVol = h5Prefix + "/%sindexdata/oivol/vol24h";
    public static String urlBTCProfit = h5Prefix + "/%sindexdata/profit";
    public static String urlGrayscale = h5Prefix + "/%sgrayscale";
    public static String urlLiqMap = h5Prefix + "/%sliqMapChart";
    public static String urlProChart = h5Prefix + "/%sproChart";

    public static String urlFundingRate = h5Prefix + "/%sfundingRate/current";
    public static String urlLiquidation = h5Prefix + "/%sliquidation";
    public static String urlLongShort = h5Prefix + "/%slongshort/realtime";
    public static String urlPersonLongsShortRatio = h5Prefix + "/%slongshort/longShortPersonRatio";


    //api接口配置
    public static String klineUrl = apiPrefix + "/api/kline/list?" +
            "exchange=%s&symbol=%s&interval=%s&side=to&ts=%s&size=200";
    public static String apiGetVerifyCode = apiPrefix + "/api/User/sendVerifyCode";
    public static String apiRegister = apiPrefix + "/api/User/register";
    public static String apiRemoveUserData = apiPrefix + "/api/User/logOff";
    public static String apiLogin = apiPrefix + "/api/User/login";
    public static String apiLoginOut = apiPrefix + "/api/User/logOut";
    public static String apiGetHeadStatistics = apiPrefix + "/api/Statistics/all";
    public static String apiGetHomeFundRateData = apiPrefix + "/api/fundingRate/top?type=LAST&size=3";
    public static String apiGetAllSymbol = apiPrefix + "/api/baseCoin/symbols";
    public static String apiGetHomeOI = apiPrefix + "/api/openInterest/all?baseCoin=BTC";
    public static String apiGetHomeFunding = apiPrefix + "/api/fundingRate/currentByCoin?baseCoin=BTC";
    public static String apiGetFundRateLiveData = apiPrefix + "/api/fundingRate/current?type=%s";
    public static String apiGetHomeLiquidation = apiPrefix + "/api/liquidation/allExchange/intervals?baseCoin=";
    public static String apiGetLastGreedIndex = apiPrefix + "/indicatorapi/getCnnEntityLast";
    public static String apiGetTakerBuyLongShortRatio = apiPrefix + "/api/longshort/realtimeAll?interval=%s&baseCoin=%s";
    public static String apiGetTickers = apiPrefix + "/api/instruments/agg?page=1&size=300&sortBy=%s&sortType=%s";
    public static String apiGetFuturesBigData = apiPrefix + "/api/instruments/agg?page=%d&size=%d&sortBy=%s&sortType=%s";
    public static String apiGetLongsShortRatio = apiPrefix + "/api/longshort/longShortRatioMini?baseCoin=BTC&interval=5m";
    public static String apiFavoriteDel = apiPrefix + "/api/userFollow/delFollow?type=1&baseCoin=%s";//行情自选删除操作
    public static String apiFavoriteAdd = apiPrefix + "/api/userFollow/addOrUpdateFollow?type=1&baseCoin=%s";//行情自选添加操作
    public static String apiGetExchangeOIList= apiPrefix + "/api/openInterest/all?baseCoin=%s";
    public static String apiGetGridMenu= apiPrefix + "/api/app/indicationMain?locale=%s";
    public static String apiGetLeftNavMenuData= apiPrefix + "/api/app/indicationNavs?locale=%s";
    public static String apiGetLongShortAccountsRatioChartData = apiPrefix +
            "/api/longshort/longShortRatio?limit=30&exchangeName=%s&interval=%s&baseCoin=%s&exchangeType=%s&type=%s";
    public static String apiGetAppNotice = apiPrefix + "/api/app/notice?locale=%s";

    //智能提醒历史数据,type ： signal 拉盘  openSignal  持仓异动
    public static String apiGetHistoryRemindSignal = apiPrefix + "/api/Statistics/querySignalList?type=%s";
    //设置app的一些参数配置，本地语言，时区偏移，设备类型android ios，推送平台huawei, alipush, jpush, google, xiaomi
    public static String apiSetAppParams = apiPrefix + "/api/User/saveSetting?" +
            "language=%s&deviceId=%s&offset=%d&deviceType=%s&pushPlatform=%s";

    //获取币种各交易对合约相关信息详情
    public static String apiGetCoinFuturesDetail = apiPrefix + "/api/tickers?baseCoin=%s";
    public static String apiGetAllBaseCoins = apiPrefix + "/api/baseCoin";//获取所有币种
    public static String apiGetOIChartData = apiPrefix + "/api/openInterest/chart?size=100&baseCoin=%s&interval=%s&type=%s";
    public static String apiGetTakerBuyRatioChartData = apiPrefix + "/api/longshort/realtime?exchangeName=&interval=%s&baseCoin=%s";

    public static String apiGetLongsShortsOIPersonRatio = apiPrefix + "/api/longshort/person?" +
            "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//多空持仓人数比
    public static String apiGetLongsShortsTopAccountRatio = apiPrefix + "/api/longshort/account?" +
            "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//大户账户数多空比
    public static String apiGetLongsShortsTopPositionRatio = apiPrefix + "/api/longshort/position?" +
            "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//大户持仓量多空比

    public static String apiOIVipIndex = apiPrefix + "/api/openInterest/symbol/Chart?" +
            "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//vip 合约持仓量指标
    public static String apiFundingRateVipIndex = apiPrefix + "/api/fundingRate/indicator?" +
            "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//vip 资金费率指标

    public static String apiOIFrVolumeFr = apiPrefix + "/api/fundingRate/getWeiFundingfRate?" +
            "baseCoin=%s&interval=%s&endTime=%s&size=200";//vip 持仓加权fr和成交量加权fr指标

    public static String apiSymbolLiqVipIndex = apiPrefix + "/api/liquidation/symbolkline?" +
            "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//vip 交易对爆仓指标
    public static String apiCoinLiqVipIndex = apiPrefix + "/api/liquidation/kline?" +
            "baseCoin=%s&interval=%s&endTime=%s&size=200&exchangeName=%s&symbol=%s";//vip 币种爆仓指标
    public static String apiOIKline = apiPrefix + "/api/openInterest/kline?symbol=%s" +
            "&exchangeName=%s&endTime=%s&size=200&interval=%s";//vip 合约持仓K线指标 kline
    public static String apiFrKline = apiPrefix + "/api/fundingRate/kline?symbol=%s&" +
            "exchangeName=%s&endTime=%s&size=200&interval=%s";//vip  资金费率K线指标 kline
    public static String apiCoinOIKline = apiPrefix + "/api/openInterest/kline3?" +
            "endTime=%s&size=200&interval=%s&baseCoin=%s&exchangeName=%s&symbol=%s";//币种持仓K线指标

    public static String apiGetLongShortRatioK = apiPrefix + "/api/longshort/kline?" +
            "endTime=%s&size=200&interval=%s&exchangeName=%s&symbol=%s&type=%s";//多空比K

    public final static String INDEX_TYPE = "index_type";
    public final static int INDEX_MA = 1;
    public final static int INDEX_EMA = 2;
    public final static int INDEX_BOLL = 3;
    public final static int INDEX_MACD = 4;
    public final static int INDEX_KDJ = 5;
    public final static int INDEX_RSI = 6;

    public final static int TYPE_LOGIN = 100;
    public final static int TYPE_REGISTER = 101;
    public final static int TYPE_FORGOT_PASSWD = 102;
    public final static int TYPE_CHANGE_PASSWD = 103;
    public final static int TYPE_EXCHANGE_OI_FRAGMENT = 104;
    public final static int TYPE_TAKERBUY_LONGSSHORTS_FRAGMENT = 105;
    public final static int TYPE_LONGSHORT_ACCOUNTS_RATIO_FRAGMENT = 106;

    public  static int greenColor = 0;//全局绿色
    public  static int redColor = 0;//全局红色
    public static boolean isNightMode = false;//黑夜模式

    public static SQLiteKV getMMKV(Context cot)
    {
        //return MMKV.mmkvWithID(CONFIG_NAME, MMKV.MULTI_PROCESS_MODE);
        return new SQLiteKV(cot);
    }

    public static void setUrlConfig(UrlConfigVo urlConfigVo)
    {
        urlDepth = urlConfigVo.getNewUrlDepth();//1.0.14版本之后用这个新的配置，
        depthOrderDomain = urlConfigVo.getNewDepthOrderDomain();//1.0.14版本之后用这个新的配置，
        if (urlDepth == null)
        {
            urlDepth = urlConfigVo.getUrlDepth();
        }

        if (depthOrderDomain == null)
        {
            depthOrderDomain = urlConfigVo.getDepthOrderDomain();
        }

        if (urlConfigVo.getUniappDomain() != null)
        {
            uniappDomain = urlConfigVo.getUniappDomain();
        }

        //如果服务器的配置不为空
        if (!TextUtils.isEmpty(urlConfigVo.urlCommonChart))
        {
            Config.urlCommonChart = urlConfigVo.urlCommonChart;
        }

        if (!TextUtils.isEmpty(urlConfigVo.urlImagePrefix))
        {
            Config.urlImagePrefix = urlConfigVo.urlImagePrefix;
        }

        strDomain = urlConfigVo.getStrDomain();
        websocketUrl = urlConfigVo.getWebsocketUrl();
        apiPrefix = urlConfigVo.getApiPrefix();
        h5Prefix = urlConfigVo.getH5Prefix();

         //H5页面url配置
         urlFuturesMarkets = h5Prefix + "/%sm/contracts/instruments";
         urlChart = h5Prefix + "/%sm/charts";
         urlPrivacy = h5Prefix + "/%sprivacy";
         urlDisclaimer = h5Prefix + "/%sdisclaimer";
         urlAbout = h5Prefix + "/%sabout";
         urlPortfolio = h5Prefix + "/%susers/portfolio";
         urlGreedIndex = h5Prefix + "/%sindexdata/feargreedIndex";
         urlAddAlert = h5Prefix + "/%susers/noticeConfig";

         urlBTCMarketCap = h5Prefix + "/%sindexdata/btcMarketCap";
         url24HOIVol = h5Prefix + "/%sindexdata/oivol/vol24h";
         urlBTCProfit = h5Prefix + "/%sindexdata/profit";
         urlGrayscale = h5Prefix + "/%sgrayscale";
         urlLiqMap = h5Prefix + "/%sliqMapChart";
         urlProChart = h5Prefix + "/%sproChart";

         urlFundingRate = "https://" + uniappDomain  + "/index.html#/pages/fundingRate/index";
         urlOI = "https://" + uniappDomain + "/index.html#/";
         urlLiquidation = "https://" + uniappDomain + "/index.html#/pages/liquidation/index";

         urlLongShort = h5Prefix + "/%slongshort/realtime";
         urlPersonLongsShortRatio = h5Prefix + "/%slongshort/longShortPersonRatio";

        //api接口配置
        klineUrl = apiPrefix + "/api/kline/list?" +
                "exchange=%s&symbol=%s&interval=%s&side=to&ts=%s&size=200";
         apiGetVerifyCode = apiPrefix + "/api/User/sendVerifyCode";
         apiRegister = apiPrefix + "/api/User/register";
         apiLogin = apiPrefix + "/api/User/login";
         apiLoginOut = apiPrefix + "/api/User/logOut";
         apiGetHeadStatistics = apiPrefix + "/api/Statistics/all";
         apiGetHomeFundRateData = apiPrefix + "/api/fundingRate/top?type=LAST&size=3";
         apiGetAllSymbol = apiPrefix + "/api/baseCoin/symbols";
         apiGetHomeOI = apiPrefix + "/api/openInterest/all?baseCoin=BTC";
         apiGetExchangeOIList= apiPrefix + "/api/openInterest/all?baseCoin=%s";
         apiGetGridMenu= apiPrefix + "/api/app/indicationMain?locale=%s";
         apiGetLeftNavMenuData= apiPrefix + "/api/app/indicationNavs?locale=%s";
         apiGetLongShortAccountsRatioChartData = apiPrefix +
                "/api/longshort/longShortRatio?limit=30&exchangeName=%s&interval=%s&baseCoin=%s&exchangeType=%s&type=%s";
        apiGetAppNotice = apiPrefix + "/api/app/notice?locale=%s";


         apiGetFundRateLiveData = apiPrefix + "/api/fundingRate/current?type=%s";
         apiGetHomeFunding = apiPrefix + "/api/fundingRate/currentByCoin?baseCoin=BTC";
         apiGetHomeLiquidation = apiPrefix + "/api/liquidation/allExchange/intervals?baseCoin=";
         apiGetLastGreedIndex = apiPrefix + "/indicatorapi/getCnnEntityLast";
         apiGetTakerBuyLongShortRatio = apiPrefix + "/api/longshort/realtimeAll?interval=%s&baseCoin=%s";
         apiGetTickers = apiPrefix + "/api/instruments/agg?page=1&size=300&sortBy=%s&sortType=%s";
         apiGetFuturesBigData = apiPrefix + "/api/instruments/agg?page=%d&size=%d&sortBy=%s&sortType=%s";
         apiGetLongsShortRatio = apiPrefix + "/api/longshort/longShortRatioMini?baseCoin=BTC&interval=5m";
         apiFavoriteDel = apiPrefix + "/api/userFollow/delFollow?type=1&baseCoin=%s";//行情自选删除操作
         apiFavoriteAdd = apiPrefix + "/api/userFollow/addOrUpdateFollow?type=1&baseCoin=%s";//行情自选添加操作
         apiGetHistoryRemindSignal = apiPrefix + "/api/Statistics/querySignalList?type=%s";
         apiSetAppParams = apiPrefix + "/api/User/saveSetting?" +
                "language=%s&deviceId=%s&offset=%d&deviceType=%s&pushPlatform=%s";
        apiGetCoinFuturesDetail = apiPrefix + "/api/tickers?baseCoin=%s";
        apiGetAllBaseCoins = apiPrefix + "/api/baseCoin";//获取所有币种
        apiGetOIChartData = apiPrefix + "/api/openInterest/chart?size=100&baseCoin=%s&interval=%s&type=%s";
        apiGetTakerBuyRatioChartData = apiPrefix + "/api/longshort/realtime?exchangeName=&interval=%s&baseCoin=%s";

        apiGetLongsShortsOIPersonRatio = apiPrefix + "/api/longshort/person?" +
                "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//多空持仓人数比
         apiGetLongsShortsTopAccountRatio = apiPrefix + "/api/longshort/account?" +
                "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//大户账户数多空比
         apiGetLongsShortsTopPositionRatio = apiPrefix + "/api/longshort/position?" +
                "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//大户持仓量多空比
         apiOIVipIndex = apiPrefix + "/api/openInterest/symbol/Chart?" +
                "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//vip 合约持仓量指标
         apiFundingRateVipIndex = apiPrefix + "/api/fundingRate/indicator?" +
                "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//vip 资金费率指标

        apiOIFrVolumeFr = apiPrefix + "/api/fundingRate/getWeiFundingfRate?" +
                "baseCoin=%s&interval=%s&endTime=%s&size=200";//vip 持仓加权fr和成交量加权fr指标

        apiSymbolLiqVipIndex = apiPrefix + "/api/liquidation/symbolkline?" +
                "exchangeName=%s&symbol=%s&interval=%s&endTime=%s&size=200";//vip 交易对爆仓指标
        apiCoinLiqVipIndex = apiPrefix + "/api/liquidation/kline?" +
                "baseCoin=%s&interval=%s&endTime=%s&size=200&exchangeName=%s&symbol=%s";//vip 币种爆仓指标

        apiOIKline = apiPrefix + "/api/openInterest/kline?symbol=%s" +
                "&exchangeName=%s&endTime=%s&size=200&interval=%s";//vip oi kline
        apiFrKline = apiPrefix + "/api/fundingRate/kline?symbol=%s&" +
                "exchangeName=%s&endTime=%s&size=200&interval=%s";//vip  fr kline
        apiCoinOIKline = apiPrefix + "/api/openInterest/kline3?" +
                "endTime=%s&size=200&interval=%s&baseCoin=%s&exchangeName=%s&symbol=%s";

        apiGetLongShortRatioK = apiPrefix + "/api/longshort/kline?" +
                "endTime=%s&size=200&interval=%s&exchangeName=%s&symbol=%s&type=%s";//多空比K

    }

}
