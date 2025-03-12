import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DialogWidget {
  loginDialog(login) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      content: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(6.r)),
          ),
          child: Column(
            children: [
              Text("ログインしてもよろしいですか?",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      height: 5,
                      fontFamily: "Courier",
                      decorationStyle: TextDecorationStyle.dashed)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(150.w, 40.h),
                    ),
                    child: const Text("戻る",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
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
                      minimumSize: Size(150.w, 40.h),
                    ),
                    child: const Text("登録",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22.0,
                            height: 2,
                            fontFamily: "Courier",
                            decorationStyle: TextDecorationStyle.dashed)),
                    onPressed: () {
                      Get.back();
                      login("go");
                    },
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 23.h),
            ],
          )),
    );
  }
}
