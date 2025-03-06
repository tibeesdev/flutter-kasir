import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseInstance {
  // informasi database
  final String nama_database = 'kasir.db';
  final String versi_database = '1';

  // informasi tabel
  final String tabel_produk = 'Produk';
  final String tabel_transaksi = 'Transaksi';
  final String tabel_produk_transaksi = 'ProdukTransaksi';

  // kolom produk
  final String produk_id = 'id';
  final String produk_nama = 'nama_barang';
  final String produk_kode = 'kode_barang';
  final String produk_harga = 'harga_barang';
  final String produk_modal = 'modal_barang';
  final String produk_stok = 'stok_barang';

  // kolom transaksi
  final String transaksi_id = 'id';
  final String transaksi_kode = 'kode_transaksi';
  final String transaksi_catatan = 'catatan_transaksi';
  final String transaksi_total_modal = 'total_modal';
  final String transaksi_total_harga = 'total_harga';
  final String transaksi_total_keuntungan = 'total_keuntungan';

  // kolom transaksi produk
  final String transaksi_produk_id = 'id';
  final String transaksi_produk_jumlah_item = 'jumlah_item';
  final String transaksi_produk_kode_barang = 'kode_barang';
  final String transaksi_produk_kode_transaksi = 'kode_transaksi';

  // fungsi
  // inisiasi database
  Database? _database;
  Future<Database> database() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  // inisiasi
  Future _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
  }
}
