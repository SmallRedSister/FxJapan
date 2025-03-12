import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter_test_one/bean/eng_entity.dart';
import 'package:flutter_test_one/network/api_url.dart';
import 'package:flutter_test_one/util/toast_util.dart';

class HttpService {
  // 通用请求方法
  Future<dynamic> request(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
    bool isJson = true,
  }) async {
    try {
      final request = await HttpRequest.request(
        url,
        method: method,
        sendData: body != null ? (isJson ? jsonEncode(body) : body) : null,
        requestHeaders: headers,
      );

      if (request.status == 200 || request.status == 201) {
        return isJson
            ? jsonDecode(request.responseText!)
            : request.responseText;
      } else {
        throw Exception('HTTP Error: ${request.status} ${request.statusText}');
      }
    } catch (e) {
      throw Exception('Request Failed: $e');
    }
  }

  // GET 请求封装
  Future<dynamic> get(String url, {Map<String, String>? headers}) {
    return request(url, method: 'GET', headers: headers);
  }

  // POST 请求封装
  Future<dynamic> post(String url,
      {Map<String, String>? headers, dynamic body}) {
    return request(url, method: 'POST', headers: headers, body: body);
  }

  // PUT 请求封装
  Future<dynamic> put(String url,
      {Map<String, String>? headers, dynamic body}) {
    return request(url, method: 'PUT', headers: headers, body: body);
  }

  // DELETE 请求封装
  Future<dynamic> delete(String url, {Map<String, String>? headers}) {
    return request(url, method: 'DELETE', headers: headers);
  }

////////
//
  Future<Map<String, dynamic>> fetchDataPost(FormData pFormData) async {
    // 创建一个 Completer，用来与 Future 关联
    final completer = Completer<Map<String, dynamic>>();

    // 设置超时，如果在10秒内没有收到响应，则认为请求超时
    var timeout = Timer(Duration(seconds: 7), () {
      completer.completeError('Error: Request timed out.');
    });

    try {
      // 创建 HttpRequest
      HttpRequest request = HttpRequest();

      // 打开连接
      request.open('POST', fileText);

      // 监听 onLoadEnd
      request.onLoadEnd.listen((event) {
        if (request.status == 200) {
          // 请求成功，解析 JSON 并完成 Future
          final response = request.responseText!;
          // 将 JSON 字符串解析为 Map
          Map<String, dynamic> jsonData = json.decode(response);
          // 提取 "data" 部分
          Map<String, dynamic> extractedData = jsonData['data'];
          completer.complete(extractedData);
          print('ファイルが正常にアップロードされました!');
        } else {
          print('文件上传失败: ${request.statusText}');
          // 请求失败，抛出异常并完成 Future，
          completer.completeError(
              'Error: Request failed with status: ${request.status}');
        }
      });

      // 监听 onError
      request.onError.listen((event) {
        completer.completeError('An error occurred during the request.');
      });

      // ファイルアップロードリクエストを送信する
      request.send(pFormData);
    } catch (e) {
      completer.completeError('Error: $e');
    }

    completer.future.then((value) {
      print('Request completed with value: $value');
      timeout.cancel(); // リクエストが完了し、タイムアウト タイマーがキャンセルされます。
    }).catchError((error) {
      print('Error: $error');
      toastWarn(error!);
      timeout.cancel(); // リクエストエラー、タイムアウトタイマーをキャンセル
    });

    // 戻る Future
    return completer.future;
  }

  ///
  Future<List<EngEntity>?> postData(FormData pdata) async {
    // リクエスト結果待ちまたはタイムアウト
    final response = await fetchDataPost(pdata);

    print('Response:====> $response');
    List<EngEntity> list = [];
    if (response.isNotEmpty) {
      var engData = EngEntity.fromJson(response);
      list.add(engData);
      return list;
    } else {
      print(response);
      return null;
    }
  }

  ///
}

//get
// void fetchData() async {
//   try {
//     final response = await httpService.get('https://jsonplaceholder.typicode.com/posts');
//     print('Response: $response');
//   } catch (e) {
//     print('Error: $e');
//   }
// }

//post
// void postData() async {
//   try {
//     final response = await httpService.post(
//       'https://jsonplaceholder.typicode.com/posts',
//       headers: {'Content-Type': 'application/json'},
//       body: {
//         'title': 'foo',
//         'body': 'bar',
//         'userId': 1,
//       },
//     );
//     print('Response: $response');
//   } catch (e) {
//     print('Error: $e');
//   }
// }
