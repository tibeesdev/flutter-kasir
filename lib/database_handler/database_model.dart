// model untuk produk
class ProductsModel {
  int? id, harga_barang, modal_barang, stok_barang;
  String? nama_barang, kode_barang;

  ProductsModel({
    this.id,
    this.harga_barang,
    this.modal_barang,
    this.stok_barang,
    this.nama_barang,
    this.kode_barang,
  });

  // factory
  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      harga_barang: json['harga_barang'],
      modal_barang: json['modal_barang'],
      stok_barang: json['stok_barang'],
      nama_barang: json['nama_barang'],
      kode_barang: json['kode_barang'],
    );
  }
}

// model untuk transaksi
class TransactionsModel {
  int? id, total_modal, total_harga, total_keuntungan;
  String? pelanggan_transaksi, kode_transaksi;

  TransactionsModel({
    this.id,
    this.total_modal,
    this.total_harga,
    this.total_keuntungan,
    this.pelanggan_transaksi,
    this.kode_transaksi,
  });

  // factory
  factory TransactionsModel.fromJson(Map<String, dynamic> json) {
    return TransactionsModel(
      id: json['id'],
      total_modal: json['total_modal'],
      total_harga: json['total_harga'],
      total_keuntungan: json['total_keuntungan'],
      pelanggan_transaksi: json['pelanggan_transaksi'],
      kode_transaksi: json['kode_transaksi'],
    );
  }
}

// model untuk produk
class ProductsTransactionsModel {
  int? id, jumlah_item,harga_barang, modal_barang;
  String? kode_barang, kode_transaksi, nama_barang;

  ProductsTransactionsModel({
    this.id,
    this.jumlah_item,
    this.kode_barang,
    this.kode_transaksi,
    this.harga_barang,
    this.modal_barang,
    this.nama_barang,
  });

  // factory
  factory ProductsTransactionsModel.fromJson(Map<String, dynamic> json) {
    return ProductsTransactionsModel(
      id: json['id'],
      jumlah_item: json['jumlah_item'],
      kode_barang: json['kode_barang'],
      kode_transaksi: json['kode_transaksi'],
      harga_barang: json['harga_barang'],
      modal_barang: json['modal_barang'],
      nama_barang: json['nama_barang'],
    );
  }
}
