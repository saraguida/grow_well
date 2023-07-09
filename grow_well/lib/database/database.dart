import 'dart:async';
import 'package:floor/floor.dart';
import 'package:grow_well/database/typeConverters/dateTimeConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:grow_well/database/daos/dataDao.dart';
import 'package:grow_well/database/entities/data.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Data])
abstract class AppDatabase extends FloorDatabase {
  DataDao get dataDao;
}//AppDatabase