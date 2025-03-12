import 'package:intl/intl.dart';

///格式化工具类
class FormatUtil {

  ///日期格式
  static const String ymdHms = "yyyy-MM-dd HH:mm:ss";

  /// 格式化数值
  /// var f = NumberFormat("###.0#", "en_US");
  /// print(f.format(12.345));
  /// ==> 12.34
  static String formatNumber(
      {String pattern = '###.0#', dynamic number, String? locale}) {
    return NumberFormat(pattern, locale).format(number);
  }

  ///逗号分割数值 输出 1,200,000
  static String decimalPattern(
      { dynamic number, String? locale}) {
    return  NumberFormat.decimalPattern(locale).format(number);
  }

  /// 格式化日期
  /// "yyyy-MM-dd HH:mm:ss"
  static String formatDate(
      {String pattern = 'yyyy-MM-dd HH:mm:ss', required DateTime date}) {
    return DateFormat(pattern).format(date);
  }

  /// 格式化毫秒日期
  /// "yyyy-MM-dd HH:mm:ss"
  static String formatMilliseconds(String pattern, int milliseconds) {
    return formatDate(
      pattern: pattern,
      date: DateTime.fromMillisecondsSinceEpoch(milliseconds),
    );
  }

}
