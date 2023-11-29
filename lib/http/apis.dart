import 'dart:io';

import 'package:ank_app/entity/body/futures_big_data_body.dart';
import 'package:ank_app/entity/body/test_body.dart';
import 'package:ank_app/entity/chart_entity.dart';
import 'package:ank_app/entity/chart_left_entity.dart';
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/entity/marker_funding_rate_entity.dart';
import 'package:ank_app/entity/oi_entity.dart';
import 'package:ank_app/entity/short_rate_entity.dart';
import 'package:ank_app/entity/test_entity.dart';
import 'package:ank_app/entity/user_info_entity.dart';
import 'package:ank_app/http/base_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../entity/futures_big_data_entity.dart';
import '../entity/head_statistics_entity.dart';
import '../entity/home_fund_rate_entity.dart';

part 'apis.g.dart';

@RestApi()
abstract class Apis {
  static final Dio dio = Dio()
    ..interceptors.addAll([
      // TalkerDioLogger(
      //     settings: const TalkerDioLoggerSettings(printRequestHeaders: true)),
      BaseInterceptor(),
    ])
    ..options.headers.addAll({'client': Platform.isAndroid ? 'android' : 'ios'})
    ..options.baseUrl = 'https://coinsoto.com';

  factory Apis() => _instance;

  static final Apis _instance = _Apis(dio);

  @POST('/api/test1')
  Future<TestEntity?> testApi(@Body() TestBody body);

  @GET('/api/Statistics/all')
  Future<HomeInfoEntity?> getHeadStatistics();

  @POST('/api/instruments/agg')
  Future<TickersDataEntity?> postFuturesBigData(@Body() FuturesBigDataBody body,
      {@Query('page') required int page,
      @Query('size') required int size,
      @Query('sortBy') required String sortBy,
      @Query('sortType') required String sortType});

  @GET('/api/instruments/agg')
  Future<TickersDataEntity?> getFuturesBigData({
    @Query('page') required int page,
    @Query('size') required int size,
    @Query('sortBy') String? sortBy,
    @Query('sortType') required String sortType,
    @Query('sort') String? sort,
  });

  @GET('/api/fundingRate/top?type=LAST&size=3')
  Future<List<HomeFundRateEntity>?> getHomeFundRateData();

  @GET('/api/baseCoin')
  Future<List<String>?> getMarketAllCurrencyData();

  @GET('/api/tickers')
  Future<List<ContractMarketEntity>?> getContractMarketData(
      {@Query('baseCoin') required String baseCoin,
      @Query('sortBy') String? sortBy,
      @Query('sortType') required String sortType});

  @GET('/api/fundingRate/current')
  Future<List<MarkerFundingRateEntity>?> getMarketFundingRateData(
      {@Query('type') required String type});

  @GET('/api/app/indicationMain')
  Future<List<ChartEntity>?> getChartData(
      {@Query('locale') required String locale});

  @GET('/api/app/indicationNavs')
  Future<List<ChartLeftEntity>?> getChartLeftData(
      {@Query('locale') required String locale});

  @POST('/api/User/login')
  @MultiPart()
  Future<UserInfoEntity?> login(@Part(name: 'userName') String userName,
      @Part(name: 'passWord') String passWord);

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
      @Part(name: 'type') String type);

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
    @Query('type') String type = '1',
  });

  //行情删除关注
  @GET('/api/userFollow/delFollow')
  Future getDelFollow({
    @Query('baseCoin') required String baseCoin,
    @Query('type') String type = '1',
  });

  //保存信息(极光注册的设备id,当前应用语言等等)
  @GET('/api/User/saveSetting')
  Future getOtherInfo({
    @Query('deviceId') required String deviceId,
    @Query('language') required String language,
    @Query('offset') required int offset,
    @Query('deviceType') required String deviceType,
    @Query('pushPlatform') required String pushPlatform,
  });

  //持仓html的json
  @GET('/api/openInterest/chart')
  Future getExchangeOIChartJson({
    @Query('baseCoin') String? baseCoin,
    @Query('interval') String? interval,
    @Query('type') String? type,
    @Query('size') int size = 100,
  });

  //合约持仓2
  @GET('/api/instruments/aggForIos')
  Future<TickersDataEntity?> getFuturesBigData2({
    @Query('page') required int page,
    @Query('size') required int size,
    @Query('sortBy') String? sortBy,
    @Query('sortType') required String sortType,
    @Query('sort') String? sort,
    @Query('openInterest') String? openInterest,
    @Query('isFollow') int? isFollow,
    @Query('type') String? type,
  });

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

  //多空持仓人数比
  @GET('/api/longshort/longShortRatio')
  Future getLongShortPersonRatio({
    @Query('baseCoin') String? baseCoin,
    @Query('exchangeName') String? exchangeName,
    @Query('interval') String? interval,
    @Query('type') String? type,
    @Query('exchangeType') String? exchangeType,
    @Query('limit') int limit = 30,
  });
}
