import 'package:ank_app/entity/body/test_body.dart';
import 'package:ank_app/entity/test_entity.dart';
import 'package:ank_app/http/base_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'apis.g.dart';

@RestApi()
abstract class Apis {
  Apis._();
  static final Dio dio = Dio()..interceptors.addAll([BaseInterceptor()]);

  factory Apis() => _instance;

  static final Apis _instance = _Apis(dio);

  @POST('/api/test1')
  Future<TestEntity?> testApi(@Body() TestBody body);
}
