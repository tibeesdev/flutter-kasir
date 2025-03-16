import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_instance.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/invoice_page.dart';
import 'package:kasirapp2/transaction_page.dart';
import 'package:kasirapp2/producs_input_page.dart';
import 'package:kasirapp2/transaction_provider.dart';

// widget filter waktu
class filterJangkaWaktu extends StatefulWidget {
  filterJangkaWaktu({super.key, required this.timeFilter});
  TimeFilter timeFilter;

  @override
  State<filterJangkaWaktu> createState() => _filterJangkaWaktuState();
}

class _filterJangkaWaktuState extends State<filterJangkaWaktu> {
  //TimeFilter timeFilter = TimeFilter();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ListenableBuilder(
      listenable: widget.timeFilter,
      builder: (context, child) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(1),
          constraints: BoxConstraints(
            minHeight: 50,
            maxHeight: 50,
            maxWidth: screenWidth,
          ),
          color: Colors.white,
          child: Container(
            child: ListView.builder(
              itemCount: widget.timeFilter.filter_data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                bool terpilih = widget.timeFilter.filter_terpilih == index;
                return GestureDetector(
                  onTap: () {
                    widget.timeFilter.updateFilter(index);
                    //setState(() {});
                  },
                  child: Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints(minWidth: 50),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: terpilih ? Color(0xFF6e8aff) : Color(0xFFbfcfff),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget
                            .timeFilter
                            .filter_data[index], //widget.filter_data[index],
                        style:
                            terpilih
                                ? TextStyle(color: Colors.white)
                                : TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// widget card data transaksi
class dataTransaksi extends StatelessWidget {
  dataTransaksi({
    super.key,
    required this.screenWidth,
    // required this.total_modal,
    // required this.total_keuntungan,
    // required this.total_keuntungan_bersih,
    required this.dataBaseNotifier,
  });

  final double screenWidth;
  // final int total_modal;
  // final int total_keuntungan;
  // final int total_keuntungan_bersih;
  DataBaseNotifier dataBaseNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: dataBaseNotifier,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: Color(0xFFbfcfff),
            border: Border.all(color: Color(0xFF6e8aff), width: 2),
          ),
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: 150,
            maxWidth: screenWidth - 20,
          ),

          // membagi container awal menjadi 2 bagian, di atas untuk modal dan keuntungan di bawah buat total keuntungan bersih
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // container bagian atas
              Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                constraints: BoxConstraints.expand(height: 80),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(14, 0, 0, 0),
                ),
                // bagi menjadi 3 row
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // pengeluaran
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      constraints: BoxConstraints.expand(width: 150),

                      child: Column(
                        children: [
                          Text(
                            'pengeluaran',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${dataBaseNotifier.total_modal}',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    // garis pemisah
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                      width: 10,
                    ),
                    //pemasukan
                    Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      constraints: BoxConstraints.expand(width: 150),

                      child: Column(
                        children: [
                          Text(
                            'pemasukan',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${dataBaseNotifier.total_keuntungan}',
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // garis pemisah horizontal
              Divider(height: 5, thickness: 2, color: Colors.black),

              // container bagian bawah
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(14, 0, 0, 0),

                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  minWidth: screenWidth - 20 - 20,
                  minHeight: 40,
                ),

                // membagi container menjadi 2 bagian
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // text total
                    Text(
                      'total',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                    // text keuntungan bersih
                    Text(
                      '${dataBaseNotifier.total_keuntungan_bersih}',
                      style: TextStyle(
                        color:
                            dataBaseNotifier.total_keuntungan_bersih < 0
                                ? Colors.red
                                : Colors.green,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// header untuk data transaksi berisi teks pelanggan, pengeluaran dan pemasukan
class headerDataTransaksi extends StatelessWidget {
  const headerDataTransaksi({super.key, required this.screenWidth});

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
            flex: 40,
            child: Center(
              child: Text(
                'pelanggan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'pengeluaran',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'pemasukan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// informasi transaksi lengkap (buat sistem onclicknya)
class informasiTransaksi extends StatefulWidget {
  informasiTransaksi({
    super.key,
    required this.data_transaksi,
    required this.dataBaseNotifier,
  });
  // list berisi data transaksi
  List<TransactionsModel> data_transaksi = [];
  DataBaseNotifier dataBaseNotifier;

  @override
  State<informasiTransaksi> createState() => _informasiTransaksiState();
}

class _informasiTransaksiState extends State<informasiTransaksi> {
  // inisiasi database
  DatabaseInstance databaseInstance = DatabaseInstance();
  @override
  Widget build(BuildContext context) {
    return widget.data_transaksi.length == 0
        ? Center(child: Text('belum ada transkasi yang dibuat'))
        : Flexible(
          child: ListView.builder(
            itemCount: widget.data_transaksi.length,
            itemBuilder: (context, index) {
              // masukkan data transaksi ke dalam varabel agar mudah diakses
              TransactionsModel data_transaksi = widget.data_transaksi[index];
              // untuk fungsi on click pakai gesture detetctor

              return GestureDetector(
                // ketika disentuh maka akan memanggil data yang sesuai
                onTap: () async {
                  final String kode_transaksi_tap =
                      widget.data_transaksi[index].kode_transaksi!;
                  print(kode_transaksi_tap);
                  TransactionsModel data = await databaseInstance
                      .showTransactionsByKode(kode_transaksi_tap);
                  print(data.pelanggan_transaksi);

                  // page informasi transaksi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => InvoicePage(
                            kode_transaksi: kode_transaksi_tap,
                            dataBaseNotifier: widget.dataBaseNotifier,
                          ),
                    ),
                  );
                },

                // hapus transaksi
                onLongPress: () {
                  final String kode_transaksi_tap =
                      widget.data_transaksi[index].kode_transaksi!;
                  showDialog(
                    context: context,
                    builder: (context) {
                      // alertdialog konfirmasi hapus barang
                      return AlertDialog(
                        content: Text(
                          'hapus transaksi : $kode_transaksi_tap ?',
                        ),
                        actions: [
                          // batalkan
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('batalkan'),
                          ),

                          // konfirmasi hapus
                          ElevatedButton(
                            onPressed: () {
                              // hapus produk
                              widget.dataBaseNotifier.deleteTransaksi(
                                kode_transaksi_tap,
                              );
                              // fetch ulang data
                              widget.dataBaseNotifier.fetchTransactions();
                              // tutup jendela
                              Navigator.pop(context);
                            },
                            child: Text('hapus'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(5),
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
                      Expanded(
                        flex: 40,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                data_transaksi.pelanggan_transaksi.toString(),
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
                                data_transaksi.kode_transaksi.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: Center(
                          child: Text(
                            data_transaksi.total_modal.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: Center(
                          child: Text(
                            data_transaksi.total_harga.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }
}

// tabbar custom
class cutomTabBar extends StatefulWidget {
  cutomTabBar({
    super.key,
    required this.screenWidth,
    required this.dataBaseNotifier,
    required this.timeFilter,
  });

  final double screenWidth;
  DataBaseNotifier dataBaseNotifier;
  TimeFilter timeFilter;

  @override
  State<cutomTabBar> createState() => _cutomTabBarState();
}

class _cutomTabBarState extends State<cutomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 60,
        maxWidth: widget.screenWidth - 10,
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
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => InputProductsPage(
                          dataBaseNotifier: widget.dataBaseNotifier,
                        ),
                  ),
                ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: AlignmentDirectional.center,
                constraints: BoxConstraints(
                  maxWidth: widget.screenWidth / 3,
                  minWidth: widget.screenWidth / 3,
                  minHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(33, 255, 255, 255),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'kelola stok',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // tombol tambah di bagian tengah
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TransactionPage(
                            dataBaseNotifier: widget.dataBaseNotifier,
                            timeFilter: widget.timeFilter,
                          ),
                    ),
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
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              alignment: AlignmentDirectional.center,
              constraints: BoxConstraints(
                maxWidth: widget.screenWidth / 3,
                minWidth: widget.screenWidth / 3,
                minHeight: 50,
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(33, 255, 255, 255),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Statistik',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
