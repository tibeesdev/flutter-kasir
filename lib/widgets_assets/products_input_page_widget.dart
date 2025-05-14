import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_instance.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/transaction_page.dart';
import 'package:kasirapp2/transaction_provider.dart';

// header untuk data produk berisi teks pelanggan, pengeluaran dan pemasukan
class headerDataProduk extends StatelessWidget {
  const headerDataProduk({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      constraints: BoxConstraints(
        maxWidth: screenWidth - 20,
        maxHeight: 60,
        minHeight: 50,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Color(0xFFbfcfff),
        border: Border.all(color: Color(0xFF6e8aff), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 30,
            child: Center(
              child: Text(
                'nama barang',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: Center(
              child: Text(
                'stok',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'modal',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'harga jual',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// list barang beserta harga dan stoknya

class ListBarang extends StatefulWidget {
  ListBarang({
    super.key,
    required this.data_produk,
    required this.dataBaseNotifier,
  });

  List data_produk;
  DataBaseNotifier dataBaseNotifier;

  @override
  State<ListBarang> createState() => _ListBarangState();
}

class _ListBarangState extends State<ListBarang> {
  @override
  Widget build(BuildContext context) {
    List<ProductsModel> data_produk = widget.dataBaseNotifier.data_produk;
    return data_produk.length == 0
        ? Text('tidak ada data barang')
        : Flexible(
          child: ListView.builder(
            itemCount: data_produk.length,
            itemBuilder: (context, index) {
              ProductsModel produk = data_produk[index];
              // gesture detector untuk menambah opsi edit update dan delete

              return GestureDetector(
                onLongPress: () {
                  // kode produk
                  String kode_produk = produk.kode_barang!;
                  //tampilkan alert dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      // alertdialog konfirmasi hapus barang
                      return AlertDialog(
                        content: Text('hapus produk : $kode_produk?'),
                        actions: [
                          // batalkan
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('batalkan'),
                          ),

                          // konfirmasi hapus
                          ElevatedButton(
                            onPressed: () {
                              // hapus produk
                              widget.dataBaseNotifier.deleteProduk(kode_produk);
                              // fetch ulang data
                              widget.dataBaseNotifier.fetchProducts();
                              // tutup jendela
                              Navigator.pop(context);
                            },
                            child: Text('hapus'),
                          ),
                        ],
                      );
                    },
                  );
                },

                // edit dialog
                onTap: () {
                  String kode_barang = produk.kode_barang!;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditBarangDialog(
                        dataBaseNotifier: widget.dataBaseNotifier,
                        kode_barang: kode_barang,
                      );
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(1),
                  constraints: BoxConstraints(maxHeight: 70, minHeight: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(color: Color(0xFF6e8aff), width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // nama barang dan id
                      Expanded(
                        flex: 30,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // nama barang
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                produk.nama_barang.toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),

                            // id transaksi
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                produk.kode_barang.toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // stok barang
                      Expanded(
                        flex: 20,
                        child: Center(
                          child: Text(
                            produk.stok_barang.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // modal
                      Expanded(
                        flex: 25,
                        child: Center(
                          child: Text(
                            produk.modal_barang.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      // harga
                      Expanded(
                        flex: 25,
                        child: Center(
                          child: Text(
                            produk.harga_barang.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
  }
}

// custom tabbar
class cutomTabBar extends StatefulWidget {
  cutomTabBar({
    super.key,
    required this.screenWidth,
    required this.onInsertProduct,
    required this.dataBaseNotifier,
    required this.timeFilter,
  });

  DataBaseNotifier dataBaseNotifier;
  TimeFilter timeFilter;

  final double screenWidth;
  Future Function() onInsertProduct;

  @override
  State<cutomTabBar> createState() => _cutomTabBarState();
}

class _cutomTabBarState extends State<cutomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 60,
        maxWidth: widget.screenWidth - 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        shape: BoxShape.rectangle,
        color: Color(0xFF6e8aff),
      ),
      // bagi tabbar menjadi 3 bagian
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // tombol sebelah kiri
          // tombol kasir untuk kembali ke menu kasir
          Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: AlignmentDirectional.center,
                constraints: BoxConstraints(
                  maxWidth: widget.screenWidth / 3,
                  minWidth: widget.screenWidth / 3,
                  minHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(33, 255, 255, 255),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'kasir',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // tombol tambah di bagian tengah untuk tambah produk
          Transform.translate(
            offset: Offset(0, -20),
            transformHitTests: true,
            child: Container(
              alignment: Alignment.center,
              width: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  // fungsi untuk menambahkan barang
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TambahBarangDialog(
                        dataBaseNotifier: widget.dataBaseNotifier,
                      );
                    },
                  );
                },
                shape: CircleBorder(),
                backgroundColor: Color(0xFF6e8aff),
                foregroundColor: Colors.white,
                child: Icon(Icons.add),
              ),
            ),
          ),

          // tombol sebelah kanan'
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TransactionPage(
                          dataBaseNotifier: widget.dataBaseNotifier,
                          timeFilter: widget.timeFilter,
                        ),
                  ),
                ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: AlignmentDirectional.center,
                constraints: BoxConstraints(
                  maxWidth: widget.screenWidth / 3,
                  minWidth: widget.screenWidth / 3,
                  minHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(33, 255, 255, 255),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Transaksi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// alert dialog
// untuk tambah barang
class TambahBarangDialog extends StatefulWidget {
  TambahBarangDialog({super.key, required this.dataBaseNotifier});
  DataBaseNotifier dataBaseNotifier;

  @override
  State<TambahBarangDialog> createState() => _TambahBarangDialogState();
}

class _TambahBarangDialogState extends State<TambahBarangDialog> {
  TextEditingController kode_barang_controller = TextEditingController();
  TextEditingController nama_barang_controller = TextEditingController();
  TextEditingController modal_barang_controller = TextEditingController();
  TextEditingController harga_barang_controller = TextEditingController();
  TextEditingController stok_barang_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // buat variabel agar lebih mudak diakses
    List<ProductsModel> data_produk = widget.dataBaseNotifier.data_produk;

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      alignment: Alignment.center,
      icon: Icon(Icons.bar_chart_outlined),
      scrollable: true,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 5,
      actionsOverflowDirection: VerticalDirection.down,
      title: Text('Masukkan Informasi Barang'),

      // formfield
      content: Column(
        children: [
          // kode barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                // cek jika kode sudah digunakan
                bool exists = data_produk.any(
                  (list) => list.kode_barang == value,
                );
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } // cek jika key sudah ada di dalam database
                else if (exists) {
                  return 'kode barang sudah dipakai';
                }
              },
              controller: kode_barang_controller,
              onChanged: (value) {
                setState(() {
                  kode_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'kode barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // nama barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: nama_barang_controller,
              onChanged: (value) {
                setState(() {
                  nama_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'nama barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // modal barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } else if (int.tryParse(value) == null) {
                  return 'data harus dalam angka';
                }
              },
              controller: modal_barang_controller,
              onChanged: (value) {
                setState(() {
                  modal_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'modal',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // harga barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } else if (int.tryParse(value) == null) {
                  return 'data harus dalam angka';
                }
              },
              controller: harga_barang_controller,
              onChanged: (value) {
                setState(() {
                  harga_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'harga',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // stok barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } else if (int.tryParse(value) == null) {
                  return 'data harus dalam angka';
                }
              },
              controller: stok_barang_controller,
              onChanged: (value) {
                setState(() {
                  stok_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'stok',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('batalkan'),
        ),
        ElevatedButton(
          onPressed: () async {
            // inisiasi database
            DatabaseInstance databaseInstance = DatabaseInstance();
            // masukkan data baru ke dalam database
            await databaseInstance.insertProducts({
              'harga_barang': int.tryParse(harga_barang_controller.text),
              'modal_barang': int.tryParse(modal_barang_controller.text),
              'stok_barang': int.tryParse(stok_barang_controller.text),
              'nama_barang': nama_barang_controller.text,
              'kode_barang': kode_barang_controller.text,
            });
            // fetch ulang data
            await widget.dataBaseNotifier.fetchProducts();
            //tutup jendela
            Navigator.pop(context);
          },
          child: Text('simpan'),
        ),
      ],
    );
  }
}

// edit barang
// untuk tambah barang
class EditBarangDialog extends StatefulWidget {
  EditBarangDialog({
    super.key,
    required this.dataBaseNotifier,
    required this.kode_barang,
  });
  DataBaseNotifier dataBaseNotifier;
  String kode_barang;

  @override
  State<EditBarangDialog> createState() => _EditBarangDialogState();
}

class _EditBarangDialogState extends State<EditBarangDialog> {
  // controller
  TextEditingController kode_barang_controller = TextEditingController();
  TextEditingController nama_barang_controller = TextEditingController();
  TextEditingController modal_barang_controller = TextEditingController();
  TextEditingController harga_barang_controller = TextEditingController();
  TextEditingController stok_barang_controller = TextEditingController();

  // data barang
  ProductsModel produk = ProductsModel();

  // inisiasi data barang
  @override
  void initState() {
    // inisiasi data
    produk =
        widget.dataBaseNotifier.data_produk
            .where((x) => x.kode_barang == widget.kode_barang)
            .first;
    // inisiasi text di controller
    kode_barang_controller.text = produk.kode_barang!;
    nama_barang_controller.text = produk.nama_barang!;
    modal_barang_controller.text = produk.modal_barang.toString();
    harga_barang_controller.text = produk.harga_barang.toString();
    stok_barang_controller.text = produk.stok_barang.toString();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // buat variabel agar lebih mudak diakses
    List<ProductsModel> data_produk = widget.dataBaseNotifier.data_produk;

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      alignment: Alignment.center,
      icon: Icon(Icons.bar_chart_outlined),
      scrollable: true,
      actionsOverflowAlignment: OverflowBarAlignment.center,
      actionsOverflowButtonSpacing: 5,
      actionsOverflowDirection: VerticalDirection.down,
      title: Text('Edit Informasi Barang'),

      // formfield
      content: Column(
        children: [
          // kode barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                // cek jika kode sudah digunakan
                bool exists = data_produk.any(
                  (list) => list.kode_barang == value,
                );
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } // cek jika key sudah ada di dalam database
                else if (exists && value != produk.kode_barang) {
                  return 'kode barang sudah dipakai';
                }
              },
              controller: kode_barang_controller,
              onChanged: (value) {
                setState(() {
                  kode_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'kode barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // nama barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                }
              },
              controller: nama_barang_controller,
              onChanged: (value) {
                setState(() {
                  nama_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'nama barang',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // modal barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } else if (int.tryParse(value) == null) {
                  return 'data harus dalam angka';
                }
              },
              controller: modal_barang_controller,
              onChanged: (value) {
                setState(() {
                  modal_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'modal',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // harga barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } else if (int.tryParse(value) == null) {
                  return 'data harus dalam angka';
                }
              },
              controller: harga_barang_controller,
              onChanged: (value) {
                setState(() {
                  harga_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'harga',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // stok barang
          Container(
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(),
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'data tidak boleh kosong';
                } else if (int.tryParse(value) == null) {
                  return 'data harus dalam angka';
                }
              },
              controller: stok_barang_controller,
              onChanged: (value) {
                setState(() {
                  stok_barang_controller.text = value;
                });
              },
              canRequestFocus: true,
              decoration: InputDecoration(
                labelText: 'stok',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('batalkan'),
        ),
        ElevatedButton(
          onPressed: () async {
            // inisiasi database
            DatabaseInstance databaseInstance = DatabaseInstance();
            // masukkan data baru ke dalam database
            await databaseInstance.updateProduct({
              'harga_barang': int.tryParse(harga_barang_controller.text),
              'modal_barang': int.tryParse(modal_barang_controller.text),
              'stok_barang': int.tryParse(stok_barang_controller.text),
              'nama_barang': nama_barang_controller.text,
              'kode_barang': kode_barang_controller.text,
            });
            // fetch ulang data
            await widget.dataBaseNotifier.fetchProducts();
            //tutup jendela
            Navigator.pop(context);
          },
          child: Text('simpan'),
        ),
      ],
    );
  }
}
