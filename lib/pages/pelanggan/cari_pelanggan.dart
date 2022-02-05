
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latihan_sqllite/helper/db_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CariPelanggan extends StatefulWidget{

  @override
  _CariPelangganState createState() => _CariPelangganState();

}

class _CariPelangganState extends State<CariPelanggan>{
  final RefreshController _refreshController =  RefreshController(initialRefresh: true);
  List listData = [];



  void pencarian(String key)async{
    final _db = await DBHelper.db();
    const sql = 'SELECT * FROM pelanggan WHERE name LIKE ?';
     listData = (await _db?.rawQuery(sql, ['%$key%']))!;
    _refreshController.refreshCompleted();
    setState(() {

    });

  }

  Widget item(Map d)=>ListTile(
    title: Text('${d['name']}'),
    subtitle:Text('${d['tgl_lhr']}') ,
    // leading:Text('${d['gender']}') ,
    trailing: Text('${d['gender']}'),
  );

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading:const BackButton(color: Colors.black54,),
        backgroundColor: Colors.white,
        elevation: 1,
        title:  CupertinoSearchTextField(placeholder: 'Cari Pelanggan ...',
        onSubmitted: (s){
          pencarian(s);
        },),

      ),
      body: ListView(
        children: [
          for (Map d in listData)item(d)
        ],
      ),
    );
  }
}