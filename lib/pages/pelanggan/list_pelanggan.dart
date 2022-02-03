import 'package:flutter/material.dart';
import 'package:latihan_sqllite/helper/db_helper.dart';
import 'package:latihan_sqllite/pages/pelanggan/form_pelanggan.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PelangganList extends StatefulWidget {
  const PelangganList({Key? key}) : super(key: key);

  @override
  _PelangganListState createState() => _PelangganListState();
}

class _PelangganListState extends State<PelangganList> {
  RefreshController _refreshController = RefreshController(initialRefresh: true);
  List<Map> listData = [];

  void refresh() async{
    // untuk mendapatkan objek database
    final _db = await DBHelper.db();

    const sql = 'SELECT * FROM pelanggan';
    listData = (await _db?.rawQuery(sql))!;
    _refreshController.refreshCompleted();
    setState(() {

    });
  }

  Widget item(Map d) => ListTile(
    title: Text('${d['nama']}'),
    trailing:  Text('${d['gender']}'),
    subtitle:  Text('${d['tgl_lahir']}'),
  );

  Widget tombolTambah() => ElevatedButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PelangganForm()));
      } ,
      child: Text('Tambah Pelanggan'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data pelanggan'),
      ),
      body: SmartRefresher(
          controller: _refreshController,
        onRefresh: () => refresh() ,
        child: ListView(
          children: [
            for(Map d in listData)
              item(d)
          ],
        ),
      ),
      floatingActionButton: tombolTambah(),
    );
  }
}
