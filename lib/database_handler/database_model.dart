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
