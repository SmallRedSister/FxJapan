import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_test_one/bean/device_list_entity.dart';
import 'package:flutter_test_one/network/api.dart';
import 'package:flutter_test_one/network/api_url.dart';
import 'package:http_parser/http_parser.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart' as files_form;
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_one/language/local.dart';
import 'package:flutter_test_one/util/toast_util.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import /* 'dart:io' if (dart.library.html)  */ 'dart:html' as html;
import 'dart:convert';

// 测试页面
class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late String _name = "";
  final box = GetStorage();
  var olderId = "";
  var mIndex = 0;
  bool one = false;
  int sex = 1;
  Color color = Colors.blue;
  RxString fileTextPath = "".obs;

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();

  String? _fileName;
  String? _filePath;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _lockParentWindow = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  files_form.FormData? formData;

  void goBack() {
    color = getRandomColor();
    Navigator.pop(context, "我是返回值"); //路由返回
  }

  @override
  void initState() {
    super.initState();
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        compressionQuality: 30,
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        dialogTitle: _dialogTitleController.text,
        initialDirectory: _initialDirectoryController.text,
        lockParentWindow: _lockParentWindow,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    // setState(() {
    _isLoading = false;
    _fileName = _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    _userAborted = _paths == null;
    //获取文件路径
    final path =
        kIsWeb ? null : _paths!.map((e) => e.path).toList()[0].toString();
    //判断是否为空，web获取不到路径，为空时显示文件名
    fileTextPath.value = path ?? '$_fileName';
    _filePath = path ?? '$_fileName';
    // });

    formData = files_form.FormData.fromMap({
      "files": await files_form.MultipartFile.fromFile(_filePath!,
          filename: _fileName),
      "strTxt": _name
    });
  }

  @override
  Widget build(BuildContext context) {
    //获取路由参数
    var args = ModalRoute.of(context)?.settings.arguments;
    //debugDumpApp();
    debugPrint("日志输出：${args.toString()}"); //日志输出

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //标题
            Text(Local.appName.tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 18, 155, 240),
                  fontSize: 21.5,
                  height: 1,
                  fontFamily: "titleFonts",
                  // fontWeight: FontWeight.w600,
                )),
            //
            SizedBox(height: 10),
            Text(Local.readResumeTitle.tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 18, 155, 240),
                  fontSize: 21.5,
                  height: 1,
                  fontFamily: "titleFonts",
                )),

            //选择文件
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 650.w,
                    height: 55.h,
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey, width: 1.0), // 设置边框
                    ),
                    child: Obx(
                      () => Text(fileTextPath.value,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15.5,
                              height: 2,
                              // decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dashed)),
                    )),

                //选择按钮
                OutlinedButton(
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all(
                        TextStyle(fontSize: 14, color: Colors.red)),
                    //设置按钮上字体与图标的颜色
                    ///设置文本不通状态时颜色
                    foregroundColor: WidgetStateProperty.resolveWith(
                      (states) {
                        if (states.contains(WidgetState.focused) &&
                            !states.contains(WidgetState.pressed)) {
                          //获取焦点时的颜色
                          return Colors.blue;
                        } else if (states.contains(WidgetState.pressed)) {
                          //按下时的颜色
                          return Colors.deepPurple;
                        }
                        //默认状态使用灰色
                        return Colors.grey;
                      },
                    ),
                    //按钮背景颜色
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      //设置按下时的背景颜色
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.yellow[300];
                      }
                      //默认不使用背景颜色
                      return null;
                    }),

                    ///设置水波纹颜色
                    overlayColor: WidgetStateProperty.all(Colors.grey[400]),

                    ///按钮大小
                    minimumSize: WidgetStateProperty.all(Size(50.w, 65.h)),
                    //设置阴影  不适用于这里的TextButton
                    elevation: WidgetStateProperty.all(0),
                    //设置按钮内边距
                    padding: WidgetStateProperty.all(EdgeInsets.all(10)),

                    ///设置按钮圆角
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0))),

                    ///设置按钮边框颜色和宽度
                    side: WidgetStateProperty.all(
                        BorderSide(color: Colors.grey, width: 1)),
                  ),
                  onPressed: () {
                    _pickFiles(); //获取文件
                  },
                  child: Text(Local.engFileSelect.tr), //'選択'
                ),
              ],
            ),
//
            Text(Local.engTestimonialTitle.tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 18, 155, 240),
                  fontSize: 21.5,
                  height: 1,
                  fontFamily: "titleFonts",
                  // fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 10),
            //大输入框
            Container(
              alignment: Alignment.center,
              width: 999.w,
              // margin: EdgeInsets.symmetric(horizontal: 200, vertical: 5),
              child: TextField(
                autofocus: false,
                maxLength: 300, // 输入框的最大行数
                minLines: 8, //最小行数
                maxLines: 15,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  hintText: "",
                  hintMaxLines: 10,

                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 15.5,
                      height: 1,
                      fontFamily: "Courier",
                      // background: Colors.deepOrange,
                      // decoration:TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dashed),

                  ///设置边框
                  border: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.red,

                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),

                  ///设置输入框可编辑时的边框样式
                  enabledBorder: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.blue,

                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.red,

                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),

                  ///用来配置输入框获取焦点时的颜色
                  focusedBorder: OutlineInputBorder(
                    ///设置边框四个角的弧度
                    borderRadius: BorderRadius.all(Radius.circular(7)),

                    ///用来配置边框的样式
                    borderSide: BorderSide(
                      ///设置边框的颜色
                      color: Colors.green,

                      ///设置边框的粗细
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  _name = value;
                },
                //赋值
                controller: TextEditingController.fromValue(TextEditingValue(
                    text: _name,
                    selection: TextSelection.fromPosition(TextPosition(
                        affinity: TextAffinity.downstream,
                        offset: _name.length)))), //设置controller
              ),
            ),

            //loaing
            SizedBox(height: 10),
            _LoadingButton(),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _userAborted = false;
    });
  }

  ElevatedButton _LoadingButton() {
    return ElevatedButton(
      style: ButtonStyle(
        textStyle:
            WidgetStateProperty.all(TextStyle(fontSize: 18, color: Colors.red)),
        //设置按钮上字体与图标的颜色
        ///设置文本不通状态时颜色
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.focused) &&
                !states.contains(WidgetState.pressed)) {
              //获取焦点时的颜色
              return Colors.white;
            } else if (states.contains(WidgetState.pressed)) {
              //按下时的颜色
              return Colors.black;
            }
            //默认状态使用灰色
            return Colors.blue;
          },
        ),
        //按钮背景颜色
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(WidgetState.pressed)) {
            return Colors.yellow[300];
          }
          //默认不使用背景颜色
          return Colors.blue;
        }),

        ///设置水波纹颜色
        overlayColor: WidgetStateProperty.all(Colors.yellow),

        ///按钮大小
        minimumSize: WidgetStateProperty.all(Size(250, 50)),
        //设置阴影  不适用于这里的TextButton
        elevation: WidgetStateProperty.all(0),
        //设置按钮内边距
        padding: WidgetStateProperty.all(EdgeInsets.all(10)),

        ///设置按钮圆角
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),

        ///设置按钮边框颜色和宽度
        side:
            WidgetStateProperty.all(BorderSide(color: Colors.green, width: 1)),
      ),
      child: Text(Local.engInfologin.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17.5,
            height: 2,
            fontFamily: "titleFonts",
          )),
      onPressed: () {
        // toastWarn(formData.toString());
        if (kIsWeb) {
          uploadFile();
          // Web环境下的代码
        } else {
          // 非Web环境下的代码
          /* postFileAndText(formData, _name).then((value) {
            print("_postFileAndText=$value");
          }); */
          print("_engGetFile()");
          uploadFileAll(null, formData!);
        }
      },
    );
  }

  //test获取电脑txt文件
  _engGetFile() async {
    return files_form.FormData.fromMap({
      "file": await files_form.MultipartFile.fromFile(_filePath!,
          filename: _fileName),
      "strName": _name
    });
  }
}

final rng = Random();

const randomColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.indigo,
  Colors.deepPurple,
  Colors.white10,
];

Color getRandomColor() {
  return randomColors[rng.nextInt(randomColors.length)];
}

//计时器
Stream<int> counter() {
  return Stream.periodic(Duration(seconds: 1), (i) {
    return i;
  });
}

///上传文件
dynamic uploadFileAll(dynamic pickedFile, files_form.FormData formData) async {
  print('上传中...');
  try {
    //获取路径
    // String path = File(pickedFile.path).path;
    // //获取名称
    // String name = path.substring(path.lastIndexOf("/") + 1, path.length);
    // //获取后缀
    // String suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    // //装入FormData对象类
    // files_form.FormData formData = files_form.FormData.fromMap({
    //   'image_type': suffix,
    //   'files': await files_form.MultipartFile.fromFile(path,
    //       filename: name, contentType: MediaType.parse("image/$suffix")),
    // });

    print("imge==>$formData");
    //上传服务
    final res = await Dio().post(fileText,
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            responseType: ResponseType.plain));
    if (res.statusCode == 200) {
      print('文件上传成功！');
    } else {
      print('文件上传失败！');
    }
  } catch (e) {
    print(e);
  }
}

//flutter web上传文件功能, web平台比较特殊，需要分开处理
void uploadFile() {
  // 创建一个HTML文件上传输入框
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'xlsx/*'; // 设置允许的文件类型，例如只允许上传xlsx
  uploadInput.multiple = false; // 设置是否允许选择多个文件

  // 当文件选择发生变化时的回调
  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) return;

    final file = files[0]; // 获取选中的第一个文件

    // 创建一个表单数据对象
    final formData = html.FormData();
    formData.appendBlob('files', file);
    formData.append("strTxt", "123456");

    // 创建一个HTTP请求，上传文件
    final xhr = html.HttpRequest();
    xhr.open('POST', fileText); // 替换为你的服务器URL

    xhr.onLoadEnd.listen((e) {
      if (xhr.status == 200) {
        // 上传成功
        print('文件上传成功!');
      } else {
        // 上传失败
        print('文件上传失败: ${xhr.statusText}');
      }
    });

    // 发送请求
    xhr.send(formData);

    // xhr.open('POST', fileText);

    // 處理回應
    // xhr.onLoadEnd.listen((e) {
    //   if (xhr.status == 200) {
    //     // アップロード成功
    //     print('ファイルが正常にアップロードされました!');
    //     print("返回结果=>${xhr.responseText}");
    //     var jsonSt = xhr.responseText.toString();
    //     // 将 JSON 字符串解析为 Map
    //     Map<String, dynamic> jsonData = json.decode(jsonSt);
    //     // 提取 "data" 部分 1
    //     Map<String, dynamic> extractedData = jsonData['data'];

    //     // 将提取出的数据重新编码为 JSON 字符串
    //     // String extractedJsonString = json.encode(extractedData);

    //     engList.clear();
    //     engData = EngEntity.fromJson(extractedData);
    //     engList.add(engData);
    //     print(
    //         "EngEntity=>${engData.engName}//${engData.engConcurSituations}");

    //     // 提取 Map 的值到一个 List 中 2
    //     // List<dynamic> dataList = extractedData.values.toList();
    //     // for (var EngEntity in dataList) {
    //     //   print(
    //     //       'Name: ${EngEntity['engName']}, Age: ${EngEntity['engUserAge']}');
    //     //   ;
    //     // }
    //   } else {
    //     // アップロードに失敗しました
    //     print('ファイルのアップロードに失敗しました: ${xhr.statusText}');
    //   }
    // BotToast.closeAllLoading();
    // });
  });

  // 模拟点击上传按钮，打开文件选择框
  uploadInput.click();
}
