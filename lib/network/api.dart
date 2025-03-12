import 'package:flutter_test_one/bean/verify_entity.dart';

import '../util/toast_util.dart';
import 'api_url.dart';
import 'http_helper.dart';

//提交文件和文本内容，
Future postFileAndText(files /* , txt */) async {
  var (status, response) = await HttpHelper.instance
      .post(fileText, data: files /* {"files": files, "strTxt": txt} */);
  if (status == 200) {
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}

//login
Future postVerifyLogin(VerifyEntity verify) async {
  var (status, response) = await HttpHelper.instance.post(verifyLogin, data: {
    'engName': verify.engName,
    'engCountry': verify.engCountry,
    'engUserAge': int.parse(verify.engUserAge),
    'engGender': verify.engGender,
    "engEmpiricYear": int.parse(verify.engEmpiricYear),
    "engEmpiricMonth": int.parse(verify.engEmpiricMonth),
    "engSkill": verify.engSkill,
    "engJapanese": verify.engJapanese,
    "engSalaryPrice": int.parse(verify.engSalaryPrice),
    "engNearestStation": verify.engNearestStation,
    "engOperationMonth": int.parse(verify.engOperationMonth),
    "engOperationDate": int.parse(verify.engOperationDate),
    "engToday": verify.engToday,
    "engInterview": verify.engInterview,
    "engConcurSituations": verify.engConcurSituations,
    "engRemark": verify.engRemark,
  });
  if (status == 200) {
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}

Future postAlert(deviceId, ip, name) async {
  var (status, response) = await HttpHelper.instance
      .post(alert, data: {'device_id': deviceId, 'ip': ip, 'name': name});
  if (status == 200) {
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}

Future postBookNumber(deviceId, ip, name, rfid) async {
  var (status, response) = await HttpHelper.instance.post(bookNumber,
      data: {'device_id': deviceId, 'ip': ip, 'name': name, 'rfid': rfid});
  if (status == 200) {
    return status;
  } else {
    toastWarn('$response');
    return null;
  }
}
