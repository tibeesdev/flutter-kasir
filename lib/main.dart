import 'package:flutter/material.dart';
import 'package:kasirapp2/widgets_assets/main_page.dart';

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

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          icon: Icon(Icons.list),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Tombol ditekan!")));
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
