import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_one/bean/eng_entity.dart';
import 'package:flutter_test_one/bean/verify_entity.dart';
import 'package:flutter_test_one/core/admin.dart';
import 'package:flutter_test_one/language/local.dart';
import 'package:flutter_test_one/network/api.dart';
import 'package:flutter_test_one/network/api_url.dart';
import 'package:flutter_test_one/query_page.dart';
import 'package:flutter_test_one/tests.dart';
import 'package:flutter_test_one/util/toast_util.dart';
import 'package:flutter_test_one/verify_page.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import '../main.dart';
import 'bean/device_list_entity.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;
import 'dart:convert';

import 'network/http_service.dart';
import 'package:flutter_test_one/util/line_util.dart';

//mian page
class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  //紹介文
  String _engTestimonialTitleContent = "";
  final box = GetStorage();
  var olderId = "";
  var mIndex = 0;
  bool one = false;
  int sex = 1; //男性と女性を区別する
  RxString fileTextPath = "".obs;

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();

  String? _fileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _lockParentWindow = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  // HTMLファイルアップロード入力ボックスを作成する
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  // ファイルをアップロードするための HTTP リクエストを作成する
  final xhr = html.HttpRequest();
  // フォームデータオブジェクトを作成する
  final formData = html.FormData();

  final httpService = HttpService();
  // 複数の TextEditingController を定義する
  final TextEditingController engNameTC = TextEditingController();
  final TextEditingController engCountryTC = TextEditingController();
  final TextEditingController engUserAgeTC = TextEditingController();
  final TextEditingController engGenderTC = TextEditingController();
  final TextEditingController engEmpiricYearTC = TextEditingController();
  final TextEditingController engEmpiricMonthTC = TextEditingController();
  final TextEditingController engSkillTC = TextEditingController();
  final TextEditingController engJapaneseTC = TextEditingController();
  final TextEditingController engSalaryPriceTC = TextEditingController();
  final TextEditingController engNearestStationTC = TextEditingController();
  final TextEditingController engOperationMonthTC = TextEditingController();
  final TextEditingController engOperationDateTC = TextEditingController();
  final TextEditingController engInterviewTC = TextEditingController();
  final TextEditingController engConcurSituationsTC = TextEditingController();
  final TextEditingController engRemarkTC = TextEditingController();

  bool isWidthGreater = false;

  @override
  initState() {
    super.initState();
    engList.add(EngEntity(
        "鈴木 大郎",
        "日本",
        29,
        1,
        4,
        11,
        "C#、ASP.NET、VB.NET、PLSQL、VBscript、HTML、JavaScript、IFS、VBA、PowerShell、L\ninuxコマンド \n基本設計、内部設計、製造、単体、結合、帳票作成、データ移行、インフラ監視経験。\n",
        "N1相当(業務会話問題ない、独自で日本人現場作業問題ない、独自日本人との打合せは問題ない) ",
        35,
        "武蔵小金井（現場出社問題ない）",
        12,
        1,
        true,
        "事前調整要",
        "提案のみ",
        "・上流工程のある開発案件希望 \n・真面目、責任感が強い、仕事にやる気満々。 \n・CCNA資格、Oracle12c MASTER Bronze資格取得済み \n・面談時間は事前調整要。 \n"));
    // engList.add(
    //     EngEntity("", "", 0, 0, 0, 0, "", "", 0, "", 1, 1, true, "", "", ""));
    _uploadFile();
  }

//ファイルパスを取得する
  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        // compressionQuality: 30,
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
    //setState(() {

    _fileName = _paths != null ? _paths!.map((e) => e.name).toString() : '...';

    fileTextPath.value = _fileName.toString();
    //获取文件路径
    final path =
        kIsWeb ? null : _paths!.map((e) => e.path).toList()[0].toString();
    //判断是否为空，web获取不到路径，为空时显示文件名
    fileTextPath.value = path ?? '$_fileName';
    //});
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
      _directoryPath = null;
      _fileName = null;
      _paths = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを取得する
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 幅と高さを比較してください
    isWidthGreater = screenWidth > screenHeight;
    return Scaffold(
      // 使用ScreenUtil().setSp()设置背景颜色
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Stack(
          children: [
            /** */
            // 显示进度条
            Scrollbar(
                interactive: true, //滑动条为true 可拖动
                child: SingleChildScrollView(
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      SizedBox(height: 18),
                      Text(Local.readResumeTitle.tr,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 18, 155, 240),
                            fontSize: 19.5,
                            height: 1,
                            fontFamily: "titleFonts",
                          )),
                      SizedBox(height: 10),
                      //选择文件
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 650.w,
                              height: 95.h,
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey, width: 1.0), // 设置边框
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
                                        decorationStyle:
                                            TextDecorationStyle.dashed)),
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
                                  } else if (states
                                      .contains(WidgetState.pressed)) {
                                    //按下时的颜色
                                    return Colors.deepPurple;
                                  }
                                  //默认状态使用灰色
                                  return Colors.grey;
                                },
                              ),
                              //按钮背景颜色
                              backgroundColor:
                                  WidgetStateProperty.resolveWith((states) {
                                //设置按下时的背景颜色
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.yellow[300];
                                }
                                //默认不使用背景颜色
                                return null;
                              }),

                              ///设置水波纹颜色
                              overlayColor:
                                  WidgetStateProperty.all(Colors.blue[300]),

                              ///按钮大小
                              minimumSize:
                                  WidgetStateProperty.all(Size(90.w, 70.h)),
                              //设置阴影  不适用于这里的TextButton
                              elevation: WidgetStateProperty.all(0),
                              //设置按钮内边距
                              padding:
                                  WidgetStateProperty.all(EdgeInsets.all(13)),

                              ///设置按钮圆角
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),

                              ///设置按钮边框颜色和宽度
                              side: WidgetStateProperty.all(
                                  BorderSide(color: Colors.grey, width: 1)),
                            ),
                            onPressed: () {
                              if (kIsWeb) {
                                // 模拟点击上传按钮，打开文件选择框
                                uploadInput.click();
                              } else {
                                _pickFiles(); //获取文件
                              }
                            },
                            child: Text(Local.engFileSelect.tr,
                                style: const TextStyle(
                                  color: Colors.black,
                                )), //'選択'
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      //
                      Text(Local.engTestimonialTitle.tr,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 18, 155, 240),
                            fontSize: 19.5,
                            height: 1,
                            fontFamily: "titleFonts",
                          )),
                      SizedBox(height: 10),
                      //大输入框
                      Container(
                        alignment: Alignment.center,
                        width: 900.w,
                        // margin: EdgeInsets.symmetric(horizontal: 200, vertical: 5),
                        child: TextField(
                          autofocus: false,
                          maxLength: 300, // 输入框的最大行数,限制输入字符数
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),

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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),

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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),

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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7)),

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
                            _engTestimonialTitleContent = value;
                          },
                          //赋值
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: _engTestimonialTitleContent,
                                  selection: TextSelection.fromPosition(
                                      TextPosition(
                                          affinity: TextAffinity.downstream,
                                          offset: _engTestimonialTitleContent
                                              .length)))), //设置controller
                        ),
                      ),

                      //loaing
                      SizedBox(height: 10),
                      _loadingButton(),
                      SizedBox(height: 10),

                      //情報表示
                      Obx(() => _list()),

                      SizedBox(height: 150),
                    ]))),

            //タイトル
            setTitle(Local.appName.tr),
            Container(
              padding: EdgeInsets.symmetric(vertical: 66.h),
              alignment: Alignment.bottomCenter,
              child: _loginButton(), //登录
            ),
          ],
        ),
      ),
    );
  }

  // 読込
  ElevatedButton _loadingButton() {
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
      child: Text(Local.engInfoLoading.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17.5,
            height: 2,
            fontFamily: "titleFonts",
          )),
      onPressed: () {
        if (fileTextPath.value == "") {
          toastWarn("履歴書ファイルを選択してください");
          return;
        }
        if (_engTestimonialTitleContent.isEmpty) {
          toastWarn("紹介文を入力してください");
          return;
        }
        print('Input Text: $_engTestimonialTitleContent'); // 包含换行符的完整文本
        formData.append("strTxt", _engTestimonialTitleContent);
        BotToast.showLoading();
        //ファイルを送信して結果が返される
        httpService.postData(formData).then((value) {
          print(value);
          if (value == null) {
            BotToast.closeAllLoading();
          } else {
            engList.clear();
            engList.addAll(value);
          }
        });
      },
    );
  }

  // 登録確認へ
  ElevatedButton _loginButton() {
    return ElevatedButton(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: 20, color: Colors.black)),
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
            return Colors.black;
          },
        ),
        //按钮背景颜色
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          //设置按下时的背景颜色
          if (states.contains(WidgetState.pressed)) {
            return Colors.yellow[300];
          }
          //默认不使用背景颜色
          return Colors.blue[300];
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
      child: Text(Local.engInfologin.tr),
      onPressed: () {
        print('engRemarkTC.Text=>${engRemarkTC.text}');
        //
        Get.to(() => Verify(),
            arguments: VerifyEntity(
                engNameTC.text,
                engCountryTC.text,
                engUserAgeTC.text,
                sex,
                engEmpiricYearTC.text,
                engEmpiricMonthTC.text,
                engSkillTC.text,
                engJapaneseTC.text,
                engSalaryPriceTC.text,
                engNearestStationTC.text,
                engOperationMonthTC.text,
                engOperationDateTC.text,
                _selectedValues,
                engInterviewTC.text,
                engConcurSituationsTC.text,
                engRemarkTC.text)); //跳转AdminPage
      },
    );
  }

  //ユーザーが情報を変更した後にデータを更新する
  _setUpData() {
    engList.clear();
    engList.add(EngEntity(
        engNameTC.text,
        engCountryTC.text,
        int.parse(engUserAgeTC.text),
        sex,
        int.parse(engEmpiricYearTC.text),
        int.parse(engEmpiricMonthTC.text),
        engSkillTC.text,
        engJapaneseTC.text,
        int.parse(engSalaryPriceTC.text),
        engNearestStationTC.text,
        int.parse(engOperationMonthTC.text),
        int.parse(engOperationDateTC.text),
        _selectedValues,
        engInterviewTC.text,
        engConcurSituationsTC.text,
        engRemarkTC.text));
  }

  RxList<EngEntity> engList = RxList();
  bool _selectedValues = false; //即日

  _list() {
    return ListView.builder(
      shrinkWrap: true, //使ListView根据其内容的高度来自动调整高度
      //禁用了ListView的滚动功能，使其完全依赖于SingleChildScrollView进行滚动。
      physics: NeverScrollableScrollPhysics(),
      primary: true,
      //itemBuilder是列表项的构建器
      itemBuilder: (context, index) {
        var item = engList[index];

        // コントローラーを初期化して値を割り当てる
        engNameTC.text = item.engName;
        engCountryTC.text = item.engCountry;
        engUserAgeTC.text = item.engUserAge.toString();
        engEmpiricYearTC.text = item.engEmpiricYear.toString();
        engEmpiricMonthTC.text = item.engEmpiricMonth.toString();
        engSkillTC.text = item.engSkill;
        engJapaneseTC.text = item.engJapanese;
        engSalaryPriceTC.text = item.engSalaryPrice.toString();
        engNearestStationTC.text = item.engNearestStation;
        engOperationMonthTC.text = item.engOperationMonth.toString();
        engOperationDateTC.text = item.engOperationDate.toString();
        engInterviewTC.text = item.engInterview;
        engConcurSituationsTC.text = item.engConcurSituations;
        engRemarkTC.text = item.engRemark;

        sex = item.engGender;
        _selectedValues = item.engToday;
        BotToast.closeAllLoading();

        return isWidthGreater ? _listItemWeb(index) : _listItemPhone(index);
      },
      //列表项的数量，如果为null，则为无限列表。
      itemCount: engList.length, //doorList.length,1
    );
  }

  _listItemWeb(int index) {
    return Card(
      color: Colors.white,
      elevation: 2.0, //可以设置卡片的阴影大小：
      margin: EdgeInsets.symmetric(horizontal: 90.w, vertical: 13.h),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(Local.engSkillTitle.tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 18, 155, 240),
                  fontSize: 21.5,
                  height: 1,
                  fontFamily: "titleFonts",
                )),
          ),
          //线条
          engLine(),
          //
          Row(
            children: <Widget>[
              //氏名
              textView(Local.engName.tr, Alignment.centerLeft),
              SizedBox(
                width: 190.w,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 10,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.text, //用于设置该输入框默认的键盘输入类型
                      controller: engNameTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),

              //国籍
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                  children: [
                    textView(Local.engCountry.tr, Alignment.center),
                    SizedBox(
                      width: 190.w,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextField(
                            maxLength: 10,
                            maxLengthEnforcement: MaxLengthEnforcement
                                .enforced, // enforced强制限制字符数
                            maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                            keyboardType:
                                TextInputType.text, //用于设置该输入框默认的键盘输入类型
                            controller: engCountryTC,
                            decoration: InputDecoration(
                              border: textFieldBorder(),
                              hintStyle: textFieldHintStyle(),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          //线条----------------------------------------------------------------
          engLine(),
          //
          Row(
            children: <Widget>[
              //年齢
              textView(Local.engUserAge.tr, Alignment.centerLeft),
              Container(
                width: 50,
                constraints: BoxConstraints(minWidth: 50),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: 1, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engUserAgeTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engAgeYear.tr),
              SizedBox(width: 46.w),

              //性別
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: [
                    textView(Local.engGender.tr, Alignment.center),
                    // 简易选择项
                    Row(
                      children: <Widget>[
                        Text("男"),
                        Radio(
                          // 按钮的值
                          value: 1,
                          // 改变事件
                          onChanged: (value) {
                            // setState(() {
                            sex = value!;
                            _setUpData();
                            // });
                          },
                          // 按钮组的值
                          groupValue: sex,
                        ),
                        SizedBox(
                          width: 45.w,
                        ),
                        Text("女"),
                        Radio(
                          value: 2,
                          onChanged: (value) {
                            // setState(() {
                            sex = value!;
                            _setUpData();
                            // });
                          },
                          groupValue: sex,
                        ),
                      ],
                    ),
                  ])),
            ],
          ),
          //线条
          engLine(),
          //経験年数
          Row(
            children: <Widget>[
              textView(Local.engEmpiric.tr, Alignment.centerLeft),
              //年
              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engEmpiricYearTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engEmpiricYear.tr),
              //月
              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engEmpiricMonthTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engEmpiricMonth.tr),
            ],
          ),
          //线条
          engLine(),
          //得意ㇲキル
          Row(
            children: <Widget>[
              textView(Local.engSkill.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 88, 1.0),
                  child: TextField(
                      maxLength: 150,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engSkillTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //日本語
          Row(
            children: <Widget>[
              textView(Local.engJapanese.tr, Alignment.centerLeft),
              SizedBox(
                width: 600.w,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 30,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engJapaneseTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //希望単価
          Row(
            children: <Widget>[
              textView(Local.engSalaryPrice.tr, Alignment.centerLeft),
              SizedBox(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 3,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engSalaryPriceTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engMoney.tr),
              SizedBox(width: 115.w),

              //最寄駅
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: [
                    textView(Local.engNearestStation.tr, Alignment.center),
                    SizedBox(
                      width: 190.w,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: TextField(
                            maxLength: 10,
                            maxLengthEnforcement:
                                MaxLengthEnforcement.none, // enforced强制限制字符数
                            maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                            keyboardType:
                                TextInputType.text, //用于设置该输入框默认的键盘输入类型
                            controller: engNearestStationTC,
                            decoration: InputDecoration(
                              border: textFieldBorder(),
                              hintStyle: textFieldHintStyle(),
                            )),
                      ),
                    ),
                  ])),
            ],
          ),
          //线条
          engLine(),
          //稼動可能日
          Row(
            children: <Widget>[
              //稼動可能日
              textView(Local.engOperation.tr, Alignment.centerLeft),
              //月
              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engOperationMonthTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engOperationMonth.tr),
              //日
              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engOperationDateTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engOperationDate.tr),

              //即日
              Row(
                children: [
                  //OR
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Text("OR",
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.5,
                          height: 1,
                          fontFamily: "titleFonts",
                        )),
                  ),
                  Text(Local.engToday.tr),
                  SizedBox(width: 10.w),
                  Checkbox(
                    value: _selectedValues,
                    onChanged: (value) {
                      _selectedValues = value!;
                      _setUpData();
                    },
                  ),
                ],
              ),
            ],
          ),

          //线条
          engLine(),
          //面谈
          Row(
            children: <Widget>[
              textView(Local.engInterview.tr, Alignment.centerLeft),
              SizedBox(
                width: 600.w,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 20,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engInterviewTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //並行状況
          Row(
            children: <Widget>[
              textView(Local.engConcurSituations.tr, Alignment.centerLeft),
              SizedBox(
                width: 600.w,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 20,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engConcurSituationsTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //備考
          Row(
            children: <Widget>[
              textView(Local.engRemark.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 88, 1.0),
                  child: TextField(
                      maxLength: 150,
                      autofocus: false,
                      minLines: 1, //最小行数
                      maxLines: null, // 允许多行
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: engRemarkTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //
          SizedBox(height: 15),
        ],
      ),
    );
  }

  //Phone
  _listItemPhone(int index) {
    return Card(
      color: Colors.white,
      elevation: 2.0, //可以设置卡片的阴影大小：
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 13.h),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(Local.engSkillTitle.tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 18, 155, 240),
                  fontSize: 21.5,
                  height: 1,
                  fontFamily: "titleFonts",
                )),
          ),
          //线条
          engLine(),
          //
          //氏名
          Row(
            children: [
              textView(Local.engName.tr, Alignment.centerLeft),
              SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 10,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.text, //用于设置该输入框默认的键盘输入类型
                      controller: engNameTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //国籍
          Row(
            children: [
              textView(Local.engCountry.tr, Alignment.centerLeft),
              SizedBox(
                width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 10,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.text, //用于设置该输入框默认的键盘输入类型
                      controller: engCountryTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),

          //线条----------------------------------------------------------------
          engLine(),
          //
          Row(
            children: <Widget>[
              //年齢
              textView(Local.engUserAge.tr, Alignment.centerLeft),
              Container(
                width: 50,
                constraints: BoxConstraints(minWidth: 50),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: 1, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engUserAgeTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engAgeYear.tr),
            ],
          ),
          //线条
          engLine(),
          //性別
          Row(children: [
            textView(Local.engGender.tr, Alignment.centerLeft),
            // 简易选择项
            Row(
              children: <Widget>[
                Text("男"),
                Radio(
                  // 按钮的值
                  value: 1,
                  // 改变事件
                  onChanged: (value) {
                    sex = value!;
                    _setUpData();
                  },
                  // 按钮组的值
                  groupValue: sex,
                ),
                SizedBox(width: 45),
                Text("女"),
                Radio(
                  value: 2,
                  onChanged: (value) {
                    sex = value!;
                    _setUpData();
                  },
                  groupValue: sex,
                ),
              ],
            ),
          ]),
          //线条
          engLine(),
          //経験年数
          Row(
            children: <Widget>[
              textView(Local.engEmpiric.tr, Alignment.centerLeft),
              //年
              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engEmpiricYearTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engEmpiricYear.tr),
              //月
              SizedBox(
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engEmpiricMonthTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engEmpiricMonth.tr),
            ],
          ),
          //线条
          engLine(),
          //得意ㇲキル
          Row(
            children: <Widget>[
              textView(Local.engSkill.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 13.0, 1.0),
                  child: TextField(
                      maxLength: 150,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engSkillTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //日本語
          Row(
            children: <Widget>[
              textView(Local.engJapanese.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 13.0, 1.0),
                  child: TextField(
                      maxLength: 30,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engJapaneseTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //希望単価
          Row(
            children: <Widget>[
              textView(Local.engSalaryPrice.tr, Alignment.centerLeft),
              SizedBox(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 3,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engSalaryPriceTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engMoney.tr),
            ],
          ),
          //线条
          engLine(),
          //最寄駅
          Row(children: [
            textView(Local.engNearestStation.tr, Alignment.centerLeft),
            SizedBox(
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: TextField(
                    maxLength: 10,
                    maxLengthEnforcement:
                        MaxLengthEnforcement.none, // enforced强制限制字符数
                    maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                    keyboardType: TextInputType.text, //用于设置该输入框默认的键盘输入类型
                    controller: engNearestStationTC,
                    decoration: InputDecoration(
                      border: textFieldBorder(),
                      hintStyle: textFieldHintStyle(),
                    )),
              ),
            ),
          ]),
          //线条
          engLine(),
          //稼動可能日
          Row(
            children: <Widget>[
              //稼動可能日
              textView(Local.engOperation.tr, Alignment.centerLeft),
              //月
              SizedBox(
                width: 48,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engOperationMonthTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engOperationMonth.tr),
              //日
              SizedBox(
                width: 48,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                      maxLength: 2,
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      keyboardType: TextInputType.number, //用于设置该输入框默认的键盘输入类型
                      controller: engOperationDateTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
              textYears(Local.engOperationDate.tr),
            ],
          ),
          //即日
          Row(
            children: [
              textView("", Alignment.centerLeft),
              //OR
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 15.0),
                child: Text("OR",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.5,
                      height: 1,
                      fontFamily: "titleFonts",
                    )),
              ),
              Checkbox(
                value: _selectedValues,
                onChanged: (value) {
                  _selectedValues = value!;
                  _setUpData();
                },
              ),
              SizedBox(width: 15.w),
              Text(Local.engToday.tr),
              SizedBox(width: 5.w),
            ],
          ),
          //线条
          engLine(),
          //面谈
          Row(
            children: <Widget>[
              textView(Local.engInterview.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 13.0, 1.0),
                  child: TextField(
                      maxLength: 20,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engInterviewTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //並行状況
          Row(
            children: <Widget>[
              textView(Local.engConcurSituations.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 13.0, 1.0),
                  child: TextField(
                      maxLength: 20,
                      autofocus: false,
                      minLines: 1, //最小行数
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement:
                          MaxLengthEnforcement.enforced, // enforced强制限制字符数
                      maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
                      controller: engConcurSituationsTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //備考
          Row(
            children: <Widget>[
              textView(Local.engRemark.tr, Alignment.centerLeft),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(1.0, 1.0, 13.0, 1.0),
                  child: TextField(
                      maxLength: 150,
                      autofocus: false,
                      minLines: 1, //最小行数
                      maxLines: null, // 允许多行
                      keyboardType: TextInputType.multiline, // 支持多行输入
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: engRemarkTC,
                      decoration: InputDecoration(
                        border: textFieldBorder(),
                        hintStyle: textFieldHintStyle(),
                      )),
                ),
              ),
            ],
          ),
          //线条
          engLine(),
          //
          SizedBox(height: 15),
        ],
      ),
    );
  }

//TextFieldの統一構成
  SizedBox _SizedBoxs(double widths, double heights, int maxLength,
      TextInputType keyType, String txtData, String fieldKey) {
    return SizedBox(
      width: widths.w,
      // height: heights.h,
      // margin: const EdgeInsets.fromLTRB(10, 30, 10, 10),//距离外部边距
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: TextField(
            key: ValueKey(fieldKey),
            maxLength: maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.none, // enforced强制限制字符数
            maxLines: null, //输入框的最大行数，默认为1；如果为null，则无行数限制。
            keyboardType: keyType, //用于设置该输入框默认的键盘输入类型
            // controller: _textECl,
            decoration: InputDecoration(
              hintText: "",
              border: textFieldBorder(),
              hintStyle: textFieldHintStyle(),
            )),
      ),
    );
  }

  @override
  void dispose() {
    // 释放所有控制器
    engNameTC.dispose();
    engCountryTC.dispose();
    engUserAgeTC.dispose();
    engEmpiricYearTC.dispose();
    engEmpiricMonthTC.dispose();
    engSkillTC.dispose();
    engJapaneseTC.dispose();
    engSalaryPriceTC.dispose();
    engNearestStationTC.dispose();
    engOperationMonthTC.dispose();
    engOperationDateTC.dispose();
    engInterviewTC.dispose();
    engConcurSituationsTC.dispose();
    engRemarkTC.dispose();
    super.dispose();
    clock.cancel();
  }

  final String title = '';
  final String content = '';

//flutter webファイルアップロード機能
  void _uploadFile() {
    uploadInput.accept = 'xlsx/*'; // 許可されるファイルの種類を設定する
    uploadInput.multiple = false; // 複数のファイル選択を許可するかどうかを設定します

    // ファイル選択が変更されたときのコールバック
    uploadInput.onChange.listen((e) async {
      final files = uploadInput.files;
      if (files == null || files.isEmpty) return;

      final file = files[0]; // 最初に選択したファイルを取得します

      if (file.name.length > 100) {
        fileTextPath.value = "${"../${file.name}".substring(0, 96)}...";
      } else {
        fileTextPath.value = "../${file.name}"; //.${file.type}
      }

      formData.appendBlob('files', file);
    });
  }

  //
}
