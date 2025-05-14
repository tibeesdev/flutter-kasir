import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'database_handler/database_instance.dart';

class DataBaseNotifier extends ChangeNotifier {
  /////////////////////////////
  int _filter_terpilih = 0;
  int _total_modal = 0;
  int _total_keuntungan = 0;
  int _total_keuntungan_bersih = 0;

  // getter
  int get total_modal => _total_modal;
  int get total_keuntungan => _total_keuntungan;
  int get total_keuntungan_bersih => _total_keuntungan_bersih;
  int get filter_terpilih => _filter_terpilih;

  // getter untuk local variabel
  List<ProductsModel> get data_produk => _data_produk;
  List<TransactionsModel> get data_transaksi => _data_transaksi;
  TransactionsModel get data_transaksi_kode => _kode_data_transaksi;
  List<ProductsTransactionsModel> get data_produk_kode =>
      _kode_produk_transaksi;

  // local variabel
  // list data produk dan data transaksi
  List<ProductsModel> _data_produk = [];
  List<TransactionsModel> _data_transaksi = [];

  // list berisi data informasi transaksi dan produknya
  // data transaki dan dan data produk dalam transaksi, diambil berdasarkan kode transaksi
  TransactionsModel _kode_data_transaksi = TransactionsModel();
  List<ProductsTransactionsModel> _kode_produk_transaksi = [];

  // call databaseinstance
  DatabaseInstance _databaseInstance = DatabaseInstance();

  //fetch produk
  Future fetchProducts() async {
    // ambil data produk
    List<ProductsModel> produk = await _databaseInstance.showAllProducts();
    _data_produk = produk;
    notifyListeners();
  }

  // fetchdatabase
  Future fetchTransactions() async {
    // ambil data transaksi
    List<TransactionsModel> transaksi =
        await _databaseInstance.showAllTransactions();
    _data_transaksi = transaksi;

    // proses data transaksi
    // local variable
    int local_modal = 0;
    int local_harga = 0;
    int local_keuntungan = 0;
    // for loop data transaksi
    List<TransactionsModel> data_transaksi = _data_transaksi;
    for (var element in data_transaksi) {
      local_modal = local_modal + element.total_modal!;
      local_harga = local_harga + element.total_harga!;
      local_keuntungan = local_harga - local_modal;
    }
    // assign ke global variabel

    _total_modal = local_modal;
    _total_keuntungan = local_harga;
    _total_keuntungan_bersih = local_keuntungan;
    notifyListeners();
  }

  // fetch transaksi dan produuk berdasarkan kode transaksi
  // ditampilkan untuk dibuat invoice
  Future fetchTransactionProducts(String kode_transaksi) async {
    TransactionsModel transaksi = await _databaseInstance
        .showTransactionsByKode(kode_transaksi);
    _kode_data_transaksi = transaksi;

    List<ProductsTransactionsModel> produk = await _databaseInstance
        .showProductsTransactionsByKode(kode_transaksi);
    _kode_produk_transaksi = produk;

    notifyListeners();
  }

  // masukkan data
  // data transaksi
  Future insertTransaction(Map<String, dynamic> row) async {
    int kode = await _databaseInstance.insertTransactions(row);
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
        'harga_barang': element.harga_barang.toString(),
        'modal_barang': element.modal_barang.toString(),
        'nama_barang': element.nama_barang.toString(),
      });
    }
  }

  // hapus data
  // hapus produk berdasarkan kode
  Future deleteProduk(String kode_produk) async {
    int kode = await _databaseInstance.deleteProduct(kode_produk);
    notifyListeners();
  }

  // hapus transaksi
  Future deleteTransaksi(String kode_transaksi) async {
    List<int> kode = await _databaseInstance.deleteTransaction(kode_transaksi);
    notifyListeners();
  }

  // menambahkan list barang ke dalam variabel
  List<ProductsTransactionsModel> _list_produk = [];
  List<ProductsTransactionsModel> get list_produk => _list_produk;
  void onAddProduct(ProductsTransactionsModel produk) {
    _list_produk.add(produk);
    notifyListeners();
  }

  // update jumlah item produk ketika ada yang membeli produk
  void updateJumlahProduk(String kode_produk, int stok_baru) {
    _databaseInstance.updateProductStock(kode_produk, stok_baru);
    notifyListeners();
  }
}

class TimeFilter extends ChangeNotifier {
  int _filter_terpilih = 0;

  // getter

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
    notifyListeners();
  }
}
