import 'package:json_annotation/json_annotation.dart';

part 'eng_entity.g.dart';

@JsonSerializable()
class EngEntity {
  // @JsonKey(name: 'eng_name')
  // String engName;
  // @JsonKey(name: 'eng_country')
  // String engCountry;
  // @JsonKey(name: 'eng_user_age')
  // int engUserAge;
  // @JsonKey(name: 'eng_gender')
  // int engGender;
  // @JsonKey(name: 'eng_empiric_year')
  // int engEmpiricYear;
  // @JsonKey(name: 'eng_empiric_month')
  // int engEmpiricMonth;
  // @JsonKey(name: 'eng_skill')
  // String engSkill;
  // @JsonKey(name: 'eng_japanese')
  // String engJapanese;
  // @JsonKey(name: 'eng_salary_price')
  // int engSalaryPrice;
  // @JsonKey(name: 'eng_nearest_station')
  // String engNearestStation;
  // @JsonKey(name: 'eng_operation_month')
  // int engOperationMonth;
  // @JsonKey(name: 'eng_operation_date')
  // int engOperationDate;
  // @JsonKey(name: 'eng_today')
  // bool engToday;
  // @JsonKey(name: 'eng_interview')
  // String engInterview;
  // @JsonKey(name: 'eng_concur_situations')
  // String engConcurSituations;
  // @JsonKey(name: 'eng_remark')
  // String engRemark;

  String engName;
  String engCountry;
  int engUserAge;
  int engGender;
  int engEmpiricYear;
  int engEmpiricMonth;
  String engSkill;
  String engJapanese;
  int engSalaryPrice;
  String engNearestStation;
  int engOperationMonth;
  int engOperationDate;
  bool engToday;
  String engInterview;
  String engConcurSituations;
  String engRemark;

  EngEntity(
      this.engName,
      this.engCountry,
      this.engUserAge,
      this.engGender,
      this.engEmpiricYear,
      this.engEmpiricMonth,
      this.engSkill,
      this.engJapanese,
      this.engSalaryPrice,
      this.engNearestStation,
      this.engOperationMonth,
      this.engOperationDate,
      this.engToday,
      this.engInterview,
      this.engConcurSituations,
      this.engRemark);

  factory EngEntity.fromJson(Map<String, dynamic> json) =>
      _$EngEntityFromJson(json);

  Map<String, dynamic> toJson() => _$EngEntityToJson(this);
}
/* 
{
    "resultCode": 200,
    "message": "成功",
    "data": {
        "engName": "鈴木　大郎",
        "engCountry": "マレーシア",
        "engUserAge": 25,
        "engGender": 1,
        "engEmpiricYear": 4,
        "engEmpiricMonth": 11,
        "engSkill": "C#、ASP.NET、VB.NET、PLSQL、VBscript、HTML、JavaScript、IFS、VBA、PowerShell、L\ninuxコマンド \n基本設計、内部設計、製造、単体、結合、帳票作成、データ移行、インフラ監視経験。\n",
        "engJapanese": "N1相当(業務会話問題ない、独自で日本人現場作業問題ない、独自日本人との打合せは問題ない) ",
        "engSalaryPrice": 35,
        "engNearestStation": "武蔵小金井（現場出社問題ない） ",
        "engOperationMonth": 12,
        "engOperationDate": 1,
        "engToday": false,
        "engInterview": "事前調整要",
        "engConcurSituations": "提案のみ",
        "engRemark": "・上流工程のある開発案件希望 \n・真面目、責任感が強い、仕事にやる気満々。 \n・CCNA資格、Oracle12c MASTER Bronze資格取得済み \n・面談時間は事前調整要。 \n"
    }
}
 */
// 返回结果=>{"resultCode":200,"message":"成功","data":{"engName":"鈴木　大郎","engCountry":"マレーシア","engUserAge":25,"engGender":1,"engEmpiricYear":4,"engEmpiricMonth":11,"engSkill":"C#、ASP.NET、VB.NET、PLSQL、VBscript、HTML、JavaScript、IFS、VBA、PowerShell、L\ninuxコマンド \n基本設計、内部設計、製造、単体、結合、帳票作成、データ移行、インフラ監視経験。\n","engJapanese":"N1相当(業務会話問題ない、独自で日本人現場作業問題ない、独自日本人との打合せは問題ない) ","engSalaryPrice":35,"engNearestStation":"武蔵小金井（現場出社問題ない） ","engOperationMonth":12,"engOperationDate":1,"engToday":false,"engInterview":"事前調整要","engConcurSituations":"提案のみ","engRemark":"・上流工程のある開発案件希望 \n・真面目、責任感が強い、仕事にやる気満々。 \n・CCNA資格、Oracle12c MASTER Bronze資格取得済み \n・面談時間は事前調整要。 \n"}}