// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  DataDao? _dataDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Data` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `height` REAL NOT NULL, `weight` REAL NOT NULL, `hearthRate` REAL NOT NULL, `dateTime` INTEGER NOT NULL, `ReferenceValueHFA` REAL, `ReferenceValueWFH` REAL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  DataDao get dataDao {
    return _dataDaoInstance ??= _$DataDao(database, changeListener);
  }
}

class _$DataDao extends DataDao {
  _$DataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dataInsertionAdapter = InsertionAdapter(
            database,
            'Data',
            (Data item) => <String, Object?>{
                  'id': item.id,
                  'height': item.height,
                  'weight': item.weight,
                  'hearthRate': item.hearthRate,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'ReferenceValueHFA': item.ReferenceValueHFA,
                  'ReferenceValueWFH': item.ReferenceValueWFH
                }),
        _dataUpdateAdapter = UpdateAdapter(
            database,
            'Data',
            ['id'],
            (Data item) => <String, Object?>{
                  'id': item.id,
                  'height': item.height,
                  'weight': item.weight,
                  'hearthRate': item.hearthRate,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'ReferenceValueHFA': item.ReferenceValueHFA,
                  'ReferenceValueWFH': item.ReferenceValueWFH
                }),
        _dataDeletionAdapter = DeletionAdapter(
            database,
            'Data',
            ['id'],
            (Data item) => <String, Object?>{
                  'id': item.id,
                  'height': item.height,
                  'weight': item.weight,
                  'hearthRate': item.hearthRate,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'ReferenceValueHFA': item.ReferenceValueHFA,
                  'ReferenceValueWFH': item.ReferenceValueWFH
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Data> _dataInsertionAdapter;

  final UpdateAdapter<Data> _dataUpdateAdapter;

  final DeletionAdapter<Data> _dataDeletionAdapter;

  @override
  Future<List<Data>> findAllData() async {
    return _queryAdapter.queryList('SELECT * FROM Data',
        mapper: (Map<String, Object?> row) => Data(
            row['id'] as int?,
            row['height'] as double,
            row['weight'] as double,
            row['hearthRate'] as double,
            _dateTimeConverter.decode(row['dateTime'] as int),
            row['ReferenceValueHFA'] as double?,
            row['ReferenceValueWFH'] as double?));
  }

  @override
  Future<void> insertData(Data data) async {
    await _dataInsertionAdapter.insert(data, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateData(Data data) async {
    await _dataUpdateAdapter.update(data, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteData(Data data) async {
    await _dataDeletionAdapter.delete(data);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
