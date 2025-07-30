// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  int get id => throw _privateConstructorUsedError;
  String? get pspStatus => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;
  String get paymentInvoiceId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get refundAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get transactionDate => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get method => throw _privateConstructorUsedError;
  String? get pspNumber => throw _privateConstructorUsedError;
  String? get capturePspNumber => throw _privateConstructorUsedError;
  int get basketId => throw _privateConstructorUsedError;
  int? get transferId => throw _privateConstructorUsedError;
  int? get transactionId => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) then,
  ) = _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call({
    int id,
    String? pspStatus,
    String createdAt,
    String updatedAt,
    String paymentInvoiceId,
    int amount,
    int refundAmount,
    String status,
    String transactionDate,
    String type,
    String? method,
    String? pspNumber,
    String? capturePspNumber,
    int basketId,
    int? transferId,
    int? transactionId,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pspStatus = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? paymentInvoiceId = null,
    Object? amount = null,
    Object? refundAmount = null,
    Object? status = null,
    Object? transactionDate = null,
    Object? type = null,
    Object? method = freezed,
    Object? pspNumber = freezed,
    Object? capturePspNumber = freezed,
    Object? basketId = null,
    Object? transferId = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            pspStatus: freezed == pspStatus
                ? _value.pspStatus
                : pspStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentInvoiceId: null == paymentInvoiceId
                ? _value.paymentInvoiceId
                : paymentInvoiceId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            refundAmount: null == refundAmount
                ? _value.refundAmount
                : refundAmount // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            transactionDate: null == transactionDate
                ? _value.transactionDate
                : transactionDate // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            method: freezed == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String?,
            pspNumber: freezed == pspNumber
                ? _value.pspNumber
                : pspNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            capturePspNumber: freezed == capturePspNumber
                ? _value.capturePspNumber
                : capturePspNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            basketId: null == basketId
                ? _value.basketId
                : basketId // ignore: cast_nullable_to_non_nullable
                      as int,
            transferId: freezed == transferId
                ? _value.transferId
                : transferId // ignore: cast_nullable_to_non_nullable
                      as int?,
            transactionId: freezed == transactionId
                ? _value.transactionId
                : transactionId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
    _$TransactionImpl value,
    $Res Function(_$TransactionImpl) then,
  ) = __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String? pspStatus,
    String createdAt,
    String updatedAt,
    String paymentInvoiceId,
    int amount,
    int refundAmount,
    String status,
    String transactionDate,
    String type,
    String? method,
    String? pspNumber,
    String? capturePspNumber,
    int basketId,
    int? transferId,
    int? transactionId,
  });
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
    _$TransactionImpl _value,
    $Res Function(_$TransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pspStatus = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? paymentInvoiceId = null,
    Object? amount = null,
    Object? refundAmount = null,
    Object? status = null,
    Object? transactionDate = null,
    Object? type = null,
    Object? method = freezed,
    Object? pspNumber = freezed,
    Object? capturePspNumber = freezed,
    Object? basketId = null,
    Object? transferId = freezed,
    Object? transactionId = freezed,
  }) {
    return _then(
      _$TransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        pspStatus: freezed == pspStatus
            ? _value.pspStatus
            : pspStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentInvoiceId: null == paymentInvoiceId
            ? _value.paymentInvoiceId
            : paymentInvoiceId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        refundAmount: null == refundAmount
            ? _value.refundAmount
            : refundAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionDate: null == transactionDate
            ? _value.transactionDate
            : transactionDate // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        method: freezed == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String?,
        pspNumber: freezed == pspNumber
            ? _value.pspNumber
            : pspNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        capturePspNumber: freezed == capturePspNumber
            ? _value.capturePspNumber
            : capturePspNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        basketId: null == basketId
            ? _value.basketId
            : basketId // ignore: cast_nullable_to_non_nullable
                  as int,
        transferId: freezed == transferId
            ? _value.transferId
            : transferId // ignore: cast_nullable_to_non_nullable
                  as int?,
        transactionId: freezed == transactionId
            ? _value.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TransactionImpl extends _Transaction {
  _$TransactionImpl({
    required this.id,
    this.pspStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentInvoiceId,
    required this.amount,
    required this.refundAmount,
    required this.status,
    required this.transactionDate,
    required this.type,
    this.method,
    this.pspNumber,
    this.capturePspNumber,
    required this.basketId,
    this.transferId,
    this.transactionId,
  }) : super._();

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final int id;
  @override
  final String? pspStatus;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String paymentInvoiceId;
  @override
  final int amount;
  @override
  final int refundAmount;
  @override
  final String status;
  @override
  final String transactionDate;
  @override
  final String type;
  @override
  final String? method;
  @override
  final String? pspNumber;
  @override
  final String? capturePspNumber;
  @override
  final int basketId;
  @override
  final int? transferId;
  @override
  final int? transactionId;

  @override
  String toString() {
    return 'Transaction(id: $id, pspStatus: $pspStatus, createdAt: $createdAt, updatedAt: $updatedAt, paymentInvoiceId: $paymentInvoiceId, amount: $amount, refundAmount: $refundAmount, status: $status, transactionDate: $transactionDate, type: $type, method: $method, pspNumber: $pspNumber, capturePspNumber: $capturePspNumber, basketId: $basketId, transferId: $transferId, transactionId: $transactionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pspStatus, pspStatus) ||
                other.pspStatus == pspStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.paymentInvoiceId, paymentInvoiceId) ||
                other.paymentInvoiceId == paymentInvoiceId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.refundAmount, refundAmount) ||
                other.refundAmount == refundAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.pspNumber, pspNumber) ||
                other.pspNumber == pspNumber) &&
            (identical(other.capturePspNumber, capturePspNumber) ||
                other.capturePspNumber == capturePspNumber) &&
            (identical(other.basketId, basketId) ||
                other.basketId == basketId) &&
            (identical(other.transferId, transferId) ||
                other.transferId == transferId) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pspStatus,
    createdAt,
    updatedAt,
    paymentInvoiceId,
    amount,
    refundAmount,
    status,
    transactionDate,
    type,
    method,
    pspNumber,
    capturePspNumber,
    basketId,
    transferId,
    transactionId,
  );

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(this);
  }
}

abstract class _Transaction extends Transaction {
  factory _Transaction({
    required final int id,
    final String? pspStatus,
    required final String createdAt,
    required final String updatedAt,
    required final String paymentInvoiceId,
    required final int amount,
    required final int refundAmount,
    required final String status,
    required final String transactionDate,
    required final String type,
    final String? method,
    final String? pspNumber,
    final String? capturePspNumber,
    required final int basketId,
    final int? transferId,
    final int? transactionId,
  }) = _$TransactionImpl;
  _Transaction._() : super._();

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  int get id;
  @override
  String? get pspStatus;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  String get paymentInvoiceId;
  @override
  int get amount;
  @override
  int get refundAmount;
  @override
  String get status;
  @override
  String get transactionDate;
  @override
  String get type;
  @override
  String? get method;
  @override
  String? get pspNumber;
  @override
  String? get capturePspNumber;
  @override
  int get basketId;
  @override
  int? get transferId;
  @override
  int? get transactionId;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
