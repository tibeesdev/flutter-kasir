import 'package:flutter/material.dart';
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
  // list filter data
  List filter_data = [
    'semua',
    'hari ini',
    'minggu ini',
    'minggu lalu',
    'bulan ini',
    'bulan lalu',
    'custom',
  ];
  int filter_terpilih = 0;
  int total_modal = 50000;
  int total_keuntungan = 100000;
  int total_keuntungan_bersih = 0;

  // fungsi untuk ubah nilai filter terpilih dari class filterJangkaWaktu
  void updateFilter(int nilai_baru) {
    setState(() {
      filter_terpilih = nilai_baru;
    });
  }

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
  Future fetchDatabase() async {
    // ambil data transaksi
    List<TransactionsModel> transaksi =
        await databaseInstance.showAllTransactions();
    data_transaksi = transaksi;
    // ambil data produk
    List<ProductsModel> produk = await databaseInstance.showAllProducts();
    data_produk = produk;
    // ambil data transaksi produk
    List<ProductsTransactionsModel> produk_transaksi =
        await databaseInstance.showAllTransactionsProducts();
    data_produk_transaksi = produk_transaksi;

    print('berhasil fetch database');
    return true;
  }

  // load database
  Future loadDatabase() async {
    await Future.wait([fetchDatabase()]);
    // debug
    print('berhasil load database');
    load_status = false;
  }

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
          child: load_status ? CircularProgressIndicator() : Icon(Icons.check),
        ),

        //trailing widget upload
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              print(data_produk.length.toString());
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Upload ditekan!")));
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
            filterJangkaWaktu(
              filter_data: filter_data,
              filter_terpilih: filter_terpilih,
              onUpdateFilter: updateFilter,
            ),

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
            informasiTransaksi(),
            // tabbar custom
            // container awal
            cutomTabBar(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}
