// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payments_page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentsPageResponseImpl _$$PaymentsPageResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentsPageResponseImpl(
  payments:
      (json['payments'] as List<dynamic>)
          .map((e) => PaymentInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
  count: (json['count'] as num).toInt(),
  page: (json['page'] as num).toInt(),
);

Map<String, dynamic> _$$PaymentsPageResponseImplToJson(
  _$PaymentsPageResponseImpl instance,
) => <String, dynamic>{
  'payments': instance.payments,
  'count': instance.count,
  'page': instance.page,
};
