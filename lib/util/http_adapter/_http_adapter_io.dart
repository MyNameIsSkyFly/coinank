import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

NativeAdapter? _nativeAdapter;

HttpClientAdapter getNativeAdapter() {
  _nativeAdapter ??= NativeAdapter();
  return _nativeAdapter!;
}
