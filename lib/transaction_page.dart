import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'widgets_assets/transaction_page_widget.dart';

class TransactionPage extends StatefulWidget {
  TransactionPage({
    super.key,
    required this.dataBaseNotifier,
    required this.timeFilter,
  });

  DataBaseNotifier dataBaseNotifier;
  TimeFilter timeFilter;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // variabel keutungan untuk di bagaian card informasi transaksi di bagian atas
  int total_modal = 0;
  int total_harga = 0;
  int total_keuntungan_bersih = 0;
  // kode transaksi
  String kode_transaksi = '';
  // inisiasi tanggal awal
  DateTime? _selectedDate = DateTime.now();
  // controller
  TextEditingController pelanggan_transaksi = TextEditingController();
  TextEditingController cari_barang = TextEditingController();
  List<TextEditingController> items_controllers =
      []; // controller untuk list barang
  List<ProductsModel> original_data_produk = [];
  // list produk berdasarkan filter user dari input user
  List<ProductsModel> data_produk = [];
  // list produk yang dibeli (jika lebih dari 0)
  List<ProductsTransactionsModel> list_produk = [];

  // fungsi callback
  // callback text cari barang
  void onUpdateCariBarang(String nilai_cari_barang) {
    setState(() {
      cari_barang.text = nilai_cari_barang;
      // panggil fungsi filter
      _filteredList(nilai_cari_barang);
    });
  }

  //callback pelanggan transaksi
  void onUpdatepelangganTransaksi(String nilai_pelanggan_transaksi) {
    setState(() {
      pelanggan_transaksi.text = nilai_pelanggan_transaksi;
    });
  }

  //callback tanggal transaksi
  void onUpdateSelectDate(DateTime nilai_tanggal_baru) {
    setState(() {
      _selectedDate = nilai_tanggal_baru;
    });
  }

  // ketika jumlah item di produk berubah, fungsi callback di ListProducts
  // ketika ditambah
  void onChangeProductList(ProductsTransactionsModel produk) {
    // cek jika data sudah ada di dalam list
    int data_index = list_produk.indexWhere(
      (data) => data.kode_barang == produk.kode_barang,
    );

    // jika data ditemukan
    if (data_index != -1) {
      setState(() {
        int item = produk.jumlah_item!;

        list_produk[data_index].jumlah_item = item;
        // jika jumlah item 0 maka remove saja dari list
        if (item == 0) {
          list_produk.removeAt(data_index);
          print(data_index.toString());
        }
      });
    } else {
      // jika data tdak ditemukan
      setState(() {
        // cari produk di original_data_produk berdasarkan kode_barang
        int index = original_data_produk.indexWhere(
          (data) => data.kode_barang == produk.kode_barang,
        );
        if (index != -1) {
          // set harga_barang dan modal_barang dari original_data_produk
          produk.harga_barang = original_data_produk[index].harga_barang;
          produk.modal_barang = original_data_produk[index].modal_barang;
          // set nama_barang dari original_data_produk
          produk.nama_barang =
              original_data_produk[index].nama_barang.toString();
        }
        list_produk.add(produk);
      });
    }
    transactionCounter();

    print('total_modal : $total_modal');
  }

  // hitung modal, keuntungan dan harga total
  void transactionCounter() {
    // variabel lokal
    int local_modal = 0;
    int local_harga = 0;
    int local_keuntungan = 0;
    // cari index barang di original produk berdasarkan kode barang di list produk yang dibeli
    for (var element in list_produk) {
      int index = original_data_produk.indexWhere(
        (data) => data.kode_barang == element.kode_barang,
      );
      // modal dan harga barang
      int element_modal = original_data_produk[index].modal_barang!;
      int element_harga = original_data_produk[index].harga_barang!;
      // harga, modal, dan nama barang per item
      String element_nama = original_data_produk[index].nama_barang!;
      // jumlah item produk yang dibeli
      int jumlah_item = element.jumlah_item!;
      // modal dan harga
      local_modal = element_modal * jumlah_item + local_modal;
      local_harga = element_harga * jumlah_item + local_harga;
      local_keuntungan = local_harga - local_modal;
    }
    total_modal = local_modal;
    total_harga = local_harga;
    total_keuntungan_bersih = local_keuntungan;
    print('harga : $local_modal');
  }

  void getRandomFormattedString() {
    String formattedDate = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String randomStr = Random().nextInt(99999).toString().padLeft(5, '0');
    setState(() {
      kode_transaksi = "${formattedDate}_$randomStr";
    });

    //return "${formattedDate}_$randomStr";
  }

  // remap data transaksi agar bisa diinput
  // fungsi diapnggil di tombol simpan
  void addTransaction() {
    if (kDebugMode) {
      list_produk.forEach((element) {
        print('kode barang ${element.harga_barang}');
        print('jumlah item ${element.modal_barang}');
      });
    }
    // data produk yang dibeli dalam bentuk list producttranssactionmodel
    List<ProductsTransactionsModel> purchased_products = [];
    // for loop untuk hitung setiap item
    for (ProductsTransactionsModel element in list_produk) {
      // cari index untuk produk dengan kode yang sama
      int data_index = original_data_produk.indexWhere(
        (data) => data.kode_barang == element.kode_barang,
      );

      purchased_products.add(
        ProductsTransactionsModel(
          kode_barang: original_data_produk[data_index].kode_barang,
          nama_barang: original_data_produk[data_index].nama_barang,
          harga_barang: original_data_produk[data_index].harga_barang,
          modal_barang: original_data_produk[data_index].modal_barang,
          jumlah_item: element.jumlah_item,
        ),
      );
    }
    TransactionsModel transaksi = TransactionsModel(
      pelanggan_transaksi: pelanggan_transaksi.text,
      kode_transaksi: kode_transaksi,
      total_harga: total_harga,
      total_keuntungan:
          total_keuntungan_bersih, // total keuntungan dari total harga dikurangi total modal
      total_modal: total_modal,
    );
    // input produk transaksi menggunakan database notifier
    widget.dataBaseNotifier.insertProductsTransaction(list_produk);
    print('harga barang ${list_produk[0].harga_barang}');
    // input transaksi menggunakan database notifier
    widget.dataBaseNotifier.insertTransaction({
      'total_modal': transaksi.total_modal,
      'total_harga': transaksi.total_harga,
      'total_keuntungan': transaksi.total_keuntungan,
      'pelanggan_transaksi': transaksi.pelanggan_transaksi,
      'kode_transaksi': transaksi.kode_transaksi,
    });
    // refresh kode transaksi
    getRandomFormattedString();
    // refetch database
    widget.dataBaseNotifier.fetchTransactions();
  }

  // untuk filter list sesuai dengan input user
  // dicari berdasarkan nama dan kode barang

  // filter list data yang akan ditampilkan berdasarkan input user
  void _filteredList(String inputData) {
    List<ProductsModel> result = [];
    if (inputData.length == 0) {
      result = original_data_produk;
    } else {
      result =
          original_data_produk
              .where(
                (element) =>
                    element.nama_barang!.toLowerCase().contains(
                      inputData.toLowerCase(),
                    ) ||
                    element.kode_barang!.toLowerCase().contains(
                      inputData.toLowerCase(),
                    ),
              )
              .toList();
    }
    print(result.length.toString());

    data_produk = result;
    setState(() {});
  }

  // pembuatan controller ketika data dimuat
  @override
  void initState() {
    // kode transaksi
    getRandomFormattedString();
    // TODO: implement initState
    super.initState();
    // fetch data produk
    original_data_produk = widget.dataBaseNotifier.data_produk;
    data_produk = original_data_produk;
    // membuat controller dummy
    items_controllers = List.generate(
      original_data_produk.length,
      (index) => TextEditingController(text: '0'),
    );
  }

  // dispose resource untuk menghindari memory leak
  @override
  void dispose() {
    // TODO: implement dispose
    // Hapus semua controller saat widget dihancurkan
    for (var controller in items_controllers) {
      controller.dispose();
    }
    pelanggan_transaksi.dispose();
    cari_barang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ukuran layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Transaksi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        // leading widget list
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //trailing widget upload
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Upload ditekan!")));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            // card informasi total penjualan
            Padding(
              padding: EdgeInsets.all(5),
              // mengambil class dari transaction_page_widget.dart
              child: dataTransaksi(
                screenWidth: screenWidth,
                total_modal: total_modal,
                total_keuntungan: total_harga,
                total_keuntungan_bersih: total_keuntungan_bersih,
              ),
            ),

            // card input pelanggan, kode, dan tanggal transaksi
            Padding(
              padding: EdgeInsets.all(5),
              child: DetailTransaksi(
                screenWidth: screenWidth,
                pelanggan_transaksi: pelanggan_transaksi,
                cari_barang: cari_barang,
                onUpdateCariBarang: onUpdateCariBarang,
                onUpdatepelangganTransaksi: onUpdatepelangganTransaksi,
                onUpdateSelectDate: onUpdateSelectDate,
              ),
            ),

            // list barang
            // terdiri dari nama di bawahnya ada id, disampingnya ada harga jual di bagian kanan ada tombol tambah dan kurang
            ListProducts(
              items_controllers: items_controllers,
              data_produk: data_produk,
              onChangeProductList: onChangeProductList,
              kode_transaksi: kode_transaksi,
            ),

            cutomTabBar(
              screenWidth: screenWidth,
              dataBaseNotifier: widget.dataBaseNotifier,
              addTransaction: addTransaction,
            ),
          ],
        ),
      ),
    );
  }
}
