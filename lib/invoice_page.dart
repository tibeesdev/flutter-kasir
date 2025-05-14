import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_instance.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'package:kasirapp2/widgets_assets/invoice_page_widget.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({
    super.key,
    required this.kode_transaksi,
    required this.dataBaseNotifier,
    required this.data_produk,
    required this.data_transaksi,
  });

  final String kode_transaksi;
  final DataBaseNotifier dataBaseNotifier;
  final TransactionsModel data_transaksi;
  final List<ProductsTransactionsModel> data_produk;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  String pdfpath = '';

  // ambil data transaksi dan produknya
  Future<bool> _fetchData() async {
    final databaseinstance = DatabaseInstance();
    TransactionsModel data_transaksi = await databaseinstance
        .showTransactionsByKode(widget.kode_transaksi);
    List<ProductsTransactionsModel> data_produk_transaksi =
        await databaseinstance.showProductsTransactionsByKode(
          widget.kode_transaksi,
        );

    bool value =
        data_transaksi.kode_transaksi ==
        data_produk_transaksi[0].kode_transaksi;;
    return value;
  }

  // ubah kode transaksi menjadi tanggal
  String formatKodeTransaksi(String kodeTransaksi) {
    // Ambil 14 karakter pertama
    final rawDate = kodeTransaksi.split('_').first;

    if (rawDate.length != 14) return 'Format tidak valid';

    final tahun = rawDate.substring(0, 4);
    final bulan = rawDate.substring(4, 6);
    final tanggal = rawDate.substring(6, 8);
    final jam = rawDate.substring(8, 10);
    final menit = rawDate.substring(10, 12);
    final detik = rawDate.substring(12, 14);

    return '$tanggal-$bulan-$tahun $jam:$menit:$detik';
  }

  // buat total belanja
  int totalHarga(List<ProductsTransactionsModel> data_produk) {
    int total = 0;
    for (ProductsTransactionsModel produk in data_produk) {
      total += produk.harga_barang! * produk.jumlah_item!;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    // masukkan ke variabel agar mudah dipakai
    TransactionsModel data_transaksi = widget.data_transaksi;
    List<ProductsTransactionsModel> data_produk = widget.data_produk;

    // lebar layar
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('INVOICE'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        constraints: BoxConstraints(minWidth: width - 10),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black38),
        ),
        child: Column(
          children: [
            // kode transaksi
            KodeTransaksi(
              judul: 'Kode Transaksi',
              data_transaksi: data_transaksi.kode_transaksi!,
            ),

            // Tanggal Transaksi
            // reuse aja widgetnnya karena formatnya sama
            KodeTransaksi(
              judul: "Tanggal Transaksi",
              data_transaksi: formatKodeTransaksi(
                data_transaksi.kode_transaksi!,
              ),
            ),

            // Nama Pembeli
            // reuse lagi
            KodeTransaksi(
              data_transaksi: data_transaksi.pelanggan_transaksi!,
              judul: 'Pembeli',
            ),

            // tabel produk
            TableProduk(data_produk: data_produk),

            // total seluruh transaksi
            KodeTransaksi(
              data_transaksi: totalHarga(data_produk).toString(),
              judul: 'Total Harga',
            ),
          ],
        ),
      ),
    );
  }
}
