// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payments_page_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentsPageResponse {

 List<PaymentInformation> get payments; int get count; int get page;
/// Create a copy of PaymentsPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentsPageResponseCopyWith<PaymentsPageResponse> get copyWith => _$PaymentsPageResponseCopyWithImpl<PaymentsPageResponse>(this as PaymentsPageResponse, _$identity);

  /// Serializes this PaymentsPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentsPageResponse&&const DeepCollectionEquality().equals(other.payments, payments)&&(identical(other.count, count) || other.count == count)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(payments),count,page);

@override
String toString() {
  return 'PaymentsPageResponse(payments: $payments, count: $count, page: $page)';
}


}

/// @nodoc
abstract mixin class $PaymentsPageResponseCopyWith<$Res>  {
  factory $PaymentsPageResponseCopyWith(PaymentsPageResponse value, $Res Function(PaymentsPageResponse) _then) = _$PaymentsPageResponseCopyWithImpl;
@useResult
$Res call({
 List<PaymentInformation> payments, int count, int page
});




}
/// @nodoc
class _$PaymentsPageResponseCopyWithImpl<$Res>
    implements $PaymentsPageResponseCopyWith<$Res> {
  _$PaymentsPageResponseCopyWithImpl(this._self, this._then);

  final PaymentsPageResponse _self;
  final $Res Function(PaymentsPageResponse) _then;

/// Create a copy of PaymentsPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? payments = null,Object? count = null,Object? page = null,}) {
  return _then(_self.copyWith(
payments: null == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as List<PaymentInformation>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentsPageResponse].
extension PaymentsPageResponsePatterns on PaymentsPageResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentsPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentsPageResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentsPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaymentsPageResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentsPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentsPageResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PaymentInformation> payments,  int count,  int page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentsPageResponse() when $default != null:
return $default(_that.payments,_that.count,_that.page);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PaymentInformation> payments,  int count,  int page)  $default,) {final _that = this;
switch (_that) {
case _PaymentsPageResponse():
return $default(_that.payments,_that.count,_that.page);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PaymentInformation> payments,  int count,  int page)?  $default,) {final _that = this;
switch (_that) {
case _PaymentsPageResponse() when $default != null:
return $default(_that.payments,_that.count,_that.page);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentsPageResponse implements PaymentsPageResponse {
   _PaymentsPageResponse({required final  List<PaymentInformation> payments, required this.count, required this.page}): _payments = payments;
  factory _PaymentsPageResponse.fromJson(Map<String, dynamic> json) => _$PaymentsPageResponseFromJson(json);

 final  List<PaymentInformation> _payments;
@override List<PaymentInformation> get payments {
  if (_payments is EqualUnmodifiableListView) return _payments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payments);
}

@override final  int count;
@override final  int page;

/// Create a copy of PaymentsPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentsPageResponseCopyWith<_PaymentsPageResponse> get copyWith => __$PaymentsPageResponseCopyWithImpl<_PaymentsPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentsPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentsPageResponse&&const DeepCollectionEquality().equals(other._payments, _payments)&&(identical(other.count, count) || other.count == count)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_payments),count,page);

@override
String toString() {
  return 'PaymentsPageResponse(payments: $payments, count: $count, page: $page)';
}


}

/// @nodoc
abstract mixin class _$PaymentsPageResponseCopyWith<$Res> implements $PaymentsPageResponseCopyWith<$Res> {
  factory _$PaymentsPageResponseCopyWith(_PaymentsPageResponse value, $Res Function(_PaymentsPageResponse) _then) = __$PaymentsPageResponseCopyWithImpl;
@override @useResult
$Res call({
 List<PaymentInformation> payments, int count, int page
});




}
/// @nodoc
class __$PaymentsPageResponseCopyWithImpl<$Res>
    implements _$PaymentsPageResponseCopyWith<$Res> {
  __$PaymentsPageResponseCopyWithImpl(this._self, this._then);

  final _PaymentsPageResponse _self;
  final $Res Function(_PaymentsPageResponse) _then;

/// Create a copy of PaymentsPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? payments = null,Object? count = null,Object? page = null,}) {
  return _then(_PaymentsPageResponse(
payments: null == payments ? _self._payments : payments // ignore: cast_nullable_to_non_nullable
as List<PaymentInformation>,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
