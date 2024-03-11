// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductToBoycott.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductToBoycott _$ProductToBoycottFromJson(Map<String, dynamic> json) =>
    ProductToBoycott(
      json['brandName'] as String,
      json['reasonForBoycott'] as String?,
      json['proof'] as String?,
      json['alternatives'] as String?,
    );

Map<String, dynamic> _$ProductToBoycottToJson(ProductToBoycott instance) =>
    <String, dynamic>{
      'brandName': instance.brandName,
      'reasonForBoycott': instance.reasonForBoycott,
      'proof': instance.proof,
      'alternatives': instance.alternatives,
    };
