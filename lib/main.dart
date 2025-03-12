import 'package:bot_toast/bot_toast.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test_one/core/admin.dart';
import 'package:flutter_test_one/index_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'network/api_url.dart';
import 'util/clock.dart';
import 'language/messages.dart';
import 'util/language_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  eventFactory = EventBus();
  await GetStorage.init();
  final box = GetStorage();

  clock = Clock()..start();
  runApp(const MyApp());
}

late EventBus eventFactory;
late Clock clock;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return ScreenUtilInit(
      // designSize: const Size(1920, 1080), // 设置设计稿的尺寸
      designSize: const Size(1080, 2400), //设计稿宽高的px
      minTextAdapt: true, //是否根据宽度/高度中的最小值适配文字
      splitScreenMode: true, //支持分屏尺寸
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          builder: BotToastInit(),
          home: Index(), //主界面
          // home: AdminPage(), //测试界面
          translations: Messages(), //所有的多语言翻译资源
          // locale: Get.deviceLocale, //跟随系统设置语言 持久化以后这里改一下
          // fallbackLocale: Locale("jp", "JP"), //未提供当前Locale翻译时，备用的翻译"zh", "CN"
          // locale: LanguageUtils.getLocale(),
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            print('当前语言：${deviceLocale.toString()}');
            return;
          },
        );
      },
    );
  }
}
