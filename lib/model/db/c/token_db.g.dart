// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_db.dart';

// ignore_for_file: type=lint
class $GptTokensTable extends GptTokens
    with TableInfo<$GptTokensTable, GptToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GptTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _isUsingMeta =
      const VerificationMeta('isUsing');
  @override
  late final GeneratedColumn<bool> isUsing =
      GeneratedColumn<bool>('is_using', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_using" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _addDateMeta =
      const VerificationMeta('addDate');
  @override
  late final GeneratedColumn<DateTime> addDate = GeneratedColumn<DateTime>(
      'add_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _refreshDateMeta =
      const VerificationMeta('refreshDate');
  @override
  late final GeneratedColumn<DateTime> refreshDate = GeneratedColumn<DateTime>(
      'refresh_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, isUsing, status, addDate, refreshDate, token];
  @override
  String get aliasedName => _alias ?? 'gpt_tokens';
  @override
  String get actualTableName => 'gpt_tokens';
  @override
  VerificationContext validateIntegrity(Insertable<GptToken> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_using')) {
      context.handle(_isUsingMeta,
          isUsing.isAcceptableOrUnknown(data['is_using']!, _isUsingMeta));
    } else if (isInserting) {
      context.missing(_isUsingMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('add_date')) {
      context.handle(_addDateMeta,
          addDate.isAcceptableOrUnknown(data['add_date']!, _addDateMeta));
    } else if (isInserting) {
      context.missing(_addDateMeta);
    }
    if (data.containsKey('refresh_date')) {
      context.handle(
          _refreshDateMeta,
          refreshDate.isAcceptableOrUnknown(
              data['refresh_date']!, _refreshDateMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GptToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GptToken(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      isUsing: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_using'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      addDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}add_date'])!,
      refreshDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}refresh_date']),
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token'])!,
    );
  }

  @override
  $GptTokensTable createAlias(String alias) {
    return $GptTokensTable(attachedDatabase, alias);
  }
}

class GptToken extends DataClass implements Insertable<GptToken> {
  final int id;
  final bool isUsing;
  final int status;
  final DateTime addDate;
  final DateTime? refreshDate;
  final String token;
  const GptToken(
      {required this.id,
      required this.isUsing,
      required this.status,
      required this.addDate,
      this.refreshDate,
      required this.token});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_using'] = Variable<bool>(isUsing);
    map['status'] = Variable<int>(status);
    map['add_date'] = Variable<DateTime>(addDate);
    if (!nullToAbsent || refreshDate != null) {
      map['refresh_date'] = Variable<DateTime>(refreshDate);
    }
    map['token'] = Variable<String>(token);
    return map;
  }

  GptTokensCompanion toCompanion(bool nullToAbsent) {
    return GptTokensCompanion(
      id: Value(id),
      isUsing: Value(isUsing),
      status: Value(status),
      addDate: Value(addDate),
      refreshDate: refreshDate == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshDate),
      token: Value(token),
    );
  }

  factory GptToken.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GptToken(
      id: serializer.fromJson<int>(json['id']),
      isUsing: serializer.fromJson<bool>(json['isUsing']),
      status: serializer.fromJson<int>(json['status']),
      addDate: serializer.fromJson<DateTime>(json['addDate']),
      refreshDate: serializer.fromJson<DateTime?>(json['refreshDate']),
      token: serializer.fromJson<String>(json['token']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isUsing': serializer.toJson<bool>(isUsing),
      'status': serializer.toJson<int>(status),
      'addDate': serializer.toJson<DateTime>(addDate),
      'refreshDate': serializer.toJson<DateTime?>(refreshDate),
      'token': serializer.toJson<String>(token),
    };
  }

  GptToken copyWith(
          {int? id,
          bool? isUsing,
          int? status,
          DateTime? addDate,
          Value<DateTime?> refreshDate = const Value.absent(),
          String? token}) =>
      GptToken(
        id: id ?? this.id,
        isUsing: isUsing ?? this.isUsing,
        status: status ?? this.status,
        addDate: addDate ?? this.addDate,
        refreshDate: refreshDate.present ? refreshDate.value : this.refreshDate,
        token: token ?? this.token,
      );
  @override
  String toString() {
    return (StringBuffer('GptToken(')
          ..write('id: $id, ')
          ..write('isUsing: $isUsing, ')
          ..write('status: $status, ')
          ..write('addDate: $addDate, ')
          ..write('refreshDate: $refreshDate, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, isUsing, status, addDate, refreshDate, token);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GptToken &&
          other.id == this.id &&
          other.isUsing == this.isUsing &&
          other.status == this.status &&
          other.addDate == this.addDate &&
          other.refreshDate == this.refreshDate &&
          other.token == this.token);
}

class GptTokensCompanion extends UpdateCompanion<GptToken> {
  final Value<int> id;
  final Value<bool> isUsing;
  final Value<int> status;
  final Value<DateTime> addDate;
  final Value<DateTime?> refreshDate;
  final Value<String> token;
  const GptTokensCompanion({
    this.id = const Value.absent(),
    this.isUsing = const Value.absent(),
    this.status = const Value.absent(),
    this.addDate = const Value.absent(),
    this.refreshDate = const Value.absent(),
    this.token = const Value.absent(),
  });
  GptTokensCompanion.insert({
    this.id = const Value.absent(),
    required bool isUsing,
    required int status,
    required DateTime addDate,
    this.refreshDate = const Value.absent(),
    required String token,
  })  : isUsing = Value(isUsing),
        status = Value(status),
        addDate = Value(addDate),
        token = Value(token);
  static Insertable<GptToken> custom({
    Expression<int>? id,
    Expression<bool>? isUsing,
    Expression<int>? status,
    Expression<DateTime>? addDate,
    Expression<DateTime>? refreshDate,
    Expression<String>? token,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isUsing != null) 'is_using': isUsing,
      if (status != null) 'status': status,
      if (addDate != null) 'add_date': addDate,
      if (refreshDate != null) 'refresh_date': refreshDate,
      if (token != null) 'token': token,
    });
  }

  GptTokensCompanion copyWith(
      {Value<int>? id,
      Value<bool>? isUsing,
      Value<int>? status,
      Value<DateTime>? addDate,
      Value<DateTime?>? refreshDate,
      Value<String>? token}) {
    return GptTokensCompanion(
      id: id ?? this.id,
      isUsing: isUsing ?? this.isUsing,
      status: status ?? this.status,
      addDate: addDate ?? this.addDate,
      refreshDate: refreshDate ?? this.refreshDate,
      token: token ?? this.token,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isUsing.present) {
      map['is_using'] = Variable<bool>(isUsing.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (addDate.present) {
      map['add_date'] = Variable<DateTime>(addDate.value);
    }
    if (refreshDate.present) {
      map['refresh_date'] = Variable<DateTime>(refreshDate.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GptTokensCompanion(')
          ..write('id: $id, ')
          ..write('isUsing: $isUsing, ')
          ..write('status: $status, ')
          ..write('addDate: $addDate, ')
          ..write('refreshDate: $refreshDate, ')
          ..write('token: $token')
          ..write(')'))
        .toString();
  }
}

abstract class _$TokenDatabase extends GeneratedDatabase {
  _$TokenDatabase(QueryExecutor e) : super(e);
  late final $GptTokensTable gptTokens = $GptTokensTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [gptTokens];
}
