//Imports that are necessary to the code generator of floor
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:grow_well/database/typeConverters/dateTimeConverter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'package:grow_well/database/daos/dataDao.dart';
import 'package:grow_well/database/entities/data.dart';

 //The generated code will be in database.g.dart
part 'database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Data.
//We also added a TypeConverter to manage the DateTime of a Data entry, since DateTimes are not natively
//supported by Floor.
@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Data])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  DataDao get dataDao;
}//AppDatabase