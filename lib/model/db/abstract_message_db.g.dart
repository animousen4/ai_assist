// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abstract_message_db.dart';

// ignore_for_file: type=lint
class $ChatsTable extends Chats with TableInfo<$ChatsTable, Chat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _chatStatusMeta =
      const VerificationMeta('chatStatus');
  @override
  late final GeneratedColumn<int> chatStatus = GeneratedColumn<int>(
      'chat_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chatTypeMeta =
      const VerificationMeta('chatType');
  @override
  late final GeneratedColumn<int> chatType = GeneratedColumn<int>(
      'chat_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _chatNameMeta =
      const VerificationMeta('chatName');
  @override
  late final GeneratedColumn<String> chatName = GeneratedColumn<String>(
      'chat_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creationDateMeta =
      const VerificationMeta('creationDate');
  @override
  late final GeneratedColumn<DateTime> creationDate = GeneratedColumn<DateTime>(
      'creation_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _closeDateMeta =
      const VerificationMeta('closeDate');
  @override
  late final GeneratedColumn<DateTime> closeDate = GeneratedColumn<DateTime>(
      'close_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [chatId, chatStatus, chatType, chatName, creationDate, closeDate];
  @override
  String get aliasedName => _alias ?? 'chats';
  @override
  String get actualTableName => 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<Chat> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    }
    if (data.containsKey('chat_status')) {
      context.handle(
          _chatStatusMeta,
          chatStatus.isAcceptableOrUnknown(
              data['chat_status']!, _chatStatusMeta));
    } else if (isInserting) {
      context.missing(_chatStatusMeta);
    }
    if (data.containsKey('chat_type')) {
      context.handle(_chatTypeMeta,
          chatType.isAcceptableOrUnknown(data['chat_type']!, _chatTypeMeta));
    } else if (isInserting) {
      context.missing(_chatTypeMeta);
    }
    if (data.containsKey('chat_name')) {
      context.handle(_chatNameMeta,
          chatName.isAcceptableOrUnknown(data['chat_name']!, _chatNameMeta));
    } else if (isInserting) {
      context.missing(_chatNameMeta);
    }
    if (data.containsKey('creation_date')) {
      context.handle(
          _creationDateMeta,
          creationDate.isAcceptableOrUnknown(
              data['creation_date']!, _creationDateMeta));
    } else if (isInserting) {
      context.missing(_creationDateMeta);
    }
    if (data.containsKey('close_date')) {
      context.handle(_closeDateMeta,
          closeDate.isAcceptableOrUnknown(data['close_date']!, _closeDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {chatId};
  @override
  Chat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chat(
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      chatStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_status'])!,
      chatType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_type'])!,
      chatName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chat_name'])!,
      creationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_date'])!,
      closeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}close_date']),
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class Chat extends DataClass implements Insertable<Chat> {
  final int chatId;
  final int chatStatus;
  final int chatType;
  final String chatName;
  final DateTime creationDate;
  final DateTime? closeDate;
  const Chat(
      {required this.chatId,
      required this.chatStatus,
      required this.chatType,
      required this.chatName,
      required this.creationDate,
      this.closeDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['chat_id'] = Variable<int>(chatId);
    map['chat_status'] = Variable<int>(chatStatus);
    map['chat_type'] = Variable<int>(chatType);
    map['chat_name'] = Variable<String>(chatName);
    map['creation_date'] = Variable<DateTime>(creationDate);
    if (!nullToAbsent || closeDate != null) {
      map['close_date'] = Variable<DateTime>(closeDate);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      chatId: Value(chatId),
      chatStatus: Value(chatStatus),
      chatType: Value(chatType),
      chatName: Value(chatName),
      creationDate: Value(creationDate),
      closeDate: closeDate == null && nullToAbsent
          ? const Value.absent()
          : Value(closeDate),
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chat(
      chatId: serializer.fromJson<int>(json['chatId']),
      chatStatus: serializer.fromJson<int>(json['chatStatus']),
      chatType: serializer.fromJson<int>(json['chatType']),
      chatName: serializer.fromJson<String>(json['chatName']),
      creationDate: serializer.fromJson<DateTime>(json['creationDate']),
      closeDate: serializer.fromJson<DateTime?>(json['closeDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'chatId': serializer.toJson<int>(chatId),
      'chatStatus': serializer.toJson<int>(chatStatus),
      'chatType': serializer.toJson<int>(chatType),
      'chatName': serializer.toJson<String>(chatName),
      'creationDate': serializer.toJson<DateTime>(creationDate),
      'closeDate': serializer.toJson<DateTime?>(closeDate),
    };
  }

  Chat copyWith(
          {int? chatId,
          int? chatStatus,
          int? chatType,
          String? chatName,
          DateTime? creationDate,
          Value<DateTime?> closeDate = const Value.absent()}) =>
      Chat(
        chatId: chatId ?? this.chatId,
        chatStatus: chatStatus ?? this.chatStatus,
        chatType: chatType ?? this.chatType,
        chatName: chatName ?? this.chatName,
        creationDate: creationDate ?? this.creationDate,
        closeDate: closeDate.present ? closeDate.value : this.closeDate,
      );
  @override
  String toString() {
    return (StringBuffer('Chat(')
          ..write('chatId: $chatId, ')
          ..write('chatStatus: $chatStatus, ')
          ..write('chatType: $chatType, ')
          ..write('chatName: $chatName, ')
          ..write('creationDate: $creationDate, ')
          ..write('closeDate: $closeDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      chatId, chatStatus, chatType, chatName, creationDate, closeDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chat &&
          other.chatId == this.chatId &&
          other.chatStatus == this.chatStatus &&
          other.chatType == this.chatType &&
          other.chatName == this.chatName &&
          other.creationDate == this.creationDate &&
          other.closeDate == this.closeDate);
}

class ChatsCompanion extends UpdateCompanion<Chat> {
  final Value<int> chatId;
  final Value<int> chatStatus;
  final Value<int> chatType;
  final Value<String> chatName;
  final Value<DateTime> creationDate;
  final Value<DateTime?> closeDate;
  const ChatsCompanion({
    this.chatId = const Value.absent(),
    this.chatStatus = const Value.absent(),
    this.chatType = const Value.absent(),
    this.chatName = const Value.absent(),
    this.creationDate = const Value.absent(),
    this.closeDate = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.chatId = const Value.absent(),
    required int chatStatus,
    required int chatType,
    required String chatName,
    required DateTime creationDate,
    this.closeDate = const Value.absent(),
  })  : chatStatus = Value(chatStatus),
        chatType = Value(chatType),
        chatName = Value(chatName),
        creationDate = Value(creationDate);
  static Insertable<Chat> custom({
    Expression<int>? chatId,
    Expression<int>? chatStatus,
    Expression<int>? chatType,
    Expression<String>? chatName,
    Expression<DateTime>? creationDate,
    Expression<DateTime>? closeDate,
  }) {
    return RawValuesInsertable({
      if (chatId != null) 'chat_id': chatId,
      if (chatStatus != null) 'chat_status': chatStatus,
      if (chatType != null) 'chat_type': chatType,
      if (chatName != null) 'chat_name': chatName,
      if (creationDate != null) 'creation_date': creationDate,
      if (closeDate != null) 'close_date': closeDate,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? chatId,
      Value<int>? chatStatus,
      Value<int>? chatType,
      Value<String>? chatName,
      Value<DateTime>? creationDate,
      Value<DateTime?>? closeDate}) {
    return ChatsCompanion(
      chatId: chatId ?? this.chatId,
      chatStatus: chatStatus ?? this.chatStatus,
      chatType: chatType ?? this.chatType,
      chatName: chatName ?? this.chatName,
      creationDate: creationDate ?? this.creationDate,
      closeDate: closeDate ?? this.closeDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (chatStatus.present) {
      map['chat_status'] = Variable<int>(chatStatus.value);
    }
    if (chatType.present) {
      map['chat_type'] = Variable<int>(chatType.value);
    }
    if (chatName.present) {
      map['chat_name'] = Variable<String>(chatName.value);
    }
    if (creationDate.present) {
      map['creation_date'] = Variable<DateTime>(creationDate.value);
    }
    if (closeDate.present) {
      map['close_date'] = Variable<DateTime>(closeDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('chatId: $chatId, ')
          ..write('chatStatus: $chatStatus, ')
          ..write('chatType: $chatType, ')
          ..write('chatName: $chatName, ')
          ..write('creationDate: $creationDate, ')
          ..write('closeDate: $closeDate')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES chats (chat_id)'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> data = GeneratedColumn<DateTime>(
      'data', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, chatId, data, role, content];
  @override
  String get aliasedName => _alias ?? 'messages';
  @override
  String get actualTableName => 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}data'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final int chatId;
  final DateTime data;
  final String role;
  final String content;
  const Message(
      {required this.id,
      required this.chatId,
      required this.data,
      required this.role,
      required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    map['data'] = Variable<DateTime>(data);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      data: Value(data),
      role: Value(role),
      content: Value(content),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      data: serializer.fromJson<DateTime>(json['data']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'data': serializer.toJson<DateTime>(data),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
    };
  }

  Message copyWith(
          {int? id,
          int? chatId,
          DateTime? data,
          String? role,
          String? content}) =>
      Message(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        data: data ?? this.data,
        role: role ?? this.role,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('data: $data, ')
          ..write('role: $role, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatId, data, role, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.data == this.data &&
          other.role == this.role &&
          other.content == this.content);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<DateTime> data;
  final Value<String> role;
  final Value<String> content;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.data = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    required DateTime data,
    required String role,
    required String content,
  })  : chatId = Value(chatId),
        data = Value(data),
        role = Value(role),
        content = Value(content);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<DateTime>? data,
    Expression<String>? role,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (data != null) 'data': data,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? chatId,
      Value<DateTime>? data,
      Value<String>? role,
      Value<String>? content}) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      data: data ?? this.data,
      role: role ?? this.role,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (data.present) {
      map['data'] = Variable<DateTime>(data.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('data: $data, ')
          ..write('role: $role, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

abstract class _$AbstractMessageDatabase extends GeneratedDatabase {
  _$AbstractMessageDatabase(QueryExecutor e) : super(e);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chats, messages];
}
