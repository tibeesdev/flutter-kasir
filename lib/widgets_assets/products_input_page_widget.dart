import 'package:flutter/material.dart';
import 'package:kasirapp2/main.dart';
import 'package:kasirapp2/transaction_page.dart';

// header untuk data produk berisi teks catatan, pengeluaran dan pemasukan
class headerDataProduk extends StatelessWidget {
  const headerDataProduk({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      constraints: BoxConstraints(
        maxWidth: screenWidth - 20,
        maxHeight: 60,
        minHeight: 50,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Color(0xFFbfcfff),
        border: Border.all(color: Color(0xFF6e8aff), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 30,
            child: Center(
              child: Text(
                'nama barang',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
              child: Text(
                'stok',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'modal',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'harga jual',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// list barang beserta harga dan stoknya

class ListBarang extends StatelessWidget {
  const ListBarang({super.key, required this.data});

  final List data;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(1),
            constraints: BoxConstraints(maxHeight: 70, minHeight: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              color: Color.fromARGB(255, 255, 255, 255),
              border: Border.all(color: Color(0xFF6e8aff), width: 2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // nama barang dan id
                Expanded(
                  flex: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // nama barang
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          'nama barang $index',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),

                      // id transaksi
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          'kode_barang $index',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // stok barang
                Expanded(
                  flex: 20,
                  child: Center(
                    child: Text(
                      'stok $index',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // modal
                Expanded(
                  flex: 25,
                  child: Center(
                    child: Text(
                      'modal $index',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // modal
                Expanded(
                  flex: 25,
                  child: Center(
                    child: Text(
                      'harga jual $index',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// custom tabbar
class cutomTabBar extends StatelessWidget {
  const cutomTabBar({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 60,
        maxWidth: screenWidth - 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        shape: BoxShape.rectangle,
        color: Color(0xFF6e8aff),
      ),
      // bagi tabbar menjadi 3 bagian
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // tombol sebelah kiri
          // tombol kasir untuk kembali ke menu kasir
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: AlignmentDirectional.center,
                constraints: BoxConstraints(
                  maxWidth: screenWidth / 3,
                  minWidth: screenWidth / 3,
                  minHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(33, 255, 255, 255),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'kasir',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // tombol tambah di bagian tengah untuk simpan transaksi
          Transform.translate(
            offset: Offset(0, -20),
            transformHitTests: true,
            child: Container(
              alignment: Alignment.center,
              width: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  // fungsi untuk menambahkan barang
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TambahBarangDialog();
                    },
                  );
                },
                shape: CircleBorder(),
                backgroundColor: Color(0xFF6e8aff),
                foregroundColor: Colors.white,
                child: Icon(Icons.add),
              ),
            ),
          ),

          // tombol sebelah kanan'
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TransactionPage()),
                ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: AlignmentDirectional.center,
                constraints: BoxConstraints(
                  maxWidth: screenWidth / 3,
                  minWidth: screenWidth / 3,
                  minHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(33, 255, 255, 255),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Transaksi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// alert dialog
// untuk tambah barang
class TambahBarangDialog extends StatefulWidget {
  const TambahBarangDialog({super.key});

  @override
  State<TambahBarangDialog> createState() => _TambahBarangDialogState();
}

class _TambahBarangDialogState extends State<TambahBarangDialog> {
  TextEditingController kode_barang_controller = TextEditingController();
  TextEditingController nama_barang_controller = TextEditingController();
  TextEditingController modal_barang_controller = TextEditingController();
  TextEditingController harga_barang_controller = TextEditingController();
  TextEditingController stok_barang_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      alignment: Alignment.center,
      icon: Icon(Icons.bar_chart_outlined),
      scrollable: true,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 5,
      actionsOverflowDirection: VerticalDirection.down,
      title: Text('Masukkan Informasi Barang'),

      // formfield
      content: Column(
        children: [
          // kode barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: kode_barang_controller,
              onChanged: (value) {
                setState(() {
                  kode_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'kode barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // nama barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: nama_barang_controller,
              onChanged: (value) {
                setState(() {
                  nama_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'nama barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // modal barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: modal_barang_controller,
              onChanged: (value) {
                setState(() {
                  modal_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'modal',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // harga barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: harga_barang_controller,
              onChanged: (value) {
                setState(() {
                  harga_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'harga',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // stok barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: stok_barang_controller,
              onChanged: (value) {
                setState(() {
                  stok_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'stok',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('batalkan'),
        ),
        ElevatedButton(onPressed: () {}, child: Text('simpan')),
      ],
    );
  }
}
