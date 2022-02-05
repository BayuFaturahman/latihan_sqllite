import 'package:flutter/material.dart';
import 'package:latihan_sqllite/helper/db_helper.dart';
import 'package:latihan_sqllite/pages/pelanggan/cari_pelanggan.dart';
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

    onLongPress: (){
      showMenu(
          context: context,
          position: RelativeRect.fromLTRB(100, MediaQuery.of(context).size.height/2,100, 0),
          items: [
            const PopupMenuItem(child: Text('Sunting data ini!'),value: 'S',),
            const PopupMenuItem(child: Text('Hapus data ini!'),value: 'H',)
          ]).then((value) {
            if(value == 'S'){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>PelangganForm(data: d,)
              )).then((value){
                if(value == true){
                  refresh();
                }
              });
            }else if(value == 'H'){
              showDialog(
                  context: context,
                  builder: (c)=>AlertDialog(
                    content: Text('Pelanggan ${d['name']} ingin dihapus ?'),
                    actions: [
                      TextButton(onPressed: (){
                          hapusData(d['id']).then((value){
                            if(value==true)refresh();
                          });
                          Navigator.pop(context);
                      }, child:const Text('Ya, saya yakin banget')),
                      TextButton(onPressed: (){
                        Navigator.pop(context);

                      }, child: const Text("Tidak!"))
                    ],
                  ));
            }
      });
    },
    leading: PopupMenuButton(
      itemBuilder: (bc)=>[
        const PopupMenuItem(child: Text('Sunting data ini!'),value: 'S',),
        const PopupMenuItem(child: Text('Hapus data ini!'),value: 'H',)
      ],
      onSelected: (value){
        if(value == 'S'){
          Navigator.push(context, MaterialPageRoute(builder: (c)=>PelangganForm(data: d,)
          )).then((value){
            if(value == true){
              refresh();
            }
          });
        }else if(value == 'H'){
          showDialog(
              context: context,
              builder: (c)=>AlertDialog(
                content: Text('Pelanggan ${d['name']} ingin dihapus ?'),
                actions: [
                  TextButton(onPressed: (){
                    hapusData(d['id']).then((value){
                      if(value==true)refresh();
                    });
                    Navigator.pop(context);
                  }, child:const Text('Ya, saya yakin banget')),
                  TextButton(onPressed: (){
                    Navigator.pop(context);

                  }, child: const Text("Tidak!"))
                ],
              ));
        }
      },
    ),

    title: Text('${d['name']}'),
    trailing:  Text('${d['gender']}'),
    subtitle:  Text('${d['tgl_lhr']}'),

  );

  Widget tombolTambah() => ElevatedButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => PelangganForm()));
      } ,
      child: Text('Tambah Pelanggan'));

  Future<bool>hapusData(int id)async{
    final _db = await DBHelper.db();
    final count = await _db?.delete('pelanggan',where: 'id=?',whereArgs: [id]);
    return count! >0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data pelanggan'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=>CariPelanggan()));
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: SmartRefresher(
          controller: _refreshController,
        onRefresh: () => refresh() ,
        child: ListView(
          children: [
            for(Map d in listData)
              item(d),

          ],
        ),
      ),
      floatingActionButton: tombolTambah(),
    );
  }
}
