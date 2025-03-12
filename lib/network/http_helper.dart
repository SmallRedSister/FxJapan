import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpHelper {
  static HttpHelper get instance => _getInstance();

  static HttpHelper? _httpHelper;

  static HttpHelper _getInstance() {
    _httpHelper ??= HttpHelper();
    return _httpHelper!;
  }

  late Dio _dio;

  HttpHelper() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 5);
    PrettyDioLogger log = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90);
    _dio.interceptors.add(log);
  }

  Future post(String url, {Object? data, Options? options}) async {
    Response response;
    try {
      if (data != null && options != null) {
        response = await _dio.post(url, data: data, options: options);
      } else if (data != null) {
        response = await _dio.post(url, data: data);
      } else {
        response = await _dio.post(url);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.connectionError) {
        return (500, '请求超时，请检查网络');
      }
      return (e.response!.statusCode, e.response!.data);
    }
    // LoggerManager().write("Http manager", 'received ${response.data}');
    return (response.statusCode, response.data);
  }
}
