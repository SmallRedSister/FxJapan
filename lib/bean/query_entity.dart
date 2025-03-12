import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class QueryEntity {
  String engName;
  String engCountry;
  String engUserAge;
  String engGender;
  String engEmpiricYear;
  String engEmpiricMonth;
  String engSkill;
  String engJapanese;
  String engSalaryPrice;
  String engNearestStation;
  String engOperationMonth;
  String engOperationDate;
  bool engToday;
  String engInterview;
  String engConcurSituations;
  String engRemark;

  QueryEntity(
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
}
