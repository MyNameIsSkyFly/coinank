// ignore_for_file: invalid_use_of_internal_member, avoid_dynamic_calls

import 'dart:developer';
import 'dart:io';

import 'package:ank_app/constants/app_const.dart';
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
    final startTime = DateTime.now();
    options.extra['startTime'] = startTime;
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path.startsWith('/api')) {
      final code = response.data?['code'];
      if ('$code' != '1') {
        if (!_handleCode('$code')) {
          final showToast = response.requestOptions.extra['showToast'] ?? true;
          if (showToast) {
            AppUtil.showToast('${response.data?['msg'] ?? ''}');
          }
        }
        log(response.requestOptions.sourceStackTrace.toString());
        handler.reject(
          DioException(
              requestOptions: response.requestOptions,
              stackTrace: response.requestOptions.sourceStackTrace,
              message: response.data?['msg'].toString()),
        );
        return;
      }
      if (response.requestOptions.path
          case '/api/longshort/longShortRatio' ||
              '/api/liquidation/statistic' ||
              '/api/liquidation/allExchange/intervals') {
        handler.next(response);
        return;
      }
      final data = response.data?['data'];
      response.data = data;
    } else if (response.requestOptions.path.startsWith('/indicatorapi')) {
      final code = response.data?['code'];
      if ('$code' != '200') {
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
      final data = response.data?['data'];
      response.data = data;
    }
    final startTime = response.requestOptions.extra['startTime'] as DateTime;
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime).inMilliseconds;
    log('Request URL: ${response.requestOptions.uri} (${duration}ms)',
        name: 'http request');
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
            errorMessage = S.current.error_request_out;
          case DioExceptionType.sendTimeout:
            errorMessage = S.current.error_request_out;
          case DioExceptionType.receiveTimeout:
            errorMessage = S.current.error_request_out;
          case DioExceptionType.badCertificate:
            errorMessage = 'Bad Certificate';
          case DioExceptionType.badResponse:
            errorMessage = 'Bad Response';
          case DioExceptionType.cancel:
            errorMessage = 'Cancelled';
          case DioExceptionType.connectionError:
            errorMessage = S.current.error_network;
          case DioExceptionType.unknown:
            errorMessage = 'Something went wrong';
        }
    }

    if (err.response != null) {
      if (err.response?.data is Map) {
        errorMessage = '${err.response?.data?['msg']}';
      }
    }
    final showToast = err.requestOptions.extra['showToast'] ?? true;
    if (showToast && AppConst.appVisible) AppUtil.showToast(errorMessage);
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
      case '430':
        AppUtil.showToast(S.current.error_login_no_user);
        return true;
      case '431':
        AppUtil.showToast(S.current.error_pwd);
        return true;
      case '432':
        AppUtil.showToast(S.current.error_code_timeout);
        return true;
      case '433':
        AppUtil.showToast(S.current.s_verify_code_error);
        return true;
      case '434':
        AppUtil.showToast(S.current.error_email_registered);
        return true;
      case '435':
        AppUtil.showToast(S.current.error_email_unregistered);
        return true;
      case '436':
        AppUtil.showToast(S.current.codeAlreadySent);
        return true;
      case '437':
        AppUtil.showToast(S.current.error_email_format);
        return true;
      case '438':
        AppUtil.showToast(S.current.error_code_format);
        return true;
      case '439':
        AppUtil.showToast(S.current.error_old_pwd);
        return true;
      default:
        return false;
    }
  }
}
