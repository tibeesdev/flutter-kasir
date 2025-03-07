import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseInstance {
  // informasi database
  final String nama_database = 'kasir.db';
  final versi_database = 1;

  // informasi tabel
  final tabel_produk = 'Produk';
  final tabel_transaksi = 'Transaksi';
  final tabel_produk_transaksi = 'ProdukTransaksi';

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
    String path = join(documentDirectory.path, nama_database);
    return openDatabase(path, onCreate: onCreateDB, version: versi_database);
  }

  // buat database jika belum ada
  Future onCreateDB(Database db, int version) async {
    // buat tabel produk
    await db.execute('''CREATE TABLE $tabel_produk (
    $produk_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $produk_kode TEXT NOT NULL UNIQUE,
    $produk_nama TEXT NOT NULL,
    $produk_modal INTEGER NOT NULL,
    $produk_stok INTEGER NOT NULL)''');

    print('tabel produk berhasil dibuat');

    // buat tabel transaksi
    await db.execute('''CREATE TABLE $tabel_transaksi (
    $transaksi_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $transaksi_kode TEXT NOT NULL UNIQUE,
    $transaksi_catatan TEXT NOT NULL,
    $transaksi_total_modal INTEGER NOT NULL,
    $transaksi_total_harga INTEGER NOT NULL,
    $transaksi_total_keuntungan INTEGER NOT NULL)''');

    print('tabel transaksi berhasil dibuat');

    // buat tabel transaksi produk
    await db.execute('''CREATE TABLE $tabel_produk_transaksi (
    $transaksi_produk_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $transaksi_produk_kode_transaksi TEXT NOT NULL,
    $transaksi_produk_kode_barang TEXT NOT NULL,
    $transaksi_produk_jumlah_item INTEGER NOT NULL)
    ''');

    print('tabel transaksi produk berhasil dibuat');
  }
}
