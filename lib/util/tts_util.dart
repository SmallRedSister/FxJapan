// import 'package:flutter_tts/flutter_tts.dart';
//
// class TTSUtil {
//
//   /*TTSUtil._();
//   static TTSUtil? _manager;
//
//   factory TTSUtil() {
//     if (_manager == null) {
//       _manager = TTSUtil._();
//     }
//     return _manager;
//   }*/
//
//   late FlutterTts flutterTts;
//
//   initTTS() {
//     flutterTts = FlutterTts();
//   }
//
//   Future speak(String text) async {
//     /// 设置语言
//     await flutterTts.setLanguage("zh-CN");
//     // 需配置中文语音包，若没有请自行下载，讯飞语音包亲测可用。
//     // 本站下载地址 {root}/dart_tts_confirm/kdxf_tts.apk
//
//     /// 设置音量
//     await flutterTts.setVolume(0.8);
//
//     /// 设置语速
//     await flutterTts.setSpeechRate(0.5);
//
//     /// 音调
//     await flutterTts.setPitch(1.0);
//
//     if (text != null) {
//       if (text.isNotEmpty) {
//         await _stop();
//         await flutterTts.speak(text);
//       }
//     }
//   }
//
//   /// 暂停
//   Future _pause() async {
//     await flutterTts.pause();
//   }
//
//   /// 结束
//   Future _stop() async {
//     await flutterTts.stop();
//   }
//
// }