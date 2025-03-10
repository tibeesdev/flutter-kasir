import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'database_handler/database_instance.dart';

class DataBaseNotifier extends ChangeNotifier {
  // local variabel
  List<ProductsModel> _data_produk = [];
  List<TransactionsModel> _data_transaksi = [];

  // getter untuk local variabel
  List<ProductsModel> get data_produk => _data_produk;
  List<TransactionsModel> get data_transaksi => _data_transaksi;

  // call databaseinstance
  DatabaseInstance _databaseInstance = DatabaseInstance();

  //fetch produk
  Future fetchProducts() async {
    // ambil data produk
    List<ProductsModel> produk = await _databaseInstance.showAllProducts();
    _data_produk = produk;
    print('berhasil fetch produk notifier');
    notifyListeners();
  }

  // fetchdatabase
  Future fetchTransactions() async {
    // ambil data transaksi
    List<TransactionsModel> transaksi =
        await _databaseInstance.showAllTransactions();
    _data_transaksi = transaksi;

    print('berhasil fetch transaksi notifier');
    notifyListeners();
  }

  // masukkan data
  // data transaksi
  Future insertTransaction(Map<String, dynamic> row) async {
    int kode = await _databaseInstance.insertTransactions(row);
    print('status insert transaksi : $kode');
    notifyListeners();
  }

  // data produk transaksi
  Future insertProductsTransaction(
    List<ProductsTransactionsModel> list_data,
  ) async {
    for (var element in list_data) {
      await _databaseInstance.insertProductsTransactions({
        'jumlah_item': element.jumlah_item.toString(),
        'kode_barang': element.kode_barang.toString(),
        'kode_transaksi': element.kode_transaksi.toString(),
      });
    }
  }

  // hapus data
  // hapus produk berdasarkan kode
  Future deleteProduk(String kode_produk) async {
    int kode = await _databaseInstance.deleteProduct(kode_produk);
    print('status hapus produk : $kode');
    notifyListeners();
  }

  // menambahkan list barang ke dalam variabel
  List<ProductsTransactionsModel> _list_produk = [];
  List<ProductsTransactionsModel> get list_produk => _list_produk;
  void onAddProduct(ProductsTransactionsModel produk) {
    _list_produk.add(produk);
    notifyListeners();
  }
  
}

class TimeFilter extends ChangeNotifier {
  int _filter_terpilih = 0;
  int get filter_terpilih => _filter_terpilih;
  List filter_data = [
    'semua',
    'hari ini',
    'minggu ini',
    'minggu lalu',
    'bulan ini',
    'bulan lalu',
    'custom',
  ];

  void updateFilter(int nilai_baru) {
    _filter_terpilih = nilai_baru;
    print('filter $filter_terpilih');

    notifyListeners();
  }
}
