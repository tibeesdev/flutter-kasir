import 'package:flutter/material.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:kasirapp2/widgets_assets/main_page.dart';
import 'package:kasirapp2/database_handler/database_instance.dart';
import 'package:kasirapp2/database_handler/database_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF6e8aff)),
      ),
      home: const MyHomePage(title: 'KASIR'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // listenable time filter digunakan di semua class
  TimeFilter timeFilter = TimeFilter();
  // changenotofier database
  DataBaseNotifier dataBaseNotifier = DataBaseNotifier();

  // inisiasi database
  DatabaseInstance databaseInstance = DatabaseInstance();

  //inisiasi aplikasi
  @override
  void initState() {
    // inisiasi database
    databaseInstance.database();

    // load database
    loadDatabase();

    // TODO: implement initState
    super.initState();
  }

  // data dari database
  List<ProductsTransactionsModel> data_produk_transaksi =
      []; //list data produuk transaksi
  bool load_status = true;

  // fetch produk transaksi
  Future fetchProductsTransactions() async {
    // ambil data transaksi produk
    List<ProductsTransactionsModel> produk_transaksi =
        await databaseInstance.showAllTransactionsProducts();
    setState(() {
      data_produk_transaksi = produk_transaksi;
    });
  }

  Future fetchDatabase() async {
    // ambil data transaksi
    dataBaseNotifier.fetchTransactions();
    // ambil data produk
    dataBaseNotifier.fetchProducts();

    // ambil data transaksi produk
    fetchProductsTransactions();

    print('berhasil fetch database');
    return true;
  }

  // load database
  Future loadDatabase() async {
    await Future.wait([fetchDatabase()]);
    // debug
    print('berhasil load database');
    setState(() {
      load_status = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //load_status ? ;
    // lebar dan tinggi layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
        centerTitle: true,
        // leading widget list
        leading: AnimatedSwitcher(
          duration: Duration.zero,
          child:
              load_status
                  ? Icon(Icons.radio_button_unchecked)
                  : Icon(Icons.check),
        ),

        //trailing widget upload
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () async {
              int kode = await databaseInstance.insertTransactions({
                'total_modal': 25000,
                'total_harga': 50000,
                'total_keuntungan': 25000,
                'pelanggan_transaksi': 'test transaksi',
                'kode_transaksi': 'kode 1',
              });
              print(kode.toString());
              dataBaseNotifier.fetchTransactions();
              print(dataBaseNotifier.data_transaksi.length);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // kolom pilihan jangka waktu data
            filterJangkaWaktu(timeFilter: timeFilter),
            // kolom data transaksi
            dataTransaksi(
              screenWidth: screenWidth,
              dataBaseNotifier: dataBaseNotifier,
            ),

            // header informasi transaksi
            headerDataTransaksi(screenWidth: screenWidth),

            // informasi transaksi berisi pelanggan, id transaksi, pengeluaran dan pemasukan
            ListenableBuilder(
              listenable: dataBaseNotifier,
              builder: (context, child) {
                // proses transaksi
                return informasiTransaksi(
                  data_transaksi: dataBaseNotifier.data_transaksi,
                  dataBaseNotifier: dataBaseNotifier,
                );
              },
            ),

            ListenableBuilder(
              listenable: timeFilter,
              builder: (context, child) {
                return Text(timeFilter.filter_terpilih.toString());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: // tabbar custom
      // container awal
      cutomTabBar(
        screenWidth: screenWidth,
        dataBaseNotifier: dataBaseNotifier,
        timeFilter: timeFilter,
      ),
    );
  }
}
