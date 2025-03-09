import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'widgets_assets/transaction_page_widget.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({super.key, required this.dataBaseNotifier});

  DataBaseNotifier dataBaseNotifier;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // inisiasi tanggal awal
  DateTime? _selectedDate = DateTime.now();
  // controller
  TextEditingController catatan_transaksi = TextEditingController();
  TextEditingController cari_barang = TextEditingController();
  List<TextEditingController> items_controllers =
      []; // controller untuk list barang
  List data = List.generate(10, (index) => index += 1);

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

  // callback jumlah item barang
  void onUpdateController(TextEditingController item, String value) {
    setState(() {
      item.text = value;
    });
  }

  // pembuatan controller ketika data dimuat
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // membuat controller dummy
    items_controllers = List.generate(
      data.length,
      (index) => TextEditingController(text: index.toString()),
    );
  }

  // dispose resource untuk menghindari memory leak
  @override
  void dispose() {
    // TODO: implement dispose
    // Hapus semua controller saat widget dihancurkan
    for (var controller in items_controllers) {
      controller.dispose();
    }
    catatan_transaksi.dispose();
    cari_barang.dispose();
    super.dispose();
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
            ListProducts(
              items_controllers: items_controllers,
              data: data,
              onUpdateController: onUpdateController,
            ),

            // debug
            // Text(items_controllers[0].text.toString()),
            // Text(cari_barang.text.toString()),
            // Text(_selectedDate.toString()),
            cutomTabBar(screenWidth: screenWidth, dataBaseNotifier: widget.dataBaseNotifier),
          ],
        ),
      ),
    );
  }
}
