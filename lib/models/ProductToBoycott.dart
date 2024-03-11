import 'package:json_annotation/json_annotation.dart';

part 'ProductToBoycott.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductToBoycott {
  String brandName;
  String? reasonForBoycott;
  String? proof;
  String? alternatives;

  ProductToBoycott(
    this.brandName,
    this.reasonForBoycott,
    this.proof,
    this.alternatives,
  );
  factory ProductToBoycott.fromMap(Map<dynamic, dynamic> map) {
    return ProductToBoycott(
      map['brandName'],
      map['reasonForBoycott'],
      map['proof'],
      map['alternatives'],
    );
  }

  factory ProductToBoycott.fromJson(Map<String, dynamic> srcJson) =>
      _$ProductToBoycottFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ProductToBoycottToJson(this);
}
