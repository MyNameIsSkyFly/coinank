import 'dart:io';

import 'package:ank_app/entity/body/futures_big_data_body.dart';
import 'package:ank_app/entity/body/test_body.dart';
import 'package:ank_app/entity/contract_market_entity.dart';
import 'package:ank_app/entity/test_entity.dart';
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
  Future<TickersDataEntity?> getFuturesBigData(
      {@Query('page') required int page,
      @Query('size') required int size,
      @Query('sortBy') required String sortBy,
      @Query('sortType') required String sortType});

  @GET('/api/fundingRate/top?type=LAST&size=3')
  Future<List<HomeFundRateEntity>?> getHomeFundRateData();

  @GET('/api/baseCoin')
  Future<List<String>?> getMarketAllCurrencyData();

  @GET('/api/tickers')
  Future<List<ContractMarketEntity>?> getContractMarketData(
      {@Query('baseCoin') required String baseCoin,
      @Query('sortBy') String? sortBy,
      @Query('sortType') required String sortType});
}
