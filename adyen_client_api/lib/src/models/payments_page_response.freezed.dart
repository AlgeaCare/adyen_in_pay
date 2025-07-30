// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_page_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentsPageResponse _$PaymentsPageResponseFromJson(Map<String, dynamic> json) {
  return _PaymentsPageResponse.fromJson(json);
}

/// @nodoc
mixin _$PaymentsPageResponse {
  List<PaymentInformation> get payments => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;

  /// Serializes this PaymentsPageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentsPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentsPageResponseCopyWith<PaymentsPageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentsPageResponseCopyWith<$Res> {
  factory $PaymentsPageResponseCopyWith(
    PaymentsPageResponse value,
    $Res Function(PaymentsPageResponse) then,
  ) = _$PaymentsPageResponseCopyWithImpl<$Res, PaymentsPageResponse>;
  @useResult
  $Res call({List<PaymentInformation> payments, int count, int page});
}

/// @nodoc
class _$PaymentsPageResponseCopyWithImpl<
  $Res,
  $Val extends PaymentsPageResponse
>
    implements $PaymentsPageResponseCopyWith<$Res> {
  _$PaymentsPageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentsPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payments = null,
    Object? count = null,
    Object? page = null,
  }) {
    return _then(
      _value.copyWith(
            payments: null == payments
                ? _value.payments
                : payments // ignore: cast_nullable_to_non_nullable
                      as List<PaymentInformation>,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentsPageResponseImplCopyWith<$Res>
    implements $PaymentsPageResponseCopyWith<$Res> {
  factory _$$PaymentsPageResponseImplCopyWith(
    _$PaymentsPageResponseImpl value,
    $Res Function(_$PaymentsPageResponseImpl) then,
  ) = __$$PaymentsPageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PaymentInformation> payments, int count, int page});
}

/// @nodoc
class __$$PaymentsPageResponseImplCopyWithImpl<$Res>
    extends _$PaymentsPageResponseCopyWithImpl<$Res, _$PaymentsPageResponseImpl>
    implements _$$PaymentsPageResponseImplCopyWith<$Res> {
  __$$PaymentsPageResponseImplCopyWithImpl(
    _$PaymentsPageResponseImpl _value,
    $Res Function(_$PaymentsPageResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentsPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? payments = null,
    Object? count = null,
    Object? page = null,
  }) {
    return _then(
      _$PaymentsPageResponseImpl(
        payments: null == payments
            ? _value._payments
            : payments // ignore: cast_nullable_to_non_nullable
                  as List<PaymentInformation>,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentsPageResponseImpl implements _PaymentsPageResponse {
  _$PaymentsPageResponseImpl({
    required final List<PaymentInformation> payments,
    required this.count,
    required this.page,
  }) : _payments = payments;

  factory _$PaymentsPageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentsPageResponseImplFromJson(json);

  final List<PaymentInformation> _payments;
  @override
  List<PaymentInformation> get payments {
    if (_payments is EqualUnmodifiableListView) return _payments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_payments);
  }

  @override
  final int count;
  @override
  final int page;

  @override
  String toString() {
    return 'PaymentsPageResponse(payments: $payments, count: $count, page: $page)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentsPageResponseImpl &&
            const DeepCollectionEquality().equals(other._payments, _payments) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.page, page) || other.page == page));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_payments),
    count,
    page,
  );

  /// Create a copy of PaymentsPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentsPageResponseImplCopyWith<_$PaymentsPageResponseImpl>
  get copyWith =>
      __$$PaymentsPageResponseImplCopyWithImpl<_$PaymentsPageResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentsPageResponseImplToJson(this);
  }
}

abstract class _PaymentsPageResponse implements PaymentsPageResponse {
  factory _PaymentsPageResponse({
    required final List<PaymentInformation> payments,
    required final int count,
    required final int page,
  }) = _$PaymentsPageResponseImpl;

  factory _PaymentsPageResponse.fromJson(Map<String, dynamic> json) =
      _$PaymentsPageResponseImpl.fromJson;

  @override
  List<PaymentInformation> get payments;
  @override
  int get count;
  @override
  int get page;

  /// Create a copy of PaymentsPageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentsPageResponseImplCopyWith<_$PaymentsPageResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
