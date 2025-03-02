import 'dart:math';

import 'package:flutter/material.dart';
import 'widgets_assets/transaction_page_widget.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // inisiasi tanggal awal
  DateTime? _selectedDate = DateTime.now();
  // contorller
  TextEditingController catatan_transaksi = TextEditingController();
  TextEditingController cari_barang = TextEditingController();

  // fungsi callback
  // callback text cari barang
  void onUpdateCariBarang(String nilai_cari_barang) {
    setState(() {
      cari_barang.text = nilai_cari_barang;
    });
  }

  //callback catatan transaksi
  void onUpdateCatatanTransaksi(String nilai_catatan_transaksi) {
    setState(() {
      catatan_transaksi.text = nilai_catatan_transaksi;
    });
  }

  //callback tanggal transaksi
  void onUpdateSelectDate(DateTime nilai_tanggal_baru) {
    setState(() {
      _selectedDate = nilai_tanggal_baru;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ukuran layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int total_modal = 10000;
    int total_keuntungan = 20000;
    int total_keuntungan_bersih = total_keuntungan - total_modal;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Transaksi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        // leading widget list
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //trailing widget upload
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Upload ditekan!")));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // card informasi total penjualan
            Padding(
              padding: EdgeInsets.all(5),
              // mengambil class dari transaction_page_widget.dart
              child: dataTransaksi(
                screenWidth: screenWidth,
                total_modal: total_modal,
                total_keuntungan: total_keuntungan,
                total_keuntungan_bersih: total_keuntungan_bersih,
              ),
            ),

            // card input catatan, kode, dan tanggal transaksi
            Padding(
              padding: EdgeInsets.all(5),
              child: DetailTransaksi(
                screenWidth: screenWidth,
                catatan_transaksi: catatan_transaksi,
                cari_barang: cari_barang,
                onUpdateCariBarang: onUpdateCariBarang,
                onUpdateCatatanTransaksi: onUpdateCatatanTransaksi,
                onUpdateSelectDate: onUpdateSelectDate,
              ),
            ),

            // list barang
            // terdiri dari nama di bawahnya ada id, disampingnya ada harga jual di bagian kanan ada tombol tambah dan kurang
            Flexible(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(1),
                    constraints: BoxConstraints(maxHeight: 65, minHeight: 50),
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
                          flex: 20,
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
                                  'id barang $index',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // harga baranga
                        Expanded(
                          flex: 20,
                          child: Center(
                            child: Text(
                              'harga $index',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // jumlah item
                        Expanded(
                          flex: 20,
                          child: Center(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.minimize),
                                ),
                                TextFormField(
                                  controller: TextEditingController(
                                    text: '$index',
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // debug
            Text(catatan_transaksi.text.toString()),
            Text(cari_barang.text.toString()),
            Text(_selectedDate.toString()),
          ],
        ),
      ),
    );
  }
}
