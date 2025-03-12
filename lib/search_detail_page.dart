import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_one/bean/query_entity.dart';
import 'package:flutter_test_one/language/local.dart';
import 'package:flutter_test_one/util/line_util.dart';
import 'package:get/get.dart';

/* 检索技術者の明細页面 page */
class SearchDetail extends StatefulWidget {
  const SearchDetail({Key? key}) : super(key: key);

  @override
  State<SearchDetail> createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> {
  late QueryEntity item;
  bool isWidthGreater = false;

  @override
  initState() {
    super.initState();
    item = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを取得する
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 幅と高さを比較してください
    isWidthGreater = screenWidth > screenHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Scrollbar(
          interactive: true, //滑动条为true 可拖动
          child: SingleChildScrollView(
              primary: true,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //标题
                  setTitle(Local.appName.tr),
                  isWidthGreater ? _webCardSearch() : _phoneCardSearch(),
                  //底部两个按钮
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
                              horizontal: 80.0.w, vertical: 10.0.h),
                        ),
                        child: const Text("戻る",
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
                              horizontal: 80.0.w, vertical: 10.0.h),
                        ),
                        child: const Text("確認する",
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
                    ],
                  ),
                  SizedBox(height: 100.h),
                ],
              ))),
    );
  }

  _webCardSearch() {
    return Card(
      color: Colors.white,
      elevation: 3.0, //可以设置卡片的阴影大小：
      margin: EdgeInsets.all(58),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("技術者の明細",
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Color.fromARGB(255, 18, 155, 240),
                  fontSize: 21.5,
                  height: 1,
                  fontFamily: "titleFonts",
                )),
          ),
          listTableWidget4(
              Local.engName.tr, item.engName, Local.engGender.tr, "00"),
          listTableWidget4(Local.engUserAge.tr, item.engUserAge,
              Local.engCountry.tr, item.engCountry),
          listTableWidget2w(Local.engEmpiric.tr,
              "${item.engEmpiricYear}${Local.engEmpiricYear.tr}${item.engEmpiricMonth}${Local.engEmpiricMonth.tr}"),
          listTableWidget2w(Local.engJapanese.tr, item.engJapanese),
          listTableWidget2w(Local.engSkill.tr, item.engSkill),
          listTableWidget4(Local.engSalaryPrice.tr, item.engSalaryPrice,
              Local.engNearestStation.tr, item.engNearestStation),
          listTableWidget4(
              Local.engOperation.tr,
              '即日OR${item.engOperationMonth}${Local.engOperationMonth.tr}${item.engOperationDate}${Local.engOperationDate.tr}',
              Local.engInterview.tr,
              item.engInterview),
          listTableWidget2w(
              Local.engConcurSituations.tr, item.engConcurSituations),
          listTableWidget2w(Local.engRemark.tr, item.engRemark),
        ],
      ),
    );
  }

  _phoneCardSearch() {
    return Card(
      color: Colors.white,
      elevation: 3.0, //カードの影のサイズを設定できます。
      margin: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(Local.engSkillDetailsQuery.tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17.5,
                  height: 1,
                  fontFamily: "titleFonts",
                )),
          ),
          listTableWidget2(Local.engName.tr, item.engName),
          listTableWidget2(Local.engGender.tr, "男"),
          listTableWidget2(Local.engUserAge.tr, item.engUserAge),
          listTableWidget2(Local.engCountry.tr, item.engCountry),
          listTableWidget2(Local.engEmpiric.tr,
              "${item.engEmpiricYear}${Local.engEmpiricYear.tr}${item.engEmpiricMonth}${Local.engEmpiricMonth.tr}"),
          listTableWidget2(Local.engJapanese.tr, item.engJapanese),
          listTableWidget2(Local.engSkill.tr, item.engSkill),
          listTableWidget2(Local.engSalaryPrice.tr, item.engSalaryPrice),
          listTableWidget2(Local.engNearestStation.tr, item.engNearestStation),
          listTableWidget2(
            Local.engOperation.tr,
            '${Local.engTodayQuery}OR${item.engOperationMonth}${Local.engOperationMonth.tr}${item.engOperationDate}${Local.engOperationDate.tr}',
          ),
          listTableWidget2(Local.engInterview.tr, item.engInterview),
          listTableWidget2(
              Local.engConcurSituations.tr, item.engConcurSituations),
          listTableWidget2(Local.engRemark.tr, item.engRemark),
        ],
      ),
    );
  }
}
