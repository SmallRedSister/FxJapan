import 'package:json_annotation/json_annotation.dart';

part 'device_list_entity.g.dart';

@JsonSerializable()
class DeviceListEntity {
  String itemBg;
  String icon;
  String boxId;
  String ipAdder;
  String name;
  bool state;

  DeviceListEntity(this.itemBg, this.icon, this.boxId, this.ipAdder, this.name, this.state);

  factory DeviceListEntity.fromJson(Map<String, dynamic> json) =>
      _$DeviceListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceListEntityToJson(this);

}
