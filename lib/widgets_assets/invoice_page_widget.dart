import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_model.dart';

// widget kode transaksi
class KodeTransaksi extends StatelessWidget {
  const KodeTransaksi({
    super.key,
    required this.data_transaksi,
    required this.judul,
  });
  final String judul;
  final String data_transaksi;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text('$judul : ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            '${data_transaksi}',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}


// Tabel prdouk yang dibeli

class TableProduk extends StatelessWidget {
  const TableProduk({
    super.key,
    required this.data_produk,
  });

  final List<ProductsTransactionsModel> data_produk;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
    
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(1), // no
        1: FlexColumnWidth(3), // nama barang
        2: FlexColumnWidth(2), // harga
        3: FlexColumnWidth(1), // item dibeli
        4: FlexColumnWidth(2), // subtotal
      },
      children: [
        TableRow(
          // header untuk tabel
          children: [
            Center(
              child: Text(
                'NO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Nama Barang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Harga',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Item',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Subtotal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
    
        // Data rows
        for (int i = 0; i < data_produk.length; i++)
          TableRow(
            children: [
              Center(child: Text('${i + 1}')),
              Center(child: Text(data_produk[i].nama_barang!)),
              Center(child: Text('Rp${data_produk[i].harga_barang}')),
              Center(child: Text('${data_produk[i].jumlah_item}')),
              Center(
                child: Text(
                  'Rp${data_produk[i].harga_barang! * data_produk[i].jumlah_item!}',
                ),
              ),
            ],
          ),

          
      ],
    );
  }
}
