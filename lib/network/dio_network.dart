
import 'package:dio/dio.dart';

final dio = Dio(); // 初始化默认的配置

void configureDio() {

  // 通过BaseOptions设置默认配置
  dio.options.baseUrl = 'https://api.pub.dev';
  dio.options.connectTimeout = Duration(seconds: 5);
  dio.options.receiveTimeout = Duration(seconds: 3);


  //添加拦截器
  //自定义拦截器,请求、返回、异常三种拦截器
  // dio.interceptors.add(RequestInterceptor());
  // dio.interceptors.add(ErrorInterceptor());
  // dio.interceptors.add(ResponceInterceptor());
  //日志记录
  dio.interceptors.add(LogInterceptor(responseBody: true));


  // 设置代理
  // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
  //   client.badCertificateCallback = (X509Certificate cert, String host, int port) =>     true;
  //   // config the http client
  //   client.findProxy = (uri) {
  //     //proxy all request to localhost:8888
  //     return "PROXY $proxy";
  //   };
  //   // you can also create a new HttpClient to dio
  //   // return new HttpClient();
  // };

  // 通过BaseOptions构造函数设置
  final options = BaseOptions(
    baseUrl: 'https://api.pub.dev',
    connectTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 3),
  );
  final anotherDio = Dio(options);

}