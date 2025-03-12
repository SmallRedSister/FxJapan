import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//統一された設定テキスト
textView(String txt, Alignment isCenter) {
  return Container(
    width: 150.w,
    // height: 60.h,
    // constraints: BoxConstraints(
    //   minWidth: 90, // 最小宽度
    //   maxWidth: 188, // 最大宽度
    // ),
    alignment: isCenter,
    padding: const EdgeInsets.only(left: 10),
    child: SelectableText(txt,
        // maxLines: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.blue, fontSize: 15)),
  );
}

//年月text, 宽度不被挤压
textYears(String txt) {
  return Container(
    width: 38,
    // height: 60,
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(left: 10),
    child: SelectableText(
      txt,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        height: 1,
      ),
      // cursorColor: Colors.blue,
      // showCursor: true,
    ),
  );
}

//統一された設定テキスト
textQueryTitle(String txt, Alignment isCenter) {
  return Container(
      width: 150.w,
      height: 60.h,
      alignment: isCenter,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.0), // 设置边框
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SelectableText(txt,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              height: 5,
            )),
      ));
}

//
OutlineInputBorder textFieldBorder() {
  return OutlineInputBorder(
    //枠線の四隅の曲率を設定します
    borderRadius: BorderRadius.all(Radius.circular(7)),
    //用来配置边框的样式
    borderSide: BorderSide(
      //设置边框的颜色
      color: Colors.red,
      //设置边框的粗细
      width: 2.0,
    ),
  );
}

//
TextStyle textFieldHintStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 14.5,
      height: 1,
      fontFamily: "Courier",
      decorationStyle: TextDecorationStyle.dashed);
}

//トピック名
Text setTitle(String pTitle) {
  return Text(pTitle,
      textAlign: TextAlign.left,
      maxLines: 1,
      style: const TextStyle(
        color: Color.fromARGB(255, 18, 155, 240),
        fontSize: 21.5,
        height: 1,
        fontFamily: "titleFonts",
      ));
}

//一行两列
listTableWidget2(String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 信息表格部分
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1.3), // 左边列宽度
            1: FlexColumnWidth(8), // 右边列宽度
          },
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            _buildTableRow2(title, content),
          ],
        ),
        const SizedBox(height: 1),
      ],
    ),
  );
}

//一行两列
listTableWidget2w(String title, String content) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 信息表格部分
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1), // 左边列宽度
            1: FlexColumnWidth(8), // 右边列宽度
          },
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            _buildTableRow2(title, content),
          ],
        ),
        const SizedBox(height: 1),
      ],
    ),
  );
}

// 构建表格行的辅助方法
_buildTableRow2(String title, String content) {
  return TableRow(
    children: [
      Container(
        color: Colors.grey.shade100, // 背景色
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SelectableText(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SelectableText(content),
      ),
    ],
  );
}

//一行四列
listTableWidget4(String title, String content, String name, String txt) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 信息表格部分
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1), // 左边列宽度
            1: FlexColumnWidth(3.5), // 右边列宽度
            2: FlexColumnWidth(1), // 右边列宽度
            3: FlexColumnWidth(3.5), // 右边列宽度
          },
          border: TableBorder.all(color: Colors.grey.shade300),
          children: [
            TableRow(
              children: [
                Container(
                  color: Colors.grey.shade100, // 背景色
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    content,
                  ),
                ),
                Container(
                  color: Colors.grey.shade100, // 背景色
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    txt,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

//分割線
engLine() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
    child: Divider(
      height: 1.0, // 线条的高度
      color: Colors.grey, // 线条的颜色
    ),
    /* child: SizedBox(
        width: 999.w,
        child: CustomPaint(
          // 事件区域，如 GestureDetector 事件只能作用在 size 范围内
          //size: Size(900.w, 100.h),
          painter: LinePainter(), // 背景层
          // 中间层
          //child: Text("hello"),
          // 前景层
          foregroundPainter: null,
        ),
      ), */
  );
}

//

//絵线
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final startPoint = Offset(10, size.height / 2);
    final endPoint = Offset(780, size.height / 2);

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
