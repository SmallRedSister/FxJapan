import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CheckboxListEntity {
  String title;
  bool isChecked;

  CheckboxListEntity(this.title, this.isChecked);
}
