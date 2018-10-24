// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DomainModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomainModel _$DomainModelFromJson(Map<String, dynamic> json) {
  return DomainModel(
      id: json['_id'] as String,
      url: json['url'] as String,
      domainName: json['domainName'] as String)
    ..jsonMock = (json['jsonMock'] as List)
        ?.map((e) => (e as Map<String, dynamic>)
            ?.map((k, e) => MapEntry(k, e as String)))
        ?.toList();
}

Map<String, dynamic> _$DomainModelToJson(DomainModel instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['url'] = instance.url;
  val['domainName'] = instance.domainName;
  val['jsonMock'] = instance.jsonMock;
  return val;
}
