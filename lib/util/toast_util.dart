import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

toastError(String msg){
  BotToast.cleanAll();
  BotToast.showText(text: msg,align: const Alignment(0, 0),
      duration: const Duration(seconds: 3),contentColor: Colors.red,textStyle: TextStyle(fontSize: 14.sp,color: Colors.white));
}

toastWarn(String msg){
  BotToast.cleanAll();
  BotToast.showText(text: msg,align: const Alignment(0, 0),
      duration: const Duration(seconds: 5),contentColor: Colors.white,textStyle: TextStyle(fontSize: 12.sp));
}