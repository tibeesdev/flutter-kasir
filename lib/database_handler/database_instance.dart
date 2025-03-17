import 'dart:io';

import 'package:kasirapp2/database_handler/database_model.dart';
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
  final String transaksi_pelanggan = 'pelanggan_transaksi';
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
    $produk_stok INTEGER NOT NULL,
    $produk_harga INTEGER NOT NULL)''');

    print('tabel produk berhasil dibuat');

    // buat tabel transaksi
    await db.execute('''CREATE TABLE $tabel_transaksi (
    $transaksi_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $transaksi_kode TEXT NOT NULL UNIQUE,
    $transaksi_pelanggan TEXT NOT NULL,
    $transaksi_total_modal INTEGER NOT NULL,
    $transaksi_total_harga INTEGER NOT NULL,
    $transaksi_total_keuntungan INTEGER NOT NULL)''');

    print('tabel transaksi berhasil dibuat');

    // buat tabel transaksi produk
    await db.execute('''CREATE TABLE $tabel_produk_transaksi (
    $transaksi_produk_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    $transaksi_produk_kode_transaksi TEXT NOT NULL,
    $transaksi_produk_kode_barang TEXT NOT NULL,
    $transaksi_produk_jumlah_item INTEGER NOT NULL,
    $produk_nama TEXT NOT NULL,
    $produk_modal INTEGER NOT NULL,
    $produk_harga INTEGER NOT NULL)
    ''');

    print('tabel transaksi produk berhasil dibuat');
  }

  // menampilkan semua transaksi
  Future showAllTransactions() async {
    final db = await database();
    var data = await db.rawQuery('''SELECT * FROM $tabel_transaksi''');
    // ubah bentuk data ke json
    List<TransactionsModel> result =
        data.map((e) => TransactionsModel.fromJson(e)).toList();
    return result;
  }

  // menampilkan semua produk
  Future showAllProducts() async {
    final db = await database();
    var data = await db.rawQuery('''SELECT * FROM $tabel_produk''');
    // ubah bentuk data ke json
    List<ProductsModel> result =
        data.map((e) => ProductsModel.fromJson(e)).toList();
    return result;
  }

  // menampilkan semua transaksi produk
  Future showAllTransactionsProducts() async {
    final db = await database();
    var data = await db.rawQuery('''SELECT * FROM $tabel_produk_transaksi''');
    // ubah bentuuk data ke json
    List<ProductsTransactionsModel> result =
        data.map((e) => ProductsTransactionsModel.fromJson(e)).toList();
    return result;
  }

  // input data
  // barang
  Future<int> insertProducts(Map<String, dynamic> row) async {
    final query = await database().then((db) => db.insert(tabel_produk, row));
    return query;
  }

  // transaksi
  Future<int> insertTransactions(Map<String, dynamic> row) async {
    final query = await database().then(
      (db) => db.insert(tabel_transaksi, row),
    );
    return query;
  }

  // produk transaksi
  Future<int> insertProductsTransactions(Map<String, dynamic> row) async {
    final query = await database().then(
      (db) => db.insert(tabel_produk_transaksi, row),
    );
    return query;
  }

  // fetch data berdasarkan kode
  //kode trnasksi
  Future showTransactionsByKode(String kode_transaksi) async {
    final db = await database();
    final query = await db.query(
      tabel_transaksi,
      where: '$transaksi_kode = ?',
      whereArgs: [kode_transaksi],
    );
    var res =
        query.toList().map((e) => TransactionsModel.fromJson(e)).toList()[0];
    return res;
  }

  // kode produk
  Future showProductsByKode(String kode_produk) async {
    final db = await database();
    final query = await db.query(
      tabel_transaksi,
      where: '$produk_kode = ?',
      whereArgs: [kode_produk],
    );
    var res = query.toList().map((e) => ProductsModel.fromJson(e)).toList()[0];
    return res;
  }

  // transaksi produk
  // kode produk
  Future<List<ProductsTransactionsModel>> showProductsTransactionsByKode(
    String kode_produk_transaksi,
  ) async {
    final db = await database();
    final query = await db.query(
      tabel_produk_transaksi,
      where: '$transaksi_produk_kode_transaksi = ?',
      whereArgs: [kode_produk_transaksi],
    );
    var res =
        query
            .toList()
            .map((e) => ProductsTransactionsModel.fromJson(e))
            .toList();
    return res;
  }

  // update data
  // update transaksi
  Future<int> updateTransactions(Map<String, dynamic> row) async {
    final db = await database();
    final query = await db.update(
      tabel_transaksi,
      row,
      where: '$transaksi_kode = ?',
      whereArgs: [row[transaksi_id]],
    );
    return query;
  }

  // update transaksi
  Future<int> updateProduct(Map<String, dynamic> row) async {
    final db = await database();
    final query = await db.update(
      tabel_produk,
      row,
      where: '$produk_kode = ?',
      whereArgs: [row[produk_kode]],
    );
    return query;
  }


  // hapus data
  // hapus produk berdasarkana kode
  Future<int> deleteProduct(String kode_barang) async {
    final db = await database();
    final query = await db.delete(
      tabel_produk,
      where: '$produk_kode = ?',
      whereArgs: [kode_barang],
    );
    return query;
  }

  // hapus transaksi berdasarkan kode
  // hapus produk berdasarkana kode
  Future<List<int>> deleteTransaction(String kode_transaksi) async {
    final db = await database();
    final query = await db.delete(
      tabel_transaksi,
      where: '$transaksi_kode = ?',
      whereArgs: [kode_transaksi],
    );
    final query2 = await db.delete(
      tabel_produk_transaksi,
      where: '$transaksi_produk_kode_transaksi = ?',
      whereArgs: [kode_transaksi],
    );

    return [query, query2];
  }
}
