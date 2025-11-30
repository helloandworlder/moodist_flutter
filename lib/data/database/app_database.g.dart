// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SoundStatesTable extends SoundStates
    with TableInfo<$SoundStatesTable, SoundState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoundStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _soundIdMeta = const VerificationMeta(
    'soundId',
  );
  @override
  late final GeneratedColumn<String> soundId = GeneratedColumn<String>(
    'sound_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSelectedMeta = const VerificationMeta(
    'isSelected',
  );
  @override
  late final GeneratedColumn<bool> isSelected = GeneratedColumn<bool>(
    'is_selected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_selected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<double> volume = GeneratedColumn<double>(
    'volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.5),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    soundId,
    isSelected,
    volume,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sound_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<SoundState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sound_id')) {
      context.handle(
        _soundIdMeta,
        soundId.isAcceptableOrUnknown(data['sound_id']!, _soundIdMeta),
      );
    } else if (isInserting) {
      context.missing(_soundIdMeta);
    }
    if (data.containsKey('is_selected')) {
      context.handle(
        _isSelectedMeta,
        isSelected.isAcceptableOrUnknown(data['is_selected']!, _isSelectedMeta),
      );
    }
    if (data.containsKey('volume')) {
      context.handle(
        _volumeMeta,
        volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {soundId};
  @override
  SoundState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoundState(
      soundId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sound_id'],
      )!,
      isSelected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_selected'],
      )!,
      volume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $SoundStatesTable createAlias(String alias) {
    return $SoundStatesTable(attachedDatabase, alias);
  }
}

class SoundState extends DataClass implements Insertable<SoundState> {
  final String soundId;
  final bool isSelected;
  final double volume;
  final bool isFavorite;
  const SoundState({
    required this.soundId,
    required this.isSelected,
    required this.volume,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sound_id'] = Variable<String>(soundId);
    map['is_selected'] = Variable<bool>(isSelected);
    map['volume'] = Variable<double>(volume);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  SoundStatesCompanion toCompanion(bool nullToAbsent) {
    return SoundStatesCompanion(
      soundId: Value(soundId),
      isSelected: Value(isSelected),
      volume: Value(volume),
      isFavorite: Value(isFavorite),
    );
  }

  factory SoundState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoundState(
      soundId: serializer.fromJson<String>(json['soundId']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
      volume: serializer.fromJson<double>(json['volume']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'soundId': serializer.toJson<String>(soundId),
      'isSelected': serializer.toJson<bool>(isSelected),
      'volume': serializer.toJson<double>(volume),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  SoundState copyWith({
    String? soundId,
    bool? isSelected,
    double? volume,
    bool? isFavorite,
  }) => SoundState(
    soundId: soundId ?? this.soundId,
    isSelected: isSelected ?? this.isSelected,
    volume: volume ?? this.volume,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  SoundState copyWithCompanion(SoundStatesCompanion data) {
    return SoundState(
      soundId: data.soundId.present ? data.soundId.value : this.soundId,
      isSelected: data.isSelected.present
          ? data.isSelected.value
          : this.isSelected,
      volume: data.volume.present ? data.volume.value : this.volume,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SoundState(')
          ..write('soundId: $soundId, ')
          ..write('isSelected: $isSelected, ')
          ..write('volume: $volume, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(soundId, isSelected, volume, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoundState &&
          other.soundId == this.soundId &&
          other.isSelected == this.isSelected &&
          other.volume == this.volume &&
          other.isFavorite == this.isFavorite);
}

class SoundStatesCompanion extends UpdateCompanion<SoundState> {
  final Value<String> soundId;
  final Value<bool> isSelected;
  final Value<double> volume;
  final Value<bool> isFavorite;
  final Value<int> rowid;
  const SoundStatesCompanion({
    this.soundId = const Value.absent(),
    this.isSelected = const Value.absent(),
    this.volume = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SoundStatesCompanion.insert({
    required String soundId,
    this.isSelected = const Value.absent(),
    this.volume = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : soundId = Value(soundId);
  static Insertable<SoundState> custom({
    Expression<String>? soundId,
    Expression<bool>? isSelected,
    Expression<double>? volume,
    Expression<bool>? isFavorite,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (soundId != null) 'sound_id': soundId,
      if (isSelected != null) 'is_selected': isSelected,
      if (volume != null) 'volume': volume,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SoundStatesCompanion copyWith({
    Value<String>? soundId,
    Value<bool>? isSelected,
    Value<double>? volume,
    Value<bool>? isFavorite,
    Value<int>? rowid,
  }) {
    return SoundStatesCompanion(
      soundId: soundId ?? this.soundId,
      isSelected: isSelected ?? this.isSelected,
      volume: volume ?? this.volume,
      isFavorite: isFavorite ?? this.isFavorite,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (soundId.present) {
      map['sound_id'] = Variable<String>(soundId.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    if (volume.present) {
      map['volume'] = Variable<double>(volume.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoundStatesCompanion(')
          ..write('soundId: $soundId, ')
          ..write('isSelected: $isSelected, ')
          ..write('volume: $volume, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PresetsTable extends Presets with TableInfo<$PresetsTable, Preset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soundsJsonMeta = const VerificationMeta(
    'soundsJson',
  );
  @override
  late final GeneratedColumn<String> soundsJson = GeneratedColumn<String>(
    'sounds_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, soundsJson, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sounds_json')) {
      context.handle(
        _soundsJsonMeta,
        soundsJson.isAcceptableOrUnknown(data['sounds_json']!, _soundsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_soundsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      soundsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sounds_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PresetsTable createAlias(String alias) {
    return $PresetsTable(attachedDatabase, alias);
  }
}

class Preset extends DataClass implements Insertable<Preset> {
  final String id;
  final String name;
  final String soundsJson;
  final DateTime createdAt;
  const Preset({
    required this.id,
    required this.name,
    required this.soundsJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['sounds_json'] = Variable<String>(soundsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PresetsCompanion toCompanion(bool nullToAbsent) {
    return PresetsCompanion(
      id: Value(id),
      name: Value(name),
      soundsJson: Value(soundsJson),
      createdAt: Value(createdAt),
    );
  }

  factory Preset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preset(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      soundsJson: serializer.fromJson<String>(json['soundsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'soundsJson': serializer.toJson<String>(soundsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Preset copyWith({
    String? id,
    String? name,
    String? soundsJson,
    DateTime? createdAt,
  }) => Preset(
    id: id ?? this.id,
    name: name ?? this.name,
    soundsJson: soundsJson ?? this.soundsJson,
    createdAt: createdAt ?? this.createdAt,
  );
  Preset copyWithCompanion(PresetsCompanion data) {
    return Preset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      soundsJson: data.soundsJson.present
          ? data.soundsJson.value
          : this.soundsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('soundsJson: $soundsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, soundsJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preset &&
          other.id == this.id &&
          other.name == this.name &&
          other.soundsJson == this.soundsJson &&
          other.createdAt == this.createdAt);
}

class PresetsCompanion extends UpdateCompanion<Preset> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> soundsJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PresetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.soundsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PresetsCompanion.insert({
    required String id,
    required String name,
    required String soundsJson,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       soundsJson = Value(soundsJson);
  static Insertable<Preset> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? soundsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (soundsJson != null) 'sounds_json': soundsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PresetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? soundsJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PresetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      soundsJson: soundsJson ?? this.soundsJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (soundsJson.present) {
      map['sounds_json'] = Variable<String>(soundsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('soundsJson: $soundsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 500,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, isDone, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final String id;
  final String content;
  final bool isDone;
  final DateTime createdAt;
  const Todo({
    required this.id,
    required this.content,
    required this.isDone,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['is_done'] = Variable<bool>(isDone);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      content: Value(content),
      isDone: Value(isDone),
      createdAt: Value(createdAt),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'isDone': serializer.toJson<bool>(isDone),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Todo copyWith({
    String? id,
    String? content,
    bool? isDone,
    DateTime? createdAt,
  }) => Todo(
    id: id ?? this.id,
    content: content ?? this.content,
    isDone: isDone ?? this.isDone,
    createdAt: createdAt ?? this.createdAt,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('isDone: $isDone, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, isDone, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.content == this.content &&
          other.isDone == this.isDone &&
          other.createdAt == this.createdAt);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<String> id;
  final Value<String> content;
  final Value<bool> isDone;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.isDone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    required String content,
    this.isDone = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content);
  static Insertable<Todo> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<bool>? isDone,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (isDone != null) 'is_done': isDone,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<bool>? isDone,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('isDone: $isDone, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final String content;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.content,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['content'] = Variable<String>(content);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      content: Value(content),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'content': serializer.toJson<String>(content),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({int? id, String? content, DateTime? updatedAt}) => Note(
    id: id ?? this.id,
    content: content ?? this.content,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.content == this.content &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<String> content;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<String>? content,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<String>? content,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PomodoroSettingsTable extends PomodoroSettings
    with TableInfo<$PomodoroSettingsTable, PomodoroSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PomodoroSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _focusDurationMeta = const VerificationMeta(
    'focusDuration',
  );
  @override
  late final GeneratedColumn<int> focusDuration = GeneratedColumn<int>(
    'focus_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25 * 60),
  );
  static const VerificationMeta _shortBreakDurationMeta =
      const VerificationMeta('shortBreakDuration');
  @override
  late final GeneratedColumn<int> shortBreakDuration = GeneratedColumn<int>(
    'short_break_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5 * 60),
  );
  static const VerificationMeta _longBreakDurationMeta = const VerificationMeta(
    'longBreakDuration',
  );
  @override
  late final GeneratedColumn<int> longBreakDuration = GeneratedColumn<int>(
    'long_break_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15 * 60),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    focusDuration,
    shortBreakDuration,
    longBreakDuration,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pomodoro_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PomodoroSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('focus_duration')) {
      context.handle(
        _focusDurationMeta,
        focusDuration.isAcceptableOrUnknown(
          data['focus_duration']!,
          _focusDurationMeta,
        ),
      );
    }
    if (data.containsKey('short_break_duration')) {
      context.handle(
        _shortBreakDurationMeta,
        shortBreakDuration.isAcceptableOrUnknown(
          data['short_break_duration']!,
          _shortBreakDurationMeta,
        ),
      );
    }
    if (data.containsKey('long_break_duration')) {
      context.handle(
        _longBreakDurationMeta,
        longBreakDuration.isAcceptableOrUnknown(
          data['long_break_duration']!,
          _longBreakDurationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PomodoroSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PomodoroSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      focusDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_duration'],
      )!,
      shortBreakDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}short_break_duration'],
      )!,
      longBreakDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_break_duration'],
      )!,
    );
  }

  @override
  $PomodoroSettingsTable createAlias(String alias) {
    return $PomodoroSettingsTable(attachedDatabase, alias);
  }
}

class PomodoroSetting extends DataClass implements Insertable<PomodoroSetting> {
  final int id;
  final int focusDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  const PomodoroSetting({
    required this.id,
    required this.focusDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['focus_duration'] = Variable<int>(focusDuration);
    map['short_break_duration'] = Variable<int>(shortBreakDuration);
    map['long_break_duration'] = Variable<int>(longBreakDuration);
    return map;
  }

  PomodoroSettingsCompanion toCompanion(bool nullToAbsent) {
    return PomodoroSettingsCompanion(
      id: Value(id),
      focusDuration: Value(focusDuration),
      shortBreakDuration: Value(shortBreakDuration),
      longBreakDuration: Value(longBreakDuration),
    );
  }

  factory PomodoroSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PomodoroSetting(
      id: serializer.fromJson<int>(json['id']),
      focusDuration: serializer.fromJson<int>(json['focusDuration']),
      shortBreakDuration: serializer.fromJson<int>(json['shortBreakDuration']),
      longBreakDuration: serializer.fromJson<int>(json['longBreakDuration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'focusDuration': serializer.toJson<int>(focusDuration),
      'shortBreakDuration': serializer.toJson<int>(shortBreakDuration),
      'longBreakDuration': serializer.toJson<int>(longBreakDuration),
    };
  }

  PomodoroSetting copyWith({
    int? id,
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
  }) => PomodoroSetting(
    id: id ?? this.id,
    focusDuration: focusDuration ?? this.focusDuration,
    shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
    longBreakDuration: longBreakDuration ?? this.longBreakDuration,
  );
  PomodoroSetting copyWithCompanion(PomodoroSettingsCompanion data) {
    return PomodoroSetting(
      id: data.id.present ? data.id.value : this.id,
      focusDuration: data.focusDuration.present
          ? data.focusDuration.value
          : this.focusDuration,
      shortBreakDuration: data.shortBreakDuration.present
          ? data.shortBreakDuration.value
          : this.shortBreakDuration,
      longBreakDuration: data.longBreakDuration.present
          ? data.longBreakDuration.value
          : this.longBreakDuration,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSetting(')
          ..write('id: $id, ')
          ..write('focusDuration: $focusDuration, ')
          ..write('shortBreakDuration: $shortBreakDuration, ')
          ..write('longBreakDuration: $longBreakDuration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, focusDuration, shortBreakDuration, longBreakDuration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PomodoroSetting &&
          other.id == this.id &&
          other.focusDuration == this.focusDuration &&
          other.shortBreakDuration == this.shortBreakDuration &&
          other.longBreakDuration == this.longBreakDuration);
}

class PomodoroSettingsCompanion extends UpdateCompanion<PomodoroSetting> {
  final Value<int> id;
  final Value<int> focusDuration;
  final Value<int> shortBreakDuration;
  final Value<int> longBreakDuration;
  const PomodoroSettingsCompanion({
    this.id = const Value.absent(),
    this.focusDuration = const Value.absent(),
    this.shortBreakDuration = const Value.absent(),
    this.longBreakDuration = const Value.absent(),
  });
  PomodoroSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.focusDuration = const Value.absent(),
    this.shortBreakDuration = const Value.absent(),
    this.longBreakDuration = const Value.absent(),
  });
  static Insertable<PomodoroSetting> custom({
    Expression<int>? id,
    Expression<int>? focusDuration,
    Expression<int>? shortBreakDuration,
    Expression<int>? longBreakDuration,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (focusDuration != null) 'focus_duration': focusDuration,
      if (shortBreakDuration != null)
        'short_break_duration': shortBreakDuration,
      if (longBreakDuration != null) 'long_break_duration': longBreakDuration,
    });
  }

  PomodoroSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? focusDuration,
    Value<int>? shortBreakDuration,
    Value<int>? longBreakDuration,
  }) {
    return PomodoroSettingsCompanion(
      id: id ?? this.id,
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (focusDuration.present) {
      map['focus_duration'] = Variable<int>(focusDuration.value);
    }
    if (shortBreakDuration.present) {
      map['short_break_duration'] = Variable<int>(shortBreakDuration.value);
    }
    if (longBreakDuration.present) {
      map['long_break_duration'] = Variable<int>(longBreakDuration.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PomodoroSettingsCompanion(')
          ..write('id: $id, ')
          ..write('focusDuration: $focusDuration, ')
          ..write('shortBreakDuration: $shortBreakDuration, ')
          ..write('longBreakDuration: $longBreakDuration')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _globalVolumeMeta = const VerificationMeta(
    'globalVolume',
  );
  @override
  late final GeneratedColumn<double> globalVolume = GeneratedColumn<double>(
    'global_volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _darkModeMeta = const VerificationMeta(
    'darkMode',
  );
  @override
  late final GeneratedColumn<bool> darkMode = GeneratedColumn<bool>(
    'dark_mode',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dark_mode" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, globalVolume, darkMode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('global_volume')) {
      context.handle(
        _globalVolumeMeta,
        globalVolume.isAcceptableOrUnknown(
          data['global_volume']!,
          _globalVolumeMeta,
        ),
      );
    }
    if (data.containsKey('dark_mode')) {
      context.handle(
        _darkModeMeta,
        darkMode.isAcceptableOrUnknown(data['dark_mode']!, _darkModeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      globalVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}global_volume'],
      )!,
      darkMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dark_mode'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final double globalVolume;
  final bool? darkMode;
  const AppSetting({
    required this.id,
    required this.globalVolume,
    this.darkMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['global_volume'] = Variable<double>(globalVolume);
    if (!nullToAbsent || darkMode != null) {
      map['dark_mode'] = Variable<bool>(darkMode);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      globalVolume: Value(globalVolume),
      darkMode: darkMode == null && nullToAbsent
          ? const Value.absent()
          : Value(darkMode),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      globalVolume: serializer.fromJson<double>(json['globalVolume']),
      darkMode: serializer.fromJson<bool?>(json['darkMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'globalVolume': serializer.toJson<double>(globalVolume),
      'darkMode': serializer.toJson<bool?>(darkMode),
    };
  }

  AppSetting copyWith({
    int? id,
    double? globalVolume,
    Value<bool?> darkMode = const Value.absent(),
  }) => AppSetting(
    id: id ?? this.id,
    globalVolume: globalVolume ?? this.globalVolume,
    darkMode: darkMode.present ? darkMode.value : this.darkMode,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      globalVolume: data.globalVolume.present
          ? data.globalVolume.value
          : this.globalVolume,
      darkMode: data.darkMode.present ? data.darkMode.value : this.darkMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('globalVolume: $globalVolume, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, globalVolume, darkMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.globalVolume == this.globalVolume &&
          other.darkMode == this.darkMode);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<double> globalVolume;
  final Value<bool?> darkMode;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.globalVolume = const Value.absent(),
    this.darkMode = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.globalVolume = const Value.absent(),
    this.darkMode = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<double>? globalVolume,
    Expression<bool>? darkMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (globalVolume != null) 'global_volume': globalVolume,
      if (darkMode != null) 'dark_mode': darkMode,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<double>? globalVolume,
    Value<bool?>? darkMode,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      globalVolume: globalVolume ?? this.globalVolume,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (globalVolume.present) {
      map['global_volume'] = Variable<double>(globalVolume.value);
    }
    if (darkMode.present) {
      map['dark_mode'] = Variable<bool>(darkMode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('globalVolume: $globalVolume, ')
          ..write('darkMode: $darkMode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SoundStatesTable soundStates = $SoundStatesTable(this);
  late final $PresetsTable presets = $PresetsTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $PomodoroSettingsTable pomodoroSettings = $PomodoroSettingsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    soundStates,
    presets,
    todos,
    notes,
    pomodoroSettings,
    appSettings,
  ];
}

typedef $$SoundStatesTableCreateCompanionBuilder =
    SoundStatesCompanion Function({
      required String soundId,
      Value<bool> isSelected,
      Value<double> volume,
      Value<bool> isFavorite,
      Value<int> rowid,
    });
typedef $$SoundStatesTableUpdateCompanionBuilder =
    SoundStatesCompanion Function({
      Value<String> soundId,
      Value<bool> isSelected,
      Value<double> volume,
      Value<bool> isFavorite,
      Value<int> rowid,
    });

class $$SoundStatesTableFilterComposer
    extends Composer<_$AppDatabase, $SoundStatesTable> {
  $$SoundStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get soundId => $composableBuilder(
    column: $table.soundId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SoundStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SoundStatesTable> {
  $$SoundStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get soundId => $composableBuilder(
    column: $table.soundId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volume => $composableBuilder(
    column: $table.volume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SoundStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SoundStatesTable> {
  $$SoundStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get soundId =>
      $composableBuilder(column: $table.soundId, builder: (column) => column);

  GeneratedColumn<bool> get isSelected => $composableBuilder(
    column: $table.isSelected,
    builder: (column) => column,
  );

  GeneratedColumn<double> get volume =>
      $composableBuilder(column: $table.volume, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$SoundStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SoundStatesTable,
          SoundState,
          $$SoundStatesTableFilterComposer,
          $$SoundStatesTableOrderingComposer,
          $$SoundStatesTableAnnotationComposer,
          $$SoundStatesTableCreateCompanionBuilder,
          $$SoundStatesTableUpdateCompanionBuilder,
          (
            SoundState,
            BaseReferences<_$AppDatabase, $SoundStatesTable, SoundState>,
          ),
          SoundState,
          PrefetchHooks Function()
        > {
  $$SoundStatesTableTableManager(_$AppDatabase db, $SoundStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SoundStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SoundStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SoundStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> soundId = const Value.absent(),
                Value<bool> isSelected = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoundStatesCompanion(
                soundId: soundId,
                isSelected: isSelected,
                volume: volume,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String soundId,
                Value<bool> isSelected = const Value.absent(),
                Value<double> volume = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SoundStatesCompanion.insert(
                soundId: soundId,
                isSelected: isSelected,
                volume: volume,
                isFavorite: isFavorite,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SoundStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SoundStatesTable,
      SoundState,
      $$SoundStatesTableFilterComposer,
      $$SoundStatesTableOrderingComposer,
      $$SoundStatesTableAnnotationComposer,
      $$SoundStatesTableCreateCompanionBuilder,
      $$SoundStatesTableUpdateCompanionBuilder,
      (
        SoundState,
        BaseReferences<_$AppDatabase, $SoundStatesTable, SoundState>,
      ),
      SoundState,
      PrefetchHooks Function()
    >;
typedef $$PresetsTableCreateCompanionBuilder =
    PresetsCompanion Function({
      required String id,
      required String name,
      required String soundsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PresetsTableUpdateCompanionBuilder =
    PresetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> soundsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PresetsTableFilterComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soundsJson => $composableBuilder(
    column: $table.soundsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PresetsTableOrderingComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soundsJson => $composableBuilder(
    column: $table.soundsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PresetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresetsTable> {
  $$PresetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get soundsJson => $composableBuilder(
    column: $table.soundsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PresetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresetsTable,
          Preset,
          $$PresetsTableFilterComposer,
          $$PresetsTableOrderingComposer,
          $$PresetsTableAnnotationComposer,
          $$PresetsTableCreateCompanionBuilder,
          $$PresetsTableUpdateCompanionBuilder,
          (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
          Preset,
          PrefetchHooks Function()
        > {
  $$PresetsTableTableManager(_$AppDatabase db, $PresetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> soundsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresetsCompanion(
                id: id,
                name: name,
                soundsJson: soundsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String soundsJson,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PresetsCompanion.insert(
                id: id,
                name: name,
                soundsJson: soundsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PresetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresetsTable,
      Preset,
      $$PresetsTableFilterComposer,
      $$PresetsTableOrderingComposer,
      $$PresetsTableAnnotationComposer,
      $$PresetsTableCreateCompanionBuilder,
      $$PresetsTableUpdateCompanionBuilder,
      (Preset, BaseReferences<_$AppDatabase, $PresetsTable, Preset>),
      Preset,
      PrefetchHooks Function()
    >;
typedef $$TodosTableCreateCompanionBuilder =
    TodosCompanion Function({
      required String id,
      required String content,
      Value<bool> isDone,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TodosTableUpdateCompanionBuilder =
    TodosCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<bool> isDone,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                content: content,
                isDone: isDone,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                Value<bool> isDone = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                content: content,
                isDone: isDone,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<DateTime> updatedAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<String> content,
      Value<DateTime> updatedAt,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                content: content,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                content: content,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$PomodoroSettingsTableCreateCompanionBuilder =
    PomodoroSettingsCompanion Function({
      Value<int> id,
      Value<int> focusDuration,
      Value<int> shortBreakDuration,
      Value<int> longBreakDuration,
    });
typedef $$PomodoroSettingsTableUpdateCompanionBuilder =
    PomodoroSettingsCompanion Function({
      Value<int> id,
      Value<int> focusDuration,
      Value<int> shortBreakDuration,
      Value<int> longBreakDuration,
    });

class $$PomodoroSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PomodoroSettingsTable> {
  $$PomodoroSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusDuration => $composableBuilder(
    column: $table.focusDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shortBreakDuration => $composableBuilder(
    column: $table.shortBreakDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBreakDuration => $composableBuilder(
    column: $table.longBreakDuration,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PomodoroSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PomodoroSettingsTable> {
  $$PomodoroSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusDuration => $composableBuilder(
    column: $table.focusDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shortBreakDuration => $composableBuilder(
    column: $table.shortBreakDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBreakDuration => $composableBuilder(
    column: $table.longBreakDuration,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PomodoroSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PomodoroSettingsTable> {
  $$PomodoroSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get focusDuration => $composableBuilder(
    column: $table.focusDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shortBreakDuration => $composableBuilder(
    column: $table.shortBreakDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBreakDuration => $composableBuilder(
    column: $table.longBreakDuration,
    builder: (column) => column,
  );
}

class $$PomodoroSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PomodoroSettingsTable,
          PomodoroSetting,
          $$PomodoroSettingsTableFilterComposer,
          $$PomodoroSettingsTableOrderingComposer,
          $$PomodoroSettingsTableAnnotationComposer,
          $$PomodoroSettingsTableCreateCompanionBuilder,
          $$PomodoroSettingsTableUpdateCompanionBuilder,
          (
            PomodoroSetting,
            BaseReferences<
              _$AppDatabase,
              $PomodoroSettingsTable,
              PomodoroSetting
            >,
          ),
          PomodoroSetting,
          PrefetchHooks Function()
        > {
  $$PomodoroSettingsTableTableManager(
    _$AppDatabase db,
    $PomodoroSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PomodoroSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PomodoroSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PomodoroSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> focusDuration = const Value.absent(),
                Value<int> shortBreakDuration = const Value.absent(),
                Value<int> longBreakDuration = const Value.absent(),
              }) => PomodoroSettingsCompanion(
                id: id,
                focusDuration: focusDuration,
                shortBreakDuration: shortBreakDuration,
                longBreakDuration: longBreakDuration,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> focusDuration = const Value.absent(),
                Value<int> shortBreakDuration = const Value.absent(),
                Value<int> longBreakDuration = const Value.absent(),
              }) => PomodoroSettingsCompanion.insert(
                id: id,
                focusDuration: focusDuration,
                shortBreakDuration: shortBreakDuration,
                longBreakDuration: longBreakDuration,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PomodoroSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PomodoroSettingsTable,
      PomodoroSetting,
      $$PomodoroSettingsTableFilterComposer,
      $$PomodoroSettingsTableOrderingComposer,
      $$PomodoroSettingsTableAnnotationComposer,
      $$PomodoroSettingsTableCreateCompanionBuilder,
      $$PomodoroSettingsTableUpdateCompanionBuilder,
      (
        PomodoroSetting,
        BaseReferences<_$AppDatabase, $PomodoroSettingsTable, PomodoroSetting>,
      ),
      PomodoroSetting,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<double> globalVolume,
      Value<bool?> darkMode,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<double> globalVolume,
      Value<bool?> darkMode,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get globalVolume => $composableBuilder(
    column: $table.globalVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get globalVolume => $composableBuilder(
    column: $table.globalVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get darkMode => $composableBuilder(
    column: $table.darkMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get globalVolume => $composableBuilder(
    column: $table.globalVolume,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get darkMode =>
      $composableBuilder(column: $table.darkMode, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> globalVolume = const Value.absent(),
                Value<bool?> darkMode = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                globalVolume: globalVolume,
                darkMode: darkMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> globalVolume = const Value.absent(),
                Value<bool?> darkMode = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                globalVolume: globalVolume,
                darkMode: darkMode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SoundStatesTableTableManager get soundStates =>
      $$SoundStatesTableTableManager(_db, _db.soundStates);
  $$PresetsTableTableManager get presets =>
      $$PresetsTableTableManager(_db, _db.presets);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$PomodoroSettingsTableTableManager get pomodoroSettings =>
      $$PomodoroSettingsTableTableManager(_db, _db.pomodoroSettings);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
