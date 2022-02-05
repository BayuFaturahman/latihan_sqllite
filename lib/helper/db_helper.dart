import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database ?_db;
  static const String QUERY_TBL_PELANGGAN ="""
      CREATE TABLE pelanggan(
      id INTEGER PRIMARY KEY,
      name TEXT,
      gender TEXT,
      tgl_lhr TEXT)""";

//  method static untuk akses ke var db nya
static Future<Database?> db() async{
  return _db ??= (await DBHelper().konekDB());
}

   Future<Database> konekDB() async {
  return await openDatabase('dbsaya.db',
  version: 1,
    onCreate:
    (db, version) async{
     await db.execute(QUERY_TBL_PELANGGAN);
    }
  );
   }
}