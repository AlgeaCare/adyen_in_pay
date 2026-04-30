// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {

 int get id; String? get pspStatus; String get createdAt; String get updatedAt; String get paymentInvoiceId; int get amount; int get refundAmount; String get status; String get transactionDate; String get type; String? get method; String? get pspNumber; String? get capturePspNumber; int get basketId;@JsonKey(name: 'costCoverage') CostCoverageTransaction? get costCoverage; String? get transferId; int? get transactionId;
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCopyWith<Transaction> get copyWith => _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.pspStatus, pspStatus) || other.pspStatus == pspStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paymentInvoiceId, paymentInvoiceId) || other.paymentInvoiceId == paymentInvoiceId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.method, method) || other.method == method)&&(identical(other.pspNumber, pspNumber) || other.pspNumber == pspNumber)&&(identical(other.capturePspNumber, capturePspNumber) || other.capturePspNumber == capturePspNumber)&&(identical(other.basketId, basketId) || other.basketId == basketId)&&(identical(other.costCoverage, costCoverage) || other.costCoverage == costCoverage)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pspStatus,createdAt,updatedAt,paymentInvoiceId,amount,refundAmount,status,transactionDate,type,method,pspNumber,capturePspNumber,basketId,costCoverage,transferId,transactionId);

@override
String toString() {
  return 'Transaction(id: $id, pspStatus: $pspStatus, createdAt: $createdAt, updatedAt: $updatedAt, paymentInvoiceId: $paymentInvoiceId, amount: $amount, refundAmount: $refundAmount, status: $status, transactionDate: $transactionDate, type: $type, method: $method, pspNumber: $pspNumber, capturePspNumber: $capturePspNumber, basketId: $basketId, costCoverage: $costCoverage, transferId: $transferId, transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res>  {
  factory $TransactionCopyWith(Transaction value, $Res Function(Transaction) _then) = _$TransactionCopyWithImpl;
@useResult
$Res call({
 int id, String? pspStatus, String createdAt, String updatedAt, String paymentInvoiceId, int amount, int refundAmount, String status, String transactionDate, String type, String? method, String? pspNumber, String? capturePspNumber, int basketId,@JsonKey(name: 'costCoverage') CostCoverageTransaction? costCoverage, String? transferId, int? transactionId
});


$CostCoverageTransactionCopyWith<$Res>? get costCoverage;

}
/// @nodoc
class _$TransactionCopyWithImpl<$Res>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pspStatus = freezed,Object? createdAt = null,Object? updatedAt = null,Object? paymentInvoiceId = null,Object? amount = null,Object? refundAmount = null,Object? status = null,Object? transactionDate = null,Object? type = null,Object? method = freezed,Object? pspNumber = freezed,Object? capturePspNumber = freezed,Object? basketId = null,Object? costCoverage = freezed,Object? transferId = freezed,Object? transactionId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,pspStatus: freezed == pspStatus ? _self.pspStatus : pspStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,paymentInvoiceId: null == paymentInvoiceId ? _self.paymentInvoiceId : paymentInvoiceId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,pspNumber: freezed == pspNumber ? _self.pspNumber : pspNumber // ignore: cast_nullable_to_non_nullable
as String?,capturePspNumber: freezed == capturePspNumber ? _self.capturePspNumber : capturePspNumber // ignore: cast_nullable_to_non_nullable
as String?,basketId: null == basketId ? _self.basketId : basketId // ignore: cast_nullable_to_non_nullable
as int,costCoverage: freezed == costCoverage ? _self.costCoverage : costCoverage // ignore: cast_nullable_to_non_nullable
as CostCoverageTransaction?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CostCoverageTransactionCopyWith<$Res>? get costCoverage {
    if (_self.costCoverage == null) {
    return null;
  }

  return $CostCoverageTransactionCopyWith<$Res>(_self.costCoverage!, (value) {
    return _then(_self.copyWith(costCoverage: value));
  });
}
}


/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transaction value)  $default,){
final _that = this;
switch (_that) {
case _Transaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transaction value)?  $default,){
final _that = this;
switch (_that) {
case _Transaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? pspStatus,  String createdAt,  String updatedAt,  String paymentInvoiceId,  int amount,  int refundAmount,  String status,  String transactionDate,  String type,  String? method,  String? pspNumber,  String? capturePspNumber,  int basketId, @JsonKey(name: 'costCoverage')  CostCoverageTransaction? costCoverage,  String? transferId,  int? transactionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.pspStatus,_that.createdAt,_that.updatedAt,_that.paymentInvoiceId,_that.amount,_that.refundAmount,_that.status,_that.transactionDate,_that.type,_that.method,_that.pspNumber,_that.capturePspNumber,_that.basketId,_that.costCoverage,_that.transferId,_that.transactionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? pspStatus,  String createdAt,  String updatedAt,  String paymentInvoiceId,  int amount,  int refundAmount,  String status,  String transactionDate,  String type,  String? method,  String? pspNumber,  String? capturePspNumber,  int basketId, @JsonKey(name: 'costCoverage')  CostCoverageTransaction? costCoverage,  String? transferId,  int? transactionId)  $default,) {final _that = this;
switch (_that) {
case _Transaction():
return $default(_that.id,_that.pspStatus,_that.createdAt,_that.updatedAt,_that.paymentInvoiceId,_that.amount,_that.refundAmount,_that.status,_that.transactionDate,_that.type,_that.method,_that.pspNumber,_that.capturePspNumber,_that.basketId,_that.costCoverage,_that.transferId,_that.transactionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? pspStatus,  String createdAt,  String updatedAt,  String paymentInvoiceId,  int amount,  int refundAmount,  String status,  String transactionDate,  String type,  String? method,  String? pspNumber,  String? capturePspNumber,  int basketId, @JsonKey(name: 'costCoverage')  CostCoverageTransaction? costCoverage,  String? transferId,  int? transactionId)?  $default,) {final _that = this;
switch (_that) {
case _Transaction() when $default != null:
return $default(_that.id,_that.pspStatus,_that.createdAt,_that.updatedAt,_that.paymentInvoiceId,_that.amount,_that.refundAmount,_that.status,_that.transactionDate,_that.type,_that.method,_that.pspNumber,_that.capturePspNumber,_that.basketId,_that.costCoverage,_that.transferId,_that.transactionId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Transaction extends Transaction {
   _Transaction({required this.id, this.pspStatus, required this.createdAt, required this.updatedAt, required this.paymentInvoiceId, required this.amount, required this.refundAmount, required this.status, required this.transactionDate, required this.type, this.method, this.pspNumber, this.capturePspNumber, required this.basketId, @JsonKey(name: 'costCoverage') this.costCoverage, this.transferId, this.transactionId}): super._();
  factory _Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

@override final  int id;
@override final  String? pspStatus;
@override final  String createdAt;
@override final  String updatedAt;
@override final  String paymentInvoiceId;
@override final  int amount;
@override final  int refundAmount;
@override final  String status;
@override final  String transactionDate;
@override final  String type;
@override final  String? method;
@override final  String? pspNumber;
@override final  String? capturePspNumber;
@override final  int basketId;
@override@JsonKey(name: 'costCoverage') final  CostCoverageTransaction? costCoverage;
@override final  String? transferId;
@override final  int? transactionId;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCopyWith<_Transaction> get copyWith => __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transaction&&(identical(other.id, id) || other.id == id)&&(identical(other.pspStatus, pspStatus) || other.pspStatus == pspStatus)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paymentInvoiceId, paymentInvoiceId) || other.paymentInvoiceId == paymentInvoiceId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.refundAmount, refundAmount) || other.refundAmount == refundAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.type, type) || other.type == type)&&(identical(other.method, method) || other.method == method)&&(identical(other.pspNumber, pspNumber) || other.pspNumber == pspNumber)&&(identical(other.capturePspNumber, capturePspNumber) || other.capturePspNumber == capturePspNumber)&&(identical(other.basketId, basketId) || other.basketId == basketId)&&(identical(other.costCoverage, costCoverage) || other.costCoverage == costCoverage)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pspStatus,createdAt,updatedAt,paymentInvoiceId,amount,refundAmount,status,transactionDate,type,method,pspNumber,capturePspNumber,basketId,costCoverage,transferId,transactionId);

@override
String toString() {
  return 'Transaction(id: $id, pspStatus: $pspStatus, createdAt: $createdAt, updatedAt: $updatedAt, paymentInvoiceId: $paymentInvoiceId, amount: $amount, refundAmount: $refundAmount, status: $status, transactionDate: $transactionDate, type: $type, method: $method, pspNumber: $pspNumber, capturePspNumber: $capturePspNumber, basketId: $basketId, costCoverage: $costCoverage, transferId: $transferId, transactionId: $transactionId)';
}


}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res> implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(_Transaction value, $Res Function(_Transaction) _then) = __$TransactionCopyWithImpl;
@override @useResult
$Res call({
 int id, String? pspStatus, String createdAt, String updatedAt, String paymentInvoiceId, int amount, int refundAmount, String status, String transactionDate, String type, String? method, String? pspNumber, String? capturePspNumber, int basketId,@JsonKey(name: 'costCoverage') CostCoverageTransaction? costCoverage, String? transferId, int? transactionId
});


@override $CostCoverageTransactionCopyWith<$Res>? get costCoverage;

}
/// @nodoc
class __$TransactionCopyWithImpl<$Res>
    implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pspStatus = freezed,Object? createdAt = null,Object? updatedAt = null,Object? paymentInvoiceId = null,Object? amount = null,Object? refundAmount = null,Object? status = null,Object? transactionDate = null,Object? type = null,Object? method = freezed,Object? pspNumber = freezed,Object? capturePspNumber = freezed,Object? basketId = null,Object? costCoverage = freezed,Object? transferId = freezed,Object? transactionId = freezed,}) {
  return _then(_Transaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,pspStatus: freezed == pspStatus ? _self.pspStatus : pspStatus // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,paymentInvoiceId: null == paymentInvoiceId ? _self.paymentInvoiceId : paymentInvoiceId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,refundAmount: null == refundAmount ? _self.refundAmount : refundAmount // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String?,pspNumber: freezed == pspNumber ? _self.pspNumber : pspNumber // ignore: cast_nullable_to_non_nullable
as String?,capturePspNumber: freezed == capturePspNumber ? _self.capturePspNumber : capturePspNumber // ignore: cast_nullable_to_non_nullable
as String?,basketId: null == basketId ? _self.basketId : basketId // ignore: cast_nullable_to_non_nullable
as int,costCoverage: freezed == costCoverage ? _self.costCoverage : costCoverage // ignore: cast_nullable_to_non_nullable
as CostCoverageTransaction?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Transaction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CostCoverageTransactionCopyWith<$Res>? get costCoverage {
    if (_self.costCoverage == null) {
    return null;
  }

  return $CostCoverageTransactionCopyWith<$Res>(_self.costCoverage!, (value) {
    return _then(_self.copyWith(costCoverage: value));
  });
}
}


/// @nodoc
mixin _$CostCoverageTransaction {

@JsonKey(name: 'amount') int get discountAmount;@JsonKey(name: 'code') String get code;@JsonKey(name: 'status') String get status;
/// Create a copy of CostCoverageTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CostCoverageTransactionCopyWith<CostCoverageTransaction> get copyWith => _$CostCoverageTransactionCopyWithImpl<CostCoverageTransaction>(this as CostCoverageTransaction, _$identity);

  /// Serializes this CostCoverageTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CostCoverageTransaction&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,discountAmount,code,status);

@override
String toString() {
  return 'CostCoverageTransaction(discountAmount: $discountAmount, code: $code, status: $status)';
}


}

/// @nodoc
abstract mixin class $CostCoverageTransactionCopyWith<$Res>  {
  factory $CostCoverageTransactionCopyWith(CostCoverageTransaction value, $Res Function(CostCoverageTransaction) _then) = _$CostCoverageTransactionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'amount') int discountAmount,@JsonKey(name: 'code') String code,@JsonKey(name: 'status') String status
});




}
/// @nodoc
class _$CostCoverageTransactionCopyWithImpl<$Res>
    implements $CostCoverageTransactionCopyWith<$Res> {
  _$CostCoverageTransactionCopyWithImpl(this._self, this._then);

  final CostCoverageTransaction _self;
  final $Res Function(CostCoverageTransaction) _then;

/// Create a copy of CostCoverageTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? discountAmount = null,Object? code = null,Object? status = null,}) {
  return _then(_self.copyWith(
discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CostCoverageTransaction].
extension CostCoverageTransactionPatterns on CostCoverageTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CostCoverageTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CostCoverageTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CostCoverageTransaction value)  $default,){
final _that = this;
switch (_that) {
case _CostCoverageTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CostCoverageTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _CostCoverageTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'amount')  int discountAmount, @JsonKey(name: 'code')  String code, @JsonKey(name: 'status')  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CostCoverageTransaction() when $default != null:
return $default(_that.discountAmount,_that.code,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'amount')  int discountAmount, @JsonKey(name: 'code')  String code, @JsonKey(name: 'status')  String status)  $default,) {final _that = this;
switch (_that) {
case _CostCoverageTransaction():
return $default(_that.discountAmount,_that.code,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'amount')  int discountAmount, @JsonKey(name: 'code')  String code, @JsonKey(name: 'status')  String status)?  $default,) {final _that = this;
switch (_that) {
case _CostCoverageTransaction() when $default != null:
return $default(_that.discountAmount,_that.code,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CostCoverageTransaction implements CostCoverageTransaction {
   _CostCoverageTransaction({@JsonKey(name: 'amount') required this.discountAmount, @JsonKey(name: 'code') required this.code, @JsonKey(name: 'status') required this.status});
  factory _CostCoverageTransaction.fromJson(Map<String, dynamic> json) => _$CostCoverageTransactionFromJson(json);

@override@JsonKey(name: 'amount') final  int discountAmount;
@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'status') final  String status;

/// Create a copy of CostCoverageTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CostCoverageTransactionCopyWith<_CostCoverageTransaction> get copyWith => __$CostCoverageTransactionCopyWithImpl<_CostCoverageTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CostCoverageTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CostCoverageTransaction&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.code, code) || other.code == code)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,discountAmount,code,status);

@override
String toString() {
  return 'CostCoverageTransaction(discountAmount: $discountAmount, code: $code, status: $status)';
}


}

/// @nodoc
abstract mixin class _$CostCoverageTransactionCopyWith<$Res> implements $CostCoverageTransactionCopyWith<$Res> {
  factory _$CostCoverageTransactionCopyWith(_CostCoverageTransaction value, $Res Function(_CostCoverageTransaction) _then) = __$CostCoverageTransactionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'amount') int discountAmount,@JsonKey(name: 'code') String code,@JsonKey(name: 'status') String status
});




}
/// @nodoc
class __$CostCoverageTransactionCopyWithImpl<$Res>
    implements _$CostCoverageTransactionCopyWith<$Res> {
  __$CostCoverageTransactionCopyWithImpl(this._self, this._then);

  final _CostCoverageTransaction _self;
  final $Res Function(_CostCoverageTransaction) _then;

/// Create a copy of CostCoverageTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? discountAmount = null,Object? code = null,Object? status = null,}) {
  return _then(_CostCoverageTransaction(
discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
