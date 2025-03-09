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
  int total_modal = 50000;
  int total_keuntungan = 100000;
  int total_keuntungan_bersih = 0;

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
  List<TransactionsModel> data_transaksi = []; // list data transaksi
  List<ProductsModel> data_produk = []; // list data produk
  List<ProductsTransactionsModel> data_produk_transaksi =
      []; //list data produuk transaksi
  bool load_status = true;

  // fetchdatabase
  Future fetchTransactions() async {
    // ambil data transaksi
    List<TransactionsModel> transaksi =
        await databaseInstance.showAllTransactions();
    setState(() {
      data_transaksi = transaksi;
    });
  }

  //fetch produk
  Future fetchProducts() async {
    // ambil data produk
    List<ProductsModel> produk = await databaseInstance.showAllProducts();
    setState(() {
      data_produk = produk;
    });
  }

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
    fetchTransactions();
    // ambil data produk
    fetchProducts();
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

  // listenabel time filter
  TimeFilter timeFilter = TimeFilter();

  @override
  Widget build(BuildContext context) {
    //load_status ? ;
    // lebar dan tinggi layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    total_keuntungan_bersih = total_keuntungan - total_modal;
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
                'catatan_transaksi': 'test transaksi',
                'kode_transaksi': 'kode 7',
              });
              print(kode.toString());
              setState(() {
                fetchTransactions();
              });
              print(data_transaksi.length);
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
              total_modal: total_modal,
              total_keuntungan: total_keuntungan,
              total_keuntungan_bersih: total_keuntungan_bersih,
            ),

            // header informasi transaksi
            headerDataTransaksi(screenWidth: screenWidth),

            // informasi transaksi berisi catatan, id transaksi, pengeluaran dan pemasukan
            //informasiTransaksi(data_transaksi: data_transaksi),
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
      cutomTabBar(screenWidth: screenWidth, data_produk: data_produk),
    );
  }
}
