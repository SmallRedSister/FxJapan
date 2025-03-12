// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_list_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceListEntity _$DeviceListEntityFromJson(Map<String, dynamic> json) =>
    DeviceListEntity(
      json['itemBg'] as String,
      json['icon'] as String,
      json['boxId'] as String,
      json['ipAdder'] as String,
      json['name'] as String,
      json['state'] as bool,
    );

Map<String, dynamic> _$DeviceListEntityToJson(DeviceListEntity instance) =>
    <String, dynamic>{
      'itemBg': instance.itemBg,
      'icon': instance.icon,
      'boxId': instance.boxId,
      'ipAdder': instance.ipAdder,
      'name': instance.name,
      'state': instance.state,
    };
