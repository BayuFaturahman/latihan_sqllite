import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_sqllite/helper/db_helper.dart';
import 'package:latihan_sqllite/pages/pelanggan/list_pelanggan.dart';

class PelangganForm extends StatefulWidget {


  @override
  _PelangganFormState createState() => _PelangganFormState();
}

class _PelangganFormState extends State<PelangganForm> {
  //buat controller untuk formfiled nya terlebih dahulu
  late TextEditingController txtID , txtName , txtDate ;
  String _gender = "Laki-laki" ;
  final _genders = ["Laki-laki", "Perempuan"];

  //inisialisasi controller dalam constructor nya
  _PelangganFormState(){

    txtID = TextEditingController();
    txtName = TextEditingController();
    txtDate = TextEditingController();
  //  membuat constractor untuk memanggil id yang terkhir
    lastID().then((value) => txtID.text = '${value+1}');
  }

  // membuat widget untuk menambah id dan juga namenya
  Widget txtInputID() => TextFormField(
    controller: txtID,
    readOnly: true,
    decoration:  const InputDecoration(
      labelText: 'ID Pelanggang '
    ),
  );

  // buat widget untuk namenya
  Widget txtInputName() => TextFormField(
    controller: txtName,
    decoration: const InputDecoration(
      labelText:  'Nama Pelanggan'
    ),
  );

  //membuat widget untuk gender
  Widget dropDownGender() => DropdownButtonFormField(
    decoration: const InputDecoration(
      labelText: 'Jenis Kelamin'
    ),
      isExpanded: true,
      hint: const Text('Pilih gender'),
      value: _gender,
      onChanged: (g) {
        _gender = '$g';
      } ,
    items:   _genders.map((item) =>
     DropdownMenuItem(child: Text(item), value:  item,)
    ).toList()
  );

  //make a func init tanggal lahir
  DateTime initTglLahir (){
    try{
      return DateFormat('yyyy-MM-dd').parse(txtDate.value.text);
    }catch(e){}

    //konsepnya adalah kita membuat func untuk isi data tgl lahir kita, namun ketika kita lupa maka akan dideafult oleh tanggal
    //sekarang , agar tidak runTime error , kemudian kita menggunakan try catch untuk antisipasi kalau ada error ,
    //disini kita parse , untuk convert dari String masukan kita ke format DateTime
    return DateTime.now();
  }

  //membuat widget untuk input tanggal lahir
  Widget txtInputDate() => TextFormField(
      readOnly: true,
  decoration: const InputDecoration(
      labelText: 'Tanggal Lahir'
      ),
  controller: txtDate,
  onTap: () async {
        final tgl = await showDatePicker(
  context: context,
  initialDate: initTglLahir(),
  firstDate: DateTime(1990),
  lastDate: DateTime.now());

        if(tgl != null){
          txtDate.text = DateFormat('yyyy-mm-dd').format(tgl);
  }
},
      );


  Widget aksiSimpan() => TextButton(
      onPressed: (){
        simpanData().then((h) {
          var pesan = h == true ? 'Sukses Simpan' : 'Gagal Simpan';
          showDialog(
              context: context,
              builder: (bc) => AlertDialog(
                title: const Text('Simpan Pelanggan'),
                content: Text('$pesan'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('oke'))
                ],
              ));
        });
      },
      child: const Text('Simpan', style: TextStyle(color: Colors.white),));

  //membuat sebuah function untuk id nya
  /**
   * fngsinya ntuk mengetahui id last di table pelanggan , karena id adalah primary key maka dia tidak boleh sama , . cara kerja fun ini adalah
   * membaca field id  dari table pelanggan yang diambil dengan cara diurutkan datanya berdasarkan id yang terakhir dan  data diambil yang pling  pertama
   * apabila data di pelanggan belum ada maka func mengembalikan nilai 0 sebagai id pertamanya
   */
  Future<int> lastID() async{
    try {
      final _db = await DBHelper.db();
      const query = 'SELECT MAX(id) as id FROM pelanggan';
      final ls = (await _db?.rawQuery(query))!;

      if(ls.isNotEmpty ){
        return int.tryParse('${ls[0]['id']}') ?? 0 ;
      }
    } catch (e){
      print('error last id $e');
    }
    return 0 ;
  }

  //membuat func untuk simpan data
  Future<bool> simpanData() async {
    try{
      final _db = await DBHelper.db();
      var data  = {
        'id' : txtID.value.text,
        'nama' : txtName.value.text,
        'gender' : _gender,
        'tgl_lhr' : txtDate.value.text
      };
      final id = await _db?.insert('pelanggan', data);
      return id! > 0 ;
    } catch (e) {}
    return false ;
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:  const Text('Form Pelanggan'),
        actions: [
          aksiSimpan()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            txtInputID(),
            txtInputName(),
            dropDownGender(),
            txtInputDate(),
          ],
        ),
      ),
    );
  }
}
