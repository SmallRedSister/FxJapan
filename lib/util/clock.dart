import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:get/get.dart';


class Clock {

  Clock._internal();

  static final Clock _singleton = Clock._internal();

  factory Clock() => _singleton;

  Timer? _timer;


  RxString time = RxString('');
  RxString day = RxString('');
  RxString weekDay = RxString('');


  void start(){
    cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculate();
    });

    _calculate();
  }

  _calculate(){
    time.value =  formatDate(DateTime.now(), [HH, ':', nn, ':', ss]);
    day.value =  formatDate(DateTime.now(), [yy, '年', mm, '月', dd, '日']);
    weekDay.value =  formatDate(DateTime.now(), [DD]);
  }

  void cancel(){
    if(_timer != null){
      if (_timer!.isActive) {
        _timer!.cancel();
        _timer = null;
      }
    }
  }

}
