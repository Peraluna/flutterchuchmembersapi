import 'package:json_annotation/json_annotation.dart';

part 'DomainModel.g.dart';

@JsonSerializable()
class DomainModel {
  DomainModel({
    this.id,
    this.url,
    this.domainName,
  });
  @JsonKey(name: '_id', includeIfNull: false)
  String id;
  String url;
  String domainName;

  factory DomainModel.fromJson(Map<String, dynamic> json) =>
      _$DomainModelFromJson(json);

  Map<String, dynamic> toJson() => _$DomainModelToJson(this);

  //DomainModel copy(DomainModel fromDomain) => _$DomainModelCopy(this);
  DomainModel copy() {
    //var copiedDomain = new Map.from(this.toJson());
    var _copiedDomain =
        _$DomainModelFromJson(this.toJson());
    return _copiedDomain;
  }

  var jsonMock = [
    {
      "_id": "generic",
      "url": "http://10.0.3.2/churchapi",
      "domainName": "generic"
    },
    {
      "_id": "gmahk_ranotana",
      "url": "http://10.0.3.2/churchapi",
      "domainName": "GMAHK RANOTANA"
    }
  ];
}

// flutter packages pub run build_runner build --delete-conflicting-outputs
