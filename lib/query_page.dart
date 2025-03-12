import 'dart:async';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_one/bean/checkbox_list_entity.dart';
import 'package:flutter_test_one/bean/query_entity.dart';
import 'package:flutter_test_one/bean/verify_entity.dart';
import 'package:flutter_test_one/language/local.dart';
import 'package:flutter_test_one/search_detail_page.dart';
import 'package:flutter_test_one/tests.dart';
import 'package:flutter_test_one/util/line_util.dart';
import 'package:flutter_test_one/util/toast_util.dart';
import 'package:get/get.dart';

//Query\検索
class QueryPage extends StatefulWidget {
  const QueryPage({Key? key}) : super(key: key);

  @override
  State<QueryPage> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  //searchBox
  String _engSearchBoxContent = "";
  // 各リスト項目の折りたたまれた状態を初期化します。
  late List<bool> _expandedStates = [];
  // メニューバーの表示状態を制御するために使用されます
  bool isDrawerOpen = false;

  final ScrollController _scrollController = ScrollController();
  bool _showButton = false;

  late QueryEntity item;
  bool isWidthGreater = false;

  bool engTodayQuery = false; //即日

  List<CheckboxListEntity> listCheckbox = [];
  List<CheckboxListEntity> listJapanese = [];
  RxList<QueryEntity> _data = RxList();
  final TextEditingController engSearchMenuTopTC = TextEditingController();

  // 当前选中的排序选项==価格が低い順
  RxString _selectedOption = RxString('年齢が低い順');

  // 下拉菜单的选项
  final List<String> _sortOptions = [
    '年齢が低い順',
    '年齢が高い順',
    '経験年数が低い順',
    '経験年数が高い順',
    '希望単価が低い順',
    '希望単価が高い順',
    '男性のみを表示',
    '女性のみを表示',
  ];

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    listCheckbox.add(CheckboxListEntity("20万〜30万", false));
    listCheckbox.add(CheckboxListEntity("30万〜40万", false));
    listCheckbox.add(CheckboxListEntity("40万〜50万", false));
    listCheckbox.add(CheckboxListEntity("50万〜60万", false));
    listCheckbox.add(CheckboxListEntity("60万〜70万", false));
    listCheckbox.add(CheckboxListEntity("70万〜80万", false));
    listCheckbox.add(CheckboxListEntity("80万〜90万", false));
    listCheckbox.add(CheckboxListEntity("90万〜100万", false));
    listCheckbox.add(CheckboxListEntity("100万〜", false));
    listCheckbox.add(CheckboxListEntity("指定しない", false));

    listJapanese.add(CheckboxListEntity("N3(相当も含む)", false));
    listJapanese.add(CheckboxListEntity("N2(相当も含む)", false));
    listJapanese.add(CheckboxListEntity("N1(相当も含む)", false));

    _scrollController.addListener(() {
      if (_scrollController.offset >= 100) {
        setState(() {
          _showButton = true;
        });
      } else {
        setState(() {
          _showButton = false;
        });
      }
    });

    // _loadMoreData();

    _data.add(QueryEntity(
        "鈴木 大郎",
        "マレーシア",
        "25",
        "男",
        "5",
        "10",
        "C#、ASP.NET、VB.NET、PLSQL、VBscript、HTML、JavaScript、IFS、VBA、PowerShell、L\ninuxコマンド \n基本設計、内部設計、製造、単体、結合、帳票作成、データ移行、インフラ監視経験。",
        "N1相当(業務会話問題ない、独自で日本人現場作業問題ない、独自日本人との打合せは問題ない)",
        "40 ",
        "武蔵小金井（現場出社問題ない）",
        "12",
        "6",
        false,
        "事前調整要",
        "提案のみ",
        "・上流工程のある開発案件希望 \n・真面目、責任感が強い、仕事にやる気満々。 \n・CCNA資格、Oracle12c MASTER Bronze資格取得済み \n・面談時間は事前調整要。 \n"));
    _data.add(QueryEntity(
        "佐藤 美智子",
        "日本",
        "${19 + _currentPage}",
        "女",
        "2",
        "1",
        "UI,SEO,HTTML",
        "N1",
        "23",
        "秋叶原",
        "12",
        "22",
        true,
        "engInterview",
        "engConcurSituations",
        "engRemark"));

    _expandedStates = List.generate(_data.length, (_) => false);
    //
  }

  //トップに戻る
  void _scrollToTop() {
    _scrollController.animateTo(
      0.0, // 一番上の位置までスクロールします
      duration: Duration(milliseconds: 500), // アニメーションの長さ
      curve: Curves.easeInOut, // アニメーションカーブ
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    engSearchMenuTopTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 画面の幅と高さを取得する
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 幅と高さを比較してください
    isWidthGreater = screenWidth > screenHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isWidthGreater
          ? AppBar(
              title: setTitle(Local.appName.tr),
              leading: IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: null //toggleDrawer, // メニューバーの表示状態を切り替える
                  ),
            )
          : AppBar(
              title: Text(Local.appName.tr),
            ), // 非 Web 平台不显示 AppBar
      body: Center(
        child: Row(
          children: [
            // ウェブの左側のメニューバー
            _menuWebLeft(),

            // メインコンテンツエリア（主内容区
            Expanded(
              //戦略 1
              child: isWidthGreater
                  ? CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverFixedExtentList(
                          itemExtent: 280.0,
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                // padding: const EdgeInsets.all(28),
                                margin: EdgeInsets.all(28),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    _searchBoxWidget(),
                                    _searchButton(1),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _toPageUi(),
                                        Spacer(),
                                        _listDropdown(),
                                      ],
                                    )),
                                  ],
                                ),
                              );
                            },
                            childCount: 1,
                          ),
                        ),
                        _listInfoWeb(),
                        //
                      ],
                    )
                  // _nestedScrollView()
                  //戦略 2
                  : NotificationListener<ScrollNotification>(
                      onNotification: _onScrollNotification,
                      child: _nestedScrollView()),
            ),
          ],
        ),
      ),

      drawer: _drawerLeftPhone(isWidthGreater),
      //トップに戻る
      floatingActionButton: _showButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollToTop();
              },
              tooltip: 'Scroll to Top',
              child: Icon(Icons.arrow_upward),
            )
          : null,
    );
  }

  _nestedScrollView() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverFixedExtentList(
            itemExtent: 220.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    _searchBoxWidget(),
                    _searchButton(1),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //_toPageUi(),
                        Spacer(),
                        _listDropdown(),
                      ],
                    )),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ];
      },
      body: Builder(builder: (BuildContext context) {
        return CustomScrollView(
          slivers: <Widget>[
            /* isWidthGreater ? _listInfoWeb() : */ _listInfoPhone(),
          ],
        );
      }),
    );
  }

  _drawerLeftPhone(bool isWidthGreater) {
    return isWidthGreater
        ? null
        : Drawer(
            // width: 350,
            backgroundColor: Colors.grey.shade100,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                _menuSearchTerm(),
              ],
            ),
          );
  }

  _menuWebLeft() {
    isWidthGreater ? isDrawerOpen = true : isDrawerOpen = false;
    return SingleChildScrollView(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isDrawerOpen ? 350 : 0, // 幅を動的に制御する
        color: Colors.grey[00],
        child: isDrawerOpen
            ? Card(
                color: Colors.grey.shade100,
                child: Expanded(
                  child: _menuSearchTerm(),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  //搜索框
  _searchBoxWidget() {
    return Container(
      alignment: Alignment.center,
      // width: 999.w,
      margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 0),
      child: TextField(
        autofocus: false,
        maxLength: 150, // 输入框的最大行数,限制输入字符数
        minLines: 2, //最小行数
        maxLines: 9,
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
          _engSearchBoxContent = value;
        },
        //赋值
        controller: TextEditingController.fromValue(TextEditingValue(
            text: _engSearchBoxContent,
            selection: TextSelection.fromPosition(TextPosition(
                affinity: TextAffinity.downstream,
                offset: _engSearchBoxContent.length)))), //设置controller
      ),
    );
  }

  //web
  _listInfoWeb() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _listCardWeb(index),
              _listCardWeb(index),
              _listCardWeb(index),
            ],
          );
        },
        childCount: _data.length,
      ),
    );
  }

  _listCardWeb(int index) {
    return Expanded(
      child: Obx(
        () => Card(
          color: Colors.white,
          elevation: 3.0, //カードの影のサイズを設定できます。
          margin: EdgeInsets.all(5),
          child: _tableInfo(index),
        ),
      ),
    );
  }

  //phone
  _listInfoPhone() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == _data.length) {
            return Center(child: CircularProgressIndicator());
          }
          return Card(
            color: Colors.white,
            elevation: 3.0, //カードの影のサイズを設定できます。
            margin: EdgeInsets.all(28),
            child: _tableInfo(index),
          );
        },
        childCount: _data.length + (_hasMoreData ? 1 : 0),
      ),
    );
  }

  _tableInfo(int index) {
    item = _data[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
        listTableWidget2(Local.engGender.tr, item.engGender),
        listTableWidget2(Local.engUserAge.tr, item.engUserAge),
        listTableWidget2(Local.engCountry.tr, item.engCountry),
        listTableWidget2(Local.engEmpiric.tr,
            "${item.engEmpiricYear}${Local.engEmpiricYear.tr}${item.engEmpiricMonth}${Local.engEmpiricMonth.tr}"),
        if (_expandedStates[index])
          Column(
            children: [
              listTableWidget2(Local.engJapanese.tr, item.engJapanese),
              listTableWidget2(Local.engSkill.tr, item.engSkill),
              listTableWidget2(Local.engSalaryPrice.tr, item.engSalaryPrice),
              listTableWidget2(
                  Local.engNearestStation.tr, item.engNearestStation),
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
        SizedBox(height: 5.h),
        _detailsButton(),
        SizedBox(height: 15.h),
        InkWell(
          child: Row(children: [
            _expandedStates[index]
                ? const Text(Local.engFoldQuery)
                : const Text(Local.engExpandQuery),
            Icon(
              size: 40.0, // 图标大小
              _expandedStates[index] ? Icons.expand_less : Icons.expand_more,
            ),
          ]),
          onTap: () {
            setState(() {
              _expandedStates[index] = !_expandedStates[index];
            });
          },
        ),
      ],
    );
  }

  //詳細を見る
  _detailsButton() {
    return SizedBox(
      width: double.infinity, // 设置为父容器宽度
      height: 205.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 9),
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => SearchDetail(), arguments: item);
          },
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

            //设置阴影  不适用于这里的TextButton
            elevation: WidgetStateProperty.all(0),
            //设置按钮内边距
            padding: WidgetStateProperty.all(EdgeInsets.all(1)),

            ///设置按钮圆角
            shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),

            ///设置按钮边框颜色和宽度
            side: WidgetStateProperty.all(
                BorderSide(color: Colors.green, width: 1)),
          ),
          child: Text(
            Local.engLearnMoreQuery.tr,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  //检索按钮
  _searchButton(int index) {
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
      child: Text(Local.engSearch.tr,
          style: const TextStyle(
            color: Color.fromARGB(255, 12, 12, 12),
            fontSize: 16.5,
            height: 1,
            fontFamily: "titleFonts",
          )),
      onPressed: () {
        if (index == 1) {
          if (_engSearchBoxContent.isEmpty) {
            toastWarn("コンテンツを入力してください");
            return;
          }
        } else {}
      },
    );
  }

  //下拉菜单筛选
  _listDropdown() {
    return Container(
        width: 210,
        height: 45,
        margin: EdgeInsets.fromLTRB(0, 0, 28.w, 0),
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // 边框颜色
          borderRadius: BorderRadius.circular(4), // 圆角
        ),
        child: Obx(
          () => DropdownButton<String>(
            value: _selectedOption.value,
            isExpanded: true, // 让下拉菜单宽度与父容器一致
            underline: SizedBox(), // 去掉默认下划线
            icon: Icon(Icons.arrow_drop_down), // 下拉箭头图标
            items: _sortOptions.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(
                    color: option == _selectedOption.value
                        ? Colors.blue
                        : Colors.black, // 选中项颜色
                    fontWeight: option == _selectedOption.value
                        ? FontWeight.bold
                        : FontWeight.normal, // 选中项加粗
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              _selectedOption.value = newValue!;
              BotToast.showLoading();
              _upData(newValue);
            },
          ),
        ));
  }

  final int _itemsPerPage = 5;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreData = true; //是否加载更多数据
  RxInt currentPage = RxInt(1); // 当前页码
  RxInt totalPages = RxInt(11); // 总页码
  //手机端动态数据分页（从网络加载）
  _listPagePhone() {}

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;

    // 模拟 API 返回的数据
    List<QueryEntity> fetchedData = [];

    // 模拟网络延迟
    await Future.delayed(Duration(seconds: 2));

    fetchedData.add(QueryEntity(
        "李 太郎",
        "中国",
        "29",
        "男",
        "7",
        "1",
        "flutter,java,android",
        "N5",
        "35",
        "平井",
        "12",
        "29",
        true,
        "engInterview",
        "engConcurSituations",
        "engRemark"));
    fetchedData.add(QueryEntity(
        "林小慧",
        "中国*台湾",
        "${21 + _currentPage}",
        "女",
        "1",
        "1",
        "go,PHP,C",
        "N1",
        "20",
        "中野",
        "12",
        "22",
        true,
        "engInterview",
        "engConcurSituations",
        "engRemark"));

    isWidthGreater ? _data.clear() : null; //感受不到数据变化
    if (fetchedData.isEmpty) {
      _hasMoreData = false;
    } else {
      _data.addAll(fetchedData);
      _currentPage++;
    }
    _isLoading = false;
    _expandedStates = List.generate(_data.length, (_) => false);
    print("--------->data more");
    // _expandedStates.add(false);
    // _expandedStates.add(false);
  }

  //更新数据
  _upData(String name) {
    Timer(Duration(seconds: 1), () {
      switch (name) {
        case "年齢が低い順":
          RxList<QueryEntity> sortedData = RxList.of(_data)
            ..sort((a, b) =>
                int.parse(a.engUserAge).compareTo(int.parse(b.engUserAge)));
          _data.clear();
          _data.addAll(sortedData);
          break;
        case "年齢が高い順":
          // 按年龄从高到低排序
          RxList<QueryEntity> sortedData = RxList.of(_data)
            ..sort((a, b) =>
                int.parse(b.engUserAge).compareTo(int.parse(a.engUserAge)));
          _data.clear();
          _data.addAll(sortedData);
          // 打印排序后的结果
          sortedData.forEach((entity) {
            print('Name: ${entity.engName}, Age: ${entity.engUserAge}');
          });
          break;
        case "経験年数が低い順":
          RxList<QueryEntity> sortedData = RxList.of(_data)
            ..sort((a, b) => int.parse(a.engEmpiricYear)
                .compareTo(int.parse(b.engEmpiricYear)));
          _data.clear();
          _data.addAll(sortedData);
          break;
        case "経験年数が高い順":
          RxList<QueryEntity> sortedData = RxList.of(_data)
            ..sort((a, b) => int.parse(b.engEmpiricYear)
                .compareTo(int.parse(a.engEmpiricYear)));
          _data.clear();
          _data.addAll(sortedData);
          break;
        case "希望単価が低い順":
          RxList<QueryEntity> sortedData = RxList.of(_data)
            ..sort((a, b) => int.parse(a.engSalaryPrice)
                .compareTo(int.parse(b.engSalaryPrice)));
          _data.clear();
          _data.addAll(sortedData);
          break;
        case "希望単価が高い順":
          RxList<QueryEntity> sortedData = RxList.of(_data)
            ..sort((a, b) => int.parse(b.engSalaryPrice)
                .compareTo(int.parse(a.engSalaryPrice)));
          _data.clear();
          _data.addAll(sortedData);
          break;
        case "男性のみを表示":
          break;
        case "女性のみを表示":
          break;
      }
      BotToast.closeAllLoading();
    });
  }

  _listSort() {
    //
  }

  // 下にスライドするかどうかを決定します
  bool _onScrollNotification(ScrollNotification scrollInfo) {
    if (!_isLoading &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _loadMoreData();
    }
    return true;
  }

  void goToPreviousPage() {
    if (currentPage.value > 1) {
      BotToast.showLoading();
      currentPage.value--;
      _loadMoreData().then((v) {
        BotToast.closeAllLoading();
      });
    } else {
      toastWarn("すでに最初のページ");
    }
  }

  void goToNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      BotToast.showLoading();
      _loadMoreData().then((v) {
        BotToast.closeAllLoading();
      });
    } else {
      toastWarn("もう最後のページ");
    }
  }

  _toPageUi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 28.w,
        ),
        // 显示当前页码和总页码
        Obx(() => Text(
              '${currentPage.value}/${totalPages.value}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
        SizedBox(width: 16),

        // 下一页按钮
        TextButton(
          onPressed: goToNextPage,
          child: Text(
            '下一页',
            style: TextStyle(fontSize: 16),
          ),
        ),

        // 上一页按钮
        TextButton(
          onPressed: goToPreviousPage,
          child: Text(
            '上一页',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

//>---------------------------------サイドメニュー--------------------------------------<//
  _menuSearchTerm() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('フリーワード検索'),
          // Search Bar
          Container(
            color: Colors.white, // 背景色
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey, width: 1.0), // 设置边框
                  ),
                  child: Row(
                    children: [
                      // Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '検索キー',
                            border: InputBorder.none,
                          ),
                          controller: engSearchMenuTopTC,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                // Language Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      _buildTagButton('Java'),
                      _buildTagButton('C#'),
                      _buildTagButton('PHP'),
                      _buildTagButton('C/C++'),
                      _buildTagButton('Ruby'),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),

          // Basic Conditions
          _buildSectionTitle('基本条件'),
          // Divider(),
          Container(
            color: Colors.white, // 背景色
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Local.engOperationQuery.tr,
                        style: TextStyle(fontSize: 16.0)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: engTodayQuery,
                            onChanged: (value) {
                              setState(() {
                                engTodayQuery = value!;
                              });
                            }),
                        Text(Local.engTodayQuery.tr),
                        SizedBox(width: 8.0),
                        SizedBox(
                          width: 60.0,
                          height: 40.0,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: textFieldHintStyle(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 8.0,
                              ),
                            ),
                          ),
                        ),
                        Text('${Local.engEmpiricMonthQuery}〜'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(Local.engEmpiricQuery.tr,
                        style: TextStyle(fontSize: 16.0)),
                    SizedBox(width: 16.0),
                    SizedBox(
                      width: 60.0,
                      height: 40.0,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintStyle: textFieldHintStyle(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 1,
                            horizontal: 8.0,
                          ),
                        ),
                      ),
                    ),
                    Text('${Local.engEmpiricYearQuery}〜'),
                  ],
                ),
                SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Local.engJapaneseQuery.tr,
                        style: TextStyle(fontSize: 16.0)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: true,
                      itemCount: listJapanese.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(listJapanese[index].title),
                          value: listJapanese[index].isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              listJapanese[index].isChecked = value ?? false;
                            });
                          },
                          controlAffinity:
                              ListTileControlAffinity.leading, // 控制复选框位置
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.0.h),
              ],
            ),
          ),

          // Detailed Conditions
          _buildSectionTitle('詳細条件'),
          // Divider(),
          Container(
            color: Colors.white, // 背景色
            // width: 250.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('単価'),
                //オプション 1
                // Wrap(
                //   spacing: 30.0,
                //   runSpacing: 8.0,
                //   children: [
                Row(children: [
                  _buildCheckboxOption('20万〜30万', 0),
                  SizedBox(width: 40.w),
                  _buildCheckboxOption('30万〜40万', 1),
                ]),

                Row(children: [
                  _buildCheckboxOption('40万〜50万', 2),
                  SizedBox(width: 40.w),
                  _buildCheckboxOption('50万〜60万', 3),
                ]),

                Row(children: [
                  _buildCheckboxOption('80万〜90万', 4),
                  SizedBox(width: 40.w),
                  _buildCheckboxOption('90万〜100万', 5),
                ]),

                Row(children: [
                  _buildCheckboxOption('100万〜      ', 6),
                  SizedBox(width: 40.w),
                  _buildCheckboxOption('指定しない', 7),
                ]),

                //   ],
                // ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 150.h),
            child: _searchButton(2),
          ),
        ],
      ),
    );
  }

  // Helper widget for tag buttons
  _buildTagButton(String label) {
    return ElevatedButton(
      onPressed: () {
        engSearchMenuTopTC.text = label;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: Text(label),
    );
  }

  // Helper widget for section title
  Widget _buildSectionTitle(String title) {
    return Container(
      height: 180.h,
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper widget for checkbox options
  Widget _buildCheckboxOption(String label, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
            value: listCheckbox[index].isChecked,
            onChanged: (value) {
              setState(() {
                listCheckbox[index].isChecked = value ?? false;
              });
            }),
        Text(label),
      ],
    );
  }
}
