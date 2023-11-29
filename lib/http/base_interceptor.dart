import 'dart:io';

import 'package:ank_app/route/app_nav.dart';
import 'package:ank_app/util/store.dart';
import 'package:dio/dio.dart';

import '../generated/l10n.dart';
import '../util/app_util.dart';

class BaseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (StoreLogic.isLogin) {
      options.headers['token'] = StoreLogic.to.loginUserInfo?.token;
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final code = response.data?['code'];
    if ('$code' != '1') {
      if (!_handleCode('$code')) {
        AppUtil.showToast((response.data?['msg'] ?? '').toString());
      }
      handler.reject(
        DioException(
            requestOptions: response.requestOptions,
            message: response.data?['msg'].toString()),
      );
      return;
    }
    if (response.requestOptions.path
        .contains('/api/longshort/longShortRatio')) {
      handler.next(response);
      return;
    }
    final data = response.data?['data'];
    response.data = data;
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String? errorMessage;
    final statusCode = err.response?.statusCode ?? 0;

    switch (statusCode) {
      case HttpStatus.badRequest:
        errorMessage = 'Bad Request';
      case HttpStatus.unauthorized:
        errorMessage = 'Unauthorized';
      case HttpStatus.forbidden:
        errorMessage = 'Forbidden';
      case HttpStatus.notFound:
        errorMessage = 'Not Found';
      case HttpStatus.internalServerError:
        errorMessage = 'Internal Server Error';
      case HttpStatus.badGateway:
        errorMessage = S.current.theServerIsBusyPleaseTryAgainLater;
      case HttpStatus.serviceUnavailable:
        errorMessage = 'Service Unavailable';
      default:
        switch (err.type) {
          case DioExceptionType.connectionTimeout:
            errorMessage = 'Connection Timeout';
          case DioExceptionType.sendTimeout:
            errorMessage = 'Send Timeout';
          case DioExceptionType.receiveTimeout:
            errorMessage = 'Receive Timeout';
          case DioExceptionType.badCertificate:
            errorMessage = 'Bad Certificate';
          case DioExceptionType.badResponse:
            errorMessage = 'Bad Response';
          case DioExceptionType.cancel:
            errorMessage = 'Cancelled';
          case DioExceptionType.connectionError:
            errorMessage = 'Connection Error';
          case DioExceptionType.unknown:
            errorMessage = 'Something went wrong';
        }
    }

    if (err.response != null) {
      if (err.response?.data is Map) {
        errorMessage = '${err.response?.data?['msg']}';
      }
    }
    AppUtil.showToast(errorMessage);
    handler.next(err);
  }

  bool _handleCode(String code) {
    switch (code) {
      case '101':
        AppUtil.showToast('test error');
        return true;
      case '400':
        StoreLogic.clearUserInfo();
        AppNav.toLogin();
        return true;
      default:
        return false;
    }
  }
}
