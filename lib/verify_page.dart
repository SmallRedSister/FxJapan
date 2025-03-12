import 'dart:async';
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_test_one/bean/verify_entity.dart';
import 'package:flutter_test_one/language/local.dart';
import 'package:flutter_test_one/network/api.dart';
import 'package:flutter_test_one/query_page.dart';
import 'package:flutter_test_one/util/line_util.dart';
import 'package:flutter_test_one/util/toast_util.dart';
import 'package:flutter_test_one/widget/dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/* 登録確認へ page */
class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  RxBool check = RxBool(false);
  int counter = 1; // 用于生成新数据的计数器
  late VerifyEntity item;
  bool isWidthGreater = false;

  late StreamSubscription<ConnectivityResult> _subscription;
  String _connectionStatus = 'Unknown';

  @override
  initState() {
    super.initState();
    item = Get.arguments;
    // 监听网络变化
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        // 更新网络状态
        switch (result) {
          case ConnectivityResult.wifi:
            _connectionStatus = "Connected to WiFi";
            break;
          case ConnectivityResult.mobile:
            _connectionStatus = "Connected to Mobile Network";
            break;
          case ConnectivityResult.none:
            _connectionStatus = "No Internet Connection";
            break;
          default:
            _connectionStatus = "Unknown";
        }
      });
    });
  }

  @override
  void dispose() {
    // 取消订阅
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを取得する
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 幅と高さを比較してください
    isWidthGreater = screenWidth > screenHeight;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Scrollbar(
            interactive: true,
            child: SingleChildScrollView(
                primary: true,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    setTitle(Local.appName.tr),
                    isWidthGreater ? _webCard() : _phoneCard(),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60.0, vertical: 10.0),
                          ),
                          child: const Text(Local.engBacktrack,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  height: 2,
                                  fontFamily: "Courier",
                                  decorationStyle: TextDecorationStyle.dashed)),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        SizedBox(width: 10.w),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 60.0, vertical: 10.0),
                          ),
                          child: const Text(Local.engLogin,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  height: 2,
                                  fontFamily: "Courier",
                                  decorationStyle: TextDecorationStyle.dashed)),
                          onPressed: () {
                            DialogWidget().loginDialog((e) {
                              // BotToast.showLoading();
                              // postVerifyLogin(item).then((value) {
                              //   BotToast.closeAllLoading();
                              //   print("_postVerifyLogin=$value");
                              Get.to(() => QueryPage());
                              // });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 90.h),
                    Text("Connection Status: $_connectionStatus")
                  ],
                ))),
      ),
    );
  }

  Card _webCard() {
    return Card(
      color: Colors.grey.shade100,
      elevation: 2.0, //可以设置卡片的阴影大小：
      margin: EdgeInsets.all(108),
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
              verifyText(180, 100, 10, TextInputType.text, item.engName),

              //国籍
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: TextDirection.ltr,
                  children: [
                    textView(Local.engCountry.tr, Alignment.center),
                    verifyText(
                        230, 100, 10, TextInputType.text, item.engCountry),
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
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engUserAge),
              textYears(Local.engAgeYear.tr),
              SizedBox(width: 60.w),
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
                          onChanged: null,
                          // 按钮组的值
                          groupValue: item.engGender,
                        ),
                        SizedBox(width: 50.w),
                        Text("女"),
                        Radio(
                          value: 2,
                          onChanged: null,
                          groupValue: item.engGender,
                        ),
                      ],
                    ),
                    SizedBox(width: 45.w),
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
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engEmpiricYear),
              textYears(Local.engEmpiricYear.tr),
              //月
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engEmpiricMonth),

              textYears(Local.engEmpiricMonth.tr),
            ],
          ),
          //线条
          engLine(),
          //得意ㇲキル
          Row(
            children: <Widget>[
              textView(Local.engSkill.tr, Alignment.centerLeft),
              verifyText(700, 100, 150, TextInputType.text, item.engSkill),
            ],
          ),
          //线条
          engLine(),
          //日本語
          Row(
            children: <Widget>[
              textView(Local.engJapanese.tr, Alignment.centerLeft),
              verifyText(600, 100, 30, TextInputType.text, item.engJapanese),
            ],
          ),
          //线条
          engLine(),
          //
          Row(
            children: <Widget>[
              //希望単価
              textView(Local.engSalaryPrice.tr, Alignment.centerLeft),
              verifyTextPhone(
                  45, 100, 3, TextInputType.number, item.engSalaryPrice),
              textYears(Local.engMoney.tr),
              SizedBox(width: 120.w),
              //最寄駅
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: [
                    textView(Local.engNearestStation.tr, Alignment.center),
                    verifyText(230, 100, 10, TextInputType.text,
                        item.engNearestStation),
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
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engOperationMonth),
              textYears(Local.engOperationMonth.tr),
              //日
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engOperationDate),
              textYears(Local.engOperationDate.tr),

              //OR
              Padding(
                padding: const EdgeInsets.only(left: 13.0, right: 22.0),
                child: Text("OR",
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 15, 15, 15),
                      fontSize: 16.5,
                      height: 1,
                      fontFamily: "titleFonts",
                    )),
              ),

              //即日
              Row(
                children: [
                  Text(Local.engToday.tr),
                  SizedBox(width: 10.w),
                  Checkbox(
                    value: item.engToday,
                    onChanged: null,
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
              verifyText(600, 100, 20, TextInputType.text, item.engInterview),
            ],
          ),
          //线条
          engLine(),
          //並行状況
          Row(
            children: <Widget>[
              textView(Local.engConcurSituations.tr, Alignment.centerLeft),
              verifyText(
                  600, 200, 20, TextInputType.text, item.engConcurSituations),
            ],
          ),
          //线条
          engLine(),
          //備考
          Row(
            children: <Widget>[
              textView(Local.engRemark.tr, Alignment.centerLeft),
              verifyText(700, 100, 150, TextInputType.text, item.engRemark),
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

  //
  Card _phoneCard() {
    return Card(
      color: Colors.grey.shade100,
      elevation: 2.0, //可以设置卡片的阴影大小：
      margin: EdgeInsets.all(18),
      child: Column(
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
          //氏名
          Row(
            children: [
              textView(Local.engName.tr, Alignment.centerLeft),
              verifyTextPhone(190, 100, 10, TextInputType.text, item.engName),
            ],
          ),
          //线条
          engLine(),
          //国籍
          Row(
            children: [
              textView(Local.engCountry.tr, Alignment.centerLeft),
              verifyTextPhone(
                  190, 100, 10, TextInputType.text, item.engCountry),
            ],
          ),

          //线条----------------------------------------------------------------
          engLine(),
          //
          Row(
            children: <Widget>[
              //年齢
              textView(Local.engUserAge.tr, Alignment.centerLeft),
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engUserAge),
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
                SizedBox(width: 5.w),
                Text("男"),
                Radio(
                  // 按钮的值
                  value: 1,
                  // 改变事件
                  onChanged: null,
                  // 按钮组的值
                  groupValue: item.engGender,
                ),
                SizedBox(width: 15.w),
                Text("女"),
                Radio(
                  value: 2,
                  onChanged: null,
                  groupValue: item.engGender,
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
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engEmpiricYear),
              textYears(Local.engEmpiricYear.tr),
              //月
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engEmpiricMonth),

              textYears(Local.engEmpiricMonth.tr),
            ],
          ),
          //线条
          engLine(),
          //得意ㇲキル
          Row(
            children: <Widget>[
              textView(Local.engSkill.tr, Alignment.centerLeft),
              verifyText(800, 100, 150, TextInputType.text, item.engSkill),
            ],
          ),
          //线条
          engLine(),
          //日本語
          Row(
            children: <Widget>[
              textView(Local.engJapanese.tr, Alignment.centerLeft),
              verifyText(800, 100, 30, TextInputType.text, item.engJapanese),
            ],
          ),
          //线条
          engLine(),
          ////希望単価
          Row(
            children: <Widget>[
              textView(Local.engSalaryPrice.tr, Alignment.centerLeft),
              verifyTextPhone(
                  45, 100, 3, TextInputType.number, item.engSalaryPrice),
              textYears(Local.engMoney.tr),
            ],
          ),
          //线条
          engLine(),
          //最寄駅
          Row(children: [
            textView(Local.engNearestStation.tr, Alignment.centerLeft),
            verifyText(
                230, 100, 10, TextInputType.text, item.engNearestStation),
          ]),
          //线条
          engLine(),
          //稼動可能日
          Row(
            children: <Widget>[
              //稼動可能日
              textView(Local.engOperation.tr, Alignment.centerLeft),
              //月
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engOperationMonth),
              textYears(Local.engOperationMonth.tr),
              //日
              verifyTextPhone(
                  35, 100, 2, TextInputType.number, item.engOperationDate),
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
              Text(Local.engToday.tr),
              SizedBox(width: 15.w),
              Checkbox(
                value: item.engToday,
                onChanged: null,
              ),
            ],
          ),
          //线条
          engLine(),
          //面谈
          Row(
            children: <Widget>[
              textView(Local.engInterview.tr, Alignment.centerLeft),
              verifyText(800, 100, 20, TextInputType.text, item.engInterview),
            ],
          ),
          //线条
          engLine(),
          //並行状況
          Row(
            children: <Widget>[
              textView(Local.engConcurSituations.tr, Alignment.centerLeft),
              verifyText(
                  800, 200, 20, TextInputType.text, item.engConcurSituations),
            ],
          ),
          //线条
          engLine(),
          //備考
          Row(
            children: <Widget>[
              textView(Local.engRemark.tr, Alignment.centerLeft),
              verifyText(800, 100, 150, TextInputType.text, item.engRemark),
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

//Textの統一構成
  Container verifyText(double widths, double heights, int maxLength,
      TextInputType keyType, String txtData) {
    return Container(
      width: widths.w,
      margin: EdgeInsets.all(3), //外邊距 (margin): 控制元素與其他元素之間的距離
      padding: EdgeInsets.all(7.0), //內邊距 (padding): 控制內容與邊框之間的距離
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), // 设置边框
      ),
      child: SelectableText(txtData,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              // decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed)),
    );
  }

  //Textの統一構成  phone
  verifyTextPhone(double widths, double heights, int maxLength,
      TextInputType keyType, String txtData) {
    return Container(
      width: widths,
      margin: EdgeInsets.all(3), //外邊距 (margin): 控制元素與其他元素之間的距離
      padding: EdgeInsets.all(7.0), //內邊距 (padding): 控制內容與邊框之間的距離
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), // 设置边框
      ),
      child: Text(txtData,
          textAlign: TextAlign.left,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              // decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed)),
    );
  }

  //检查当前网络状态
  Future<void> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
    } else if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
    } else {
      print("No Internet Connection");
    }
  }
}
