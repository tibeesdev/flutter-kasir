import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/producs_input_page.dart';
import 'package:kasirapp2/transaction_provider.dart';

// card informasi transaks berisi pengeluaran, pemasukan dan total
// class dipanggi di transaction_page
class dataTransaksi extends StatelessWidget {
  const dataTransaksi({
    super.key,
    required this.screenWidth,
    required this.total_modal,
    required this.total_keuntungan,
    required this.total_keuntungan_bersih,
  });

  final double screenWidth;
  final int total_modal;
  final int total_keuntungan;
  final int total_keuntungan_bersih;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
        color: Color(0xFFbfcfff),
        border: Border.all(color: Color(0xFF6e8aff), width: 2),
      ),
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 150,
        maxWidth: screenWidth - 20,
      ),

      // membagi container awal menjadi 2 bagian, di atas untuk modal dan keuntungan di bawah buat total keuntungan bersih
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // container bagian atas
          Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            constraints: BoxConstraints.expand(height: 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              color: Color.fromARGB(14, 0, 0, 0),
            ),
            // bagi menjadi 3 row
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // pengeluaran
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(width: 150),

                  child: Column(
                    children: [
                      Text(
                        'pengeluaran',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '$total_modal',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                // garis pemisah
                VerticalDivider(color: Colors.black, thickness: 2, width: 10),
                //pemasukan
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(width: 150),

                  child: Column(
                    children: [
                      Text(
                        'pemasukan',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '$total_keuntungan',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // garis pemisah horizontal
          Divider(height: 5, thickness: 2, color: Colors.black),

          // container bagian bawah
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(14, 0, 0, 0),

              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              minWidth: screenWidth - 20 - 20,
              minHeight: 40,
            ),

            // membagi container menjadi 2 bagian
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // text total
                Text(
                  'total',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
                // text keuntungan bersih
                Text(
                  '$total_keuntungan_bersih',
                  style: TextStyle(
                    color:
                        total_keuntungan_bersih < 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// widget untuk bagian pelanggan transaski, tanggal transaksi, dan cari barang

class DetailTransaksi extends StatefulWidget {
  DetailTransaksi({
    super.key,
    required this.screenWidth,
    required this.pelanggan_transaksi,
    required this.cari_barang,
    required this.onUpdateCariBarang,
    required this.onUpdatepelangganTransaksi,
    required this.onUpdateSelectDate,
  });
  // controller
  TextEditingController pelanggan_transaksi;
  TextEditingController cari_barang;

  // lebar layar
  double screenWidth;

  // fungsi call back untuk ambil data
  final Function(String) onUpdatepelangganTransaksi;
  final Function(String) onUpdateCariBarang;
  final Function(DateTime) onUpdateSelectDate;

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  // inisiasi tanggal awal
  DateTime? _selectedDate = DateTime.now();
  // fungsi untuk datepicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      widget.onUpdateSelectDate(picked);
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFbfcfff),
        border: Border.all(color: Color(0xFF6e8aff), width: 2),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(
        minHeight: 180,
        maxWidth: widget.screenWidth - 20,
      ),
      child: Column(
        children: [
          // bagian atas
          // pelanggan transaksi
          Padding(
            padding: EdgeInsets.all(1),
            child: Container(
              //margin: EdgeInsets.all(5),
              alignment: Alignment.center,
              //color: const Color.fromARGB(255, 255, 255, 255),
              constraints: BoxConstraints(
                minHeight: 80,
                maxHeight: 80,
                maxWidth: widget.screenWidth - 20,
              ),
              // texformfielc pelanggan transaksi
              child: TextFormField(
                controller: widget.pelanggan_transaksi,
                onChanged: (value) {
                  widget.onUpdatepelangganTransaksi(value);
                  setState(() {
                    widget.pelanggan_transaksi.text = value.toString();
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  constraints: BoxConstraints(
                    maxWidth: widget.screenWidth - 30,
                    maxHeight: 90,
                  ),

                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'pelanggan transaksi',
                  prefixIcon: Icon(Icons.edit_note_outlined),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          // bagian bawah
          // terbagi menjadi tanggal transaksi dan textform cari barang
          Container(
            //margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            constraints: BoxConstraints(
              minWidth: widget.screenWidth - 20,
              minHeight: 70,
            ),
            //color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // container berisi tgl transaksi
                Container(
                  alignment: Alignment.center,
                  //padding: EdgeInsets.all(1),
                  constraints: BoxConstraints(
                    maxHeight: 50,
                    maxWidth: widget.screenWidth / 2 - 80,
                  ),

                  //color: Colors.red,
                  child: MaterialButton(
                    color: Colors.white,
                    elevation: 5,
                    minWidth: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,

                    onPressed: () => _selectDate(context),
                    child: Text('${_selectedDate.toString().split(' ')[0]}'),
                  ),
                ),

                // container cari barang
                Container(
                  alignment: Alignment.center,
                  //padding: EdgeInsets.all(5),
                  constraints: BoxConstraints(
                    maxWidth: widget.screenWidth / 2,
                    maxHeight: 50,
                  ),

                  // textform cari barang
                  child: TextFormField(
                    controller: widget.cari_barang,
                    onChanged: (value) {
                      // panggil fungsi update
                      widget.onUpdateCariBarang(value);
                      setState(() {
                        widget.cari_barang.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(
                      isDense: false,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'cari barang',
                      prefixIcon: Icon(Icons.search_outlined),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// list barang
//berisi nama, id, harga jumlah item
class ListProducts extends StatefulWidget {
  ListProducts({
    super.key,
    required this.items_controllers,
    required this.data_produk,
    required this.onChangeProductList,
    required this.kode_transaksi,
  });

  //callback
  List<TextEditingController> items_controllers;
  List<ProductsModel> data_produk;
  Function(ProductsTransactionsModel) onChangeProductList;
  String kode_transaksi;

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: widget.data_produk.length,
        itemBuilder: (context, index) {
          // data untuk setiap item
          ProductsModel data = widget.data_produk[index];
          // buat variabel baru untuk controller
          TextEditingController item_controller =
              widget.items_controllers[index];

          return Container(
            margin: EdgeInsets.all(1),
            constraints: BoxConstraints(maxHeight: 65, minHeight: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              color: Color.fromARGB(255, 255, 255, 255),
              border: Border.all(color: Color(0xFF6e8aff), width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // nama barang dan id
                  Expanded(
                    flex: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // nama barang
                        Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: Text(
                            data.nama_barang.toString(),
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
                            data.kode_barang.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // harga barang
                  Expanded(
                    flex: 20,
                    child: Center(
                      child: Text(
                        data.harga_barang.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  // jumlah item
                  Expanded(
                    flex: 20,
                    child: Center(
                      child: Row(
                        children: [
                          // tombol kurang
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                // ubah menjadi int
                                if (int.tryParse(item_controller.text) ==
                                    null) {
                                  item_controller.text = '0';
                                }
                                ;
                                // kurangi angka jika angka tidak kurang dari 0
                                if (int.parse(item_controller.text) > 0) {
                                  int item_kurang =
                                      int.parse(item_controller.text) - 1;
                                  // masukkan ke controller
                                  setState(() {
                                    item_controller.text =
                                        item_kurang.toString();
                                  });

                                  // format data
                                  ProductsTransactionsModel produk_transaksi =
                                      ProductsTransactionsModel(
                                        jumlah_item: int.parse(
                                          item_controller.text,
                                        ),
                                        kode_barang: data.kode_barang,
                                        kode_transaksi: widget.kode_transaksi,
                                      );
                                  // masukkan data ke parent class
                                  widget.onChangeProductList(produk_transaksi);
                                } else {
                                  ProductsTransactionsModel produk_transaksi =
                                      ProductsTransactionsModel(
                                        jumlah_item: int.parse(
                                          item_controller.text,
                                        ),
                                        kode_barang: data.kode_barang,
                                        kode_transaksi: widget.kode_transaksi,
                                      );
                                  // masukkan data ke parent class
                                  widget.onChangeProductList(produk_transaksi);
                                }
                              },
                              icon: Icon(Icons.remove),
                            ),
                          ),

                          // formfield untuk jumlah barang
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: item_controller,
                              textAlign: TextAlign.center,
                              keyboardType:
                                  TextInputType.number, // Untuk input angka
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  item_controller.text = value;
                                  // cek jika value != 0 maka masukkan ke dalam list
                                  if (item_controller.text != 0) {
                                    //list_
                                  }
                                });
                              },
                            ),
                          ),

                          // tombol tambah
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                // ubah menjadi int
                                if (int.tryParse(item_controller.text) ==
                                    null) {
                                  item_controller.text = '0';
                                }
                                ;
                                // tambah angka
                                int item_tambah =
                                    int.parse(item_controller.text) + 1;
                                // masukkan ke controller
                                setState(() {
                                  item_controller.text = item_tambah.toString();
                                });
                                ProductsTransactionsModel produk_transaksi =
                                    ProductsTransactionsModel(
                                      jumlah_item: int.parse(
                                        item_controller.text,
                                      ),
                                      kode_barang: data.kode_barang,
                                      kode_transaksi: widget.kode_transaksi,
                                    );
                                // masukkan data ke parent class
                                widget.onChangeProductList(produk_transaksi);
                                // widget.onUpdateController(
                                //   item_controller,
                                //   item_tambah.toString(),
                                // );
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ],
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
class cutomTabBar extends StatelessWidget {
  cutomTabBar({
    super.key,
    required this.screenWidth,
    required this.dataBaseNotifier,
    required this.addTransaction,
  });

  DataBaseNotifier dataBaseNotifier;
  void Function() addTransaction;

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 60,
        maxWidth: screenWidth - 10,
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
                  maxWidth: screenWidth / 3,
                  minWidth: screenWidth / 3,
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

          // tombol tambah di bagian tengah untuk simpan transaksi
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
                // simpan transaksi
                onPressed: () {
                  //await dataBaseNotifier.insertTransaction(row)
                  addTransaction();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: [
                          // batalkan
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('ok'),
                          ),
                        ],
                        title: Text('Transaksi berhasil ditambahakan'),
                      );
                    },
                  );
                },
                shape: CircleBorder(),
                backgroundColor: Color(0xFF6e8aff),
                foregroundColor: Colors.white,
                child: Icon(Icons.save),
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
                        (context) => InputProductsPage(
                          dataBaseNotifier: dataBaseNotifier,
                        ),
                  ),
                ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: AlignmentDirectional.center,
                constraints: BoxConstraints(
                  maxWidth: screenWidth / 3,
                  minWidth: screenWidth / 3,
                  minHeight: 50,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(33, 255, 255, 255),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Stok barang',
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
