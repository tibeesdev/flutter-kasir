import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasirapp2/database_handler/database_instance.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

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
        data_produk_transaksi[0].kode_transaksi;
    print('data $value');
    return value;
  }

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Text(widget.data_produk[0].kode_transaksi.toString()),
          Text(widget.data_transaksi.kode_transaksi.toString()),
        ],
      ),
    );
  }
}
