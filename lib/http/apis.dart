import 'dart:io';

import 'package:ank_app/entity/activity_entity.dart';
import 'package:ank_app/entity/app_setting_entity.dart';
import 'package:ank_app/entity/category_info_item_entity.dart';
import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/entity/coin_detail_entity.dart';
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/entity/fund_his_list_entity.dart';
import 'package:ank_app/entity/kline_entity.dart';
import 'package:ank_app/entity/liq_all_exchange_entity.dart';
import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:ank_app/entity/news_entity.dart';
import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/entity/order_flow_symbol.dart';
import 'package:ank_app/entity/search_v2_entity.dart';
import 'package:ank_app/entity/short_rate_entity.dart';
import 'package:ank_app/entity/user_info_entity.dart';
import 'package:ank_app/http/base_interceptor.dart';
import 'package:ank_app/util/http_adapter/_http_adapter_api.dart'
    if (dart.library.io) 'package:ank_app/util/http_adapter/_http_adapter_io.dart'
    if (dart.library.html) 'package:ank_app/util/http_adapter/_http_adapter_html.dart'
    as native_adapter;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';

// import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../constants/urls.dart';
import '../entity/btc_reduce_entity.dart';
import '../entity/category_grid_entity.dart';
import '../entity/coin_detail_contract_info_entity.dart';
import '../entity/futures_big_data_entity.dart';
import '../entity/head_statistics_entity.dart';
import '../entity/hold_address_entity.dart';
import '../entity/home_fund_rate_entity.dart';
import '../entity/market_cap_entity.dart';
import '../entity/push_record_entity.dart';

part 'apis.g.dart';

@RestApi()
abstract class Apis {
  static final Dio dio = Dio()
    ..httpClientAdapter = native_adapter.getNativeAdapter()
    ..interceptors.addAll([
      // TalkerDioLogger(
      //   settings: const TalkerDioLoggerSettings(
      //     printRequestHeaders: true,
      //     printResponseHeaders: true,
      //   ),
      // ),
      BaseInterceptor(),
    ])
    ..options.headers.addAll({
      if (!kIsWeb)
        'client': Platform.isAndroid ? 'android' : 'ios'
      else
        'client': 'android',
    })
    ..options.baseUrl = Urls.apiPrefix
    ..options.connectTimeout = const Duration(seconds: 10)
    ..options.receiveTimeout = const Duration(seconds: 30)
    ..options.sendTimeout = const Duration(seconds: 30);

  factory Apis() => _instance;

  static final Apis _instance = _Apis(dio);

  @GET('/api/Statistics/all')
  Future<HomeInfoEntity?> getHeadStatistics();

  @POST('/api/instruments/agg')
  Future<TickersDataEntity?> postFuturesBigData(
    @Body() Map<String, String?> body, {
    @Query('page') required int page,
    @Query('size') required int size,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('isFollow') bool? isFollow,
    @Query('baseCoins') String? baseCoins,
    @Query('tag') String? tag,
  });

  @Extra({'showToast': false})
  @GET('/api/instruments/agg')
  Future<TickersDataEntity?> getFuturesBigData({
    @Query('page') required int page,
    @Query('size') required int size,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('sort') String? sort,
    @Query('isFollow') bool? isFollow,
    @Query('baseCoin') String? baseCoin,
    @Query('baseCoins') String? baseCoins,
    @Query('tag') String? tag,
    @Query('like') bool? like,
  });

  @GET('/api/fundingRate/top?type=LAST&size=3')
  Future<List<HomeFundRateEntity>?> getHomeFundRateData();

  @GET('/api/baseCoin')
  Future<List<String>?> getMarketAllCurrencyData();

  @GET('/api/tickers')
  Future<List<ContractMarketEntity>?> getContractMarketData(
      {@Query('baseCoin') required String baseCoin,
      @Query('sortBy') String? sortBy,
      @Query('sortType') String? sortType});

  @GET('/api/fundingRate/current')
  Future<List<MarkerFundingRateEntity>?> getMarketFundingRateData(
      {@Query('type') required String type, @Query('isFollow') bool? isFollow});

  @GET('/api/app/indicationMain')
  Future<List<ChartEntity>?> getChartData(
      {@Query('locale') required String locale});

  @GET('/api/app/indicationNavs')
  Future<List<ChartSubItem>?> getChartLeftData(
      {@Query('locale') required String locale});

  @POST('/api/User/login')
  @MultiPart()
  Future<UserInfoEntity?> login(
      @Part(name: 'userName') String userName,
      @Part(name: 'passWord') String passWord,
      @Part(name: 'deviceId') String deviceId);

  @POST('/api/User/logOut')
  @MultiPart()
  Future logout(
      {@Part(name: 'none') String userName = 'none',
      @Header('token') String? header});

  @POST('/api/User/register')
  @MultiPart()
  Future register(
      @Part(name: 'userName') String userName,
      @Part(name: 'passWord') String passWord,
      @Part(name: 'code') String code,
      @Part(name: 'type') String type,
      {@Part(name: 'referral') String? referral});

  @POST('/api/User/sendVerifyCode')
  @MultiPart()
  Future sendCode(
      @Part(name: 'userName') String userName, @Part(name: 'type') String type);

  @POST('/api/User/logOff')
  @MultiPart()
  Future deleteAccount(
    @Part(name: 'userName') String userName,
    @Part(name: 'passWord') String passWord,
    @Part(name: 'code') String code,
  );

  //行情添加关注
  @GET('/api/userFollow/addOrUpdateFollow')
  Future getAddFollow({
    @Query('baseCoin') required String baseCoin,
    @Query('type') int type = 1,
  });

  @POST('/api/userFollow/addOrUpdateFollow')
  @MultiPart()
  Future postAddFollow({
    @Part(name: 'baseCoin') required String baseCoin,
    @Part(name: 'type') int type = 1,
  });

  //行情删除关注
  @GET('/api/userFollow/delFollow')
  Future getDelFollow({
    @Query('baseCoin') required String baseCoin,
    @Query('type') int type = 1,
  });

  @POST('/api/userFollow/delFollow')
  @MultiPart()
  Future postDelFollow({
    @Part(name: 'baseCoin') required String baseCoin,
    @Part(name: 'type') int type = 1,
  });

  //保存信息(极光注册的设备id,当前应用语言等等)
  @GET('/api/User/saveSetting')
  Future getOtherInfo({
    @Query('deviceId') required String deviceId,
    @Query('language') required String language,
    @Query('offset') required int offset,
    @Query('deviceType') required String deviceType,
    @Query('pushPlatform') required String pushPlatform,
    @Query('version') required String version,
  });

  //持仓html的json
  @GET('/api/openInterest/chart')
  Future getChartJson({
    @Query('baseCoin') String? baseCoin,
    @Query('interval') String? interval,
    @Query('type') String? type,
    @Query('size') int? size = 100,
  });

  @GET('/api/volume24h/chart')
  Future getVol24hChartJson({
    @Query('baseCoin') String? baseCoin,
    @Query('interval') String? interval,
    @Query('exchangeName') String? exchangeName,
    @Query('size') int size = 100,
  });

  @GET('/api/volume24h/spotChart')
  Future getVol24hSpotChartJson({
    @Query('baseCoin') String? baseCoin,
    @Query('interval') String? interval,
    @Query('exchangeName') String? exchangeName,
    @Query('size') int size = 100,
  });

  //
  // //合约持仓2
  // @GET('/api/instruments/aggForIos')
  // Future<TickersDataEntity?> getFuturesBigData2({
  //   @Query('page') required int page,
  //   @Query('size') required int size,
  //   @Query('sortBy') String? sortBy,
  //   @Query('sortType') required String sortType,
  //   @Query('sort') String? sort,
  //   @Query('openInterest') String? openInterest,
  //   @Query('isFollow') int? isFollow,
  //   @Query('type') String? type,
  // });

  //多空比
  @GET('/api/longshort/realtimeAll')
  Future<List<ShortRateEntity>?> getShortRateData({
    @Query('interval') required String interval,
    @Query('baseCoin') required String baseCoin,
  });

  //获取多空比js交互数据
  @GET('/api/longshort/realtime')
  Future<ShortRateEntity?> getShortRateJSData({
    @Query('interval') required String interval,
    @Query('baseCoin') required String baseCoin,
    @Query('exchangeName') required String exchangeName,
  });

  //持仓html的json
  @GET('/api/openInterest/all')
  Future<List<OIEntity>?> getExchangeIOList({
    @Query('baseCoin') String? baseCoin,
  });

  //清算地图币种列表
  @GET('/api/liqMap/getLiqMapSymbolV1')
  Future<List<String>?> getLiqMapData();

  //清算地图html json
  @GET('/api/liqMap/getLiqMap')
  Future getLiqMapJsonData({
    @Query('interval') required String interval,
    @Query('symbol') required String symbol,
    @Query('exchange') required String exchange,
  });

  //聚合清算地图html json
  @GET('/api/liqMap/getAggLiqMap')
  Future getAggLiqMap({
    @Query('interval') required String interval,
    @Query('baseCoin') required String baseCoin,
  });

  //多空持仓人数比
  @Extra({'dataKey': 'original'})
  @GET('/api/longshort/longShortRatio')
  Future getLongShortPersonRatio({
    @Query('baseCoin') String? baseCoin,
    @Query('exchangeName') String? exchangeName,
    @Query('interval') String? interval,
    @Query('type') String? type,
    @Query('exchangeType') String? exchangeType,
    @Query('limit') int limit = 30,
  });

  //清算热图币种列表
  @GET('/api/liqMap/getLiqHeatMapSymbol')
  Future<List<String>?> getLiqHeatMapData();

  //活动提醒
  @Extra({'showToast': false})
  @GET('/api/app/getAppNotice')
  Future<ActivityEntity?> getActivityData({@Query('lan') String? lan});

  //设置页面动态配置的按钮
  @GET('/api/app/getAppSetting')
  Future<List<AppSettingEntity>?> getAppSetting({@Query('lan') String? lan});

  //搜索v2
  @GET('/api/baseCoin/searchV2')
  Future<SearchV2Entity?> searchV2({@Query('search') String? keyword});

  @POST('/api/app/getBtcReduce')
  Future<BtcReduceEntity?> getBtcReduce();

  @GET('/api/tickers/agg')
  Future<CoinDetailContractInfoEntity?> getCoinDetailContractInfo(
      @Query('baseCoin') String baseCoin);

  @Extra({'showToast': false})
  @GET('/api/instruments/getTicker24h')
  Future<ContractMarketEntity?> getCoinInfo24h(
    @Query('baseCoin') String baseCoin, {
    @Query('productType') String productType = 'SWAP',
  });

  @GET('/api/tickers/getSpotTickers')
  Future<List<ContractMarketEntity>?> getSpotTickers(
      @Query('baseCoin') String baseCoin);

  @GET('/api/instruments/coinDetail')
  Future<CoinDetailEntity?> getCoinDetail(@Query('baseCoin') String baseCoin);

  @GET('/api/instruments/marketCapTop')
  Future<List<MarketCapEntity>?> getMarketCapTop(@Query('limit') int limit);

  @GET('/indicatorapi/chain/btc/holdAddress')
  Future<HoldAddressEntity?> getHoldAddress(@Query('baseCoin') String baseCoin,
      {@Query('code') String? code});

  @GET('/api/fundingRate/getWeiFrChart')
  Future getWeightFundingRate(@Query('baseCoin') String baseCoin,
      {@Query('interval') String? interval,
      @Query('endTime') int? endTime,
      @Query('size') int? size});

  @GET('/api/baseCoin/symbols')
  Future<List<OrderFlowSymbolEntity>?> getOrderFlowSymbols({
    @Query('productType') String? productType,
    @Query('follow') bool follow = false,
    @Query('exchangeName') String? exchangeName,
  });

  @GET('/api/instruments/spotAgg')
  Future<TickersDataEntity?> getSpotAgg({
    @Query('page') required int page,
    @Query('size') required int size,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('isFollow') bool? isFollow,
    @Query('baseCoins') String? baseCoins,
    @Extras() Map<String, dynamic>? extras,
  });

  @POST('/api/instruments/spotAgg')
  Future<TickersDataEntity?> postSpotAgg(
    @Body() Map<String, String?> body, {
    @Query('page') required int page,
    @Query('size') required int size,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('isFollow') bool? isFollow,
    @Query('baseCoins') String? baseCoins,
    @Query('tag') String? tag,
    @Extras() Map<String, dynamic>? extras,
  });

  @POST('/api/instruments/categories')
  Future<List<CategoryGridEntity>?> getContractCategories({
    @Query('productType') String? productType,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String sortType = 'descend',
    @Query('sort') String? sort,
  });

  @GET('/api/instruments/categories/all')
  Future<List<CategoryInfoItemEntity>?> getAllCategories();

  @Extra({'dataKey': 'original'})
  @GET('/api/liquidation/allExchange/intervals')
  Future<LiqAllExchangeFullEntity?> getLiqAllExchangeIntervals(
      {@Query('baseCoin') String? baseCoin});

  //?interval=1h
  @GET('/api/liquidation/topCoin')
  Future<List<LiqAllExchangeEntity>?> getLiqTopCoin(
      {@Query('interval') String? interval});

  @Extra({'dataKey': 'original'})
  @GET('/api/liquidation/statistic')
  Future getLiqStatistic(@Query('baseCoin') String baseCoin,
      {@Query('interval') String? interval});

  @GET('/api/liquidation/allExchange')
  Future<List<LiqAllExchangeEntity>?> getLiqAllExchange(
      {@Query('baseCoin') String? baseCoin,
      @Query('interval') String? interval});

  @GET('/api/liquidation/orders')
  Future<List<LiqOrderEntity>?> getLiqOrders(
      {@Query('baseCoin') String? baseCoin,
      @Query('exchangeName') String? exchangeName,
      @Query('side') String? side,
      @Query('amount') int? amount});

  @Extra({'dataKey': 'original'})
  @GET('/api/kline/list')
  Future<KlineEntity?> getKlineList({
    @Query('exchange') String? exchange,
    @Query('symbol') String? symbol,
    @Query('interval') String? interval,
    @Query('side') String? side,
    @Query('ts') int? ts,
    @Query('size') int? size,
    @Query('exchangeType') String? exchangeType,
  });

  @Extra({'dataKey': 'original'})
  @GET('/api/kline/listByCoin')
  Future<KlineEntity?> getKlineListByCoin({
    @Query('baseCoin') String? baseCoin,
    @Query('interval') String? interval,
    @Query('side') String? side,
    @Query('ts') int? ts,
    @Query('size') int? size,
    @Query('exchangeType') String? exchangeType,
  });

  //api/fund/getFundHisList?baseCoin=BTC&exchangeName=Binance&interval=15m&endTime=1713514573070&size=100&productType=SWAP
  @GET('/api/fund/getFundHisList')
  Future<List<FundHisListEntity>?> getFundHisList({
    @Query('baseCoin') String? baseCoin,
    @Query('exchangeName') String? exchangeName,
    @Query('interval') String? interval,
    @Query('endTime') int? endTime,
    @Query('size') int? size,
    @Query('productType') String? productType,
  });

  @Extra({'dataKey': 'list'})
  @GET('/api/news/getNewsList')
  Future<List<NewsEntity>?> getNewsList({
    /// 1:快讯 2:新闻
    @Query('lang') required String lang,
    @Query('type') int? type,
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('isPopular') bool? isPopular,
  });

  @GET('/api/news/getNewsDetail')
  Future<NewsEntity?> getNewsDetail({@Query('id') required String id});

  @Extra({'dataKey': 'list'})
  @GET('/api/push/getUserPushRecords')
  Future<List<PushRecordEntity>?> getUserPushRecords({
    @Query('type') required NoticeRecordType? type,
    @Query('language') required String? language,
    @Query('page') int page = 1,
    @Query('size') int size = 50,
  });

  @GET('/api/push/getUserPushRecords')
  Future<List<PushRecordHugeWaveEntity>?> getUserHugeWavePushRecords({
    @Query('type') required NoticeRecordType? type,
    @Query('language') required String? language,
    @Query('page') int page = 1,
    @Query('size') int size = 50,
  });

  @GET('/api/userSignal/queryConfig')
  Future<List<WarningTypesEntity>?> getAlertUserSignalConfig();

  @GET('/api/userSignal/queryList')
  Future<List<UserAlertSignalConfigEntity>?> getAlertUserSignalList();

  @POST('/api/UserSub/getNoticeConfig')
  Future<List<AlertTypeEntity>?> getAlertConfig();

  @POST('/api/UserSub/getUserNotice')
  Future<List<AlertUserNoticeEntity>?> getUserAlertConfigs();

  @POST('/api/UserSub/saveOrUpdateUserNoticeSub')
  @MultiPart()
  Future saveOrUpdateUserAlertConfigs({
    @Part(name: 'id') String? id,
    @Part(name: 'baseCoin') String? baseCoin,
    @Part(name: 'symbol') String? symbol,
    @Part(name: 'userId') String? userId,
    @Part(name: 'type') NoticeRecordType? type,
    @Part(name: 'subType') String? subType,
    @Part(name: 'noticeValue') double? noticeValue,
    @Part(name: 'noticeType') String? noticeType,
    @Part(name: 'noticeTypes') String? noticeTypes,
    @Part(name: 'noticeTime') int? noticeTime,
    @Part(name: 'ts') int? ts,
    @Part(name: 'interval') String? interval,
    @Part(name: 'exchange') String? exchange,
    @Part(name: 'noticeValues') String? noticeValues,
    @Part(name: 'on') bool? on,
  });

  @POST('/api/UserSub/deleteUserNoticeSub')
  @MultiPart()
  Future<void> deleteUserAlertConfigs({
    @Part(name: 'id') String? id,
  });

  @POST('/api/userSignal/delete')
  @MultiPart()
  Future<void> deleteUserSignalConfig({
    @Part(name: 'id') String? id,
  });

  @POST('/api/userSignal/saveOrUpdate')
  @MultiPart()
  Future<void> saveOrUpdateUserSignalConfig({
    @Part(name: 'exName') String? exName,
    @Part(name: 'symbol') String? symbol,
    @Part(name: 'interval') String? interval,
    @Part(name: 'type') String? type,
    @Part(name: 'warningType') String? warningType,
    @Part(name: 'warningParam') String? warningParam,
  });
}
