import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? _db;
  static const String query_table_pelangan =""
      "CREATE TABLE pelanggan("
      "id INTEGER PRIMARY KEY "
      "nama TEXT"
      "gender TEXT"
      "tgl_lhr TEXT)";

//  method static untuk akses ke var db nya
static Future<Database?> db() async{
  return _db ??= (await DBHelper().konekDB());
}

   Future<Database> konekDB() async {
  return await openDatabase('dbpelanggan.db',
  version: 1,
    onCreate:
    (db, version){
    db.execute(query_table_pelangan);
    }
  );
   }
}