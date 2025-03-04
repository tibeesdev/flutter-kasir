import 'package:flutter/material.dart';
import 'package:kasirapp2/transaction_page.dart';
import 'package:kasirapp2/producs_input_page.dart';

// widget filter waktu
class filterJangkaWaktu extends StatefulWidget {
  filterJangkaWaktu({
    super.key,
    required this.filter_data,
    required this.filter_terpilih,
    required this.onUpdateFilter,
  });
  final List filter_data;
  int filter_terpilih;

  // fungsi untuk update filter di parent class
  final Function(int) onUpdateFilter;

  @override
  State<filterJangkaWaktu> createState() => _filterJangkaWaktuState();
}

class _filterJangkaWaktuState extends State<filterJangkaWaktu> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(1),
      constraints: BoxConstraints(
        minHeight: 50,
        maxHeight: 50,
        maxWidth: screenWidth,
      ),
      color: Colors.white,
      child: Container(
        child: ListView.builder(
          itemCount: widget.filter_data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            bool terpilih = widget.filter_terpilih == index;
            return GestureDetector(
              onTap: () {
                widget.onUpdateFilter(index);
                setState(() {
                  widget.filter_terpilih = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(minWidth: 50),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: terpilih ? Color(0xFF6e8aff) : Color(0xFFbfcfff),
                  shape: BoxShape.rectangle,
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.filter_data[index],
                    style:
                        terpilih
                            ? TextStyle(color: Colors.white)
                            : TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// widget card data transaksi
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

// header untuk data transaksi berisi teks catatan, pengeluaran dan pemasukan
class headerDataTransaksi extends StatelessWidget {
  const headerDataTransaksi({super.key, required this.screenWidth});

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
            flex: 40,
            child: Center(
              child: Text(
                'catatan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'pengeluaran',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 25,
            child: Center(
              child: Text(
                'pemasukan',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// informasi transaksi lengkap (buat sistem onclicknya)
class informasiTransaksi extends StatelessWidget {
  const informasiTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(5),
            constraints: BoxConstraints(maxHeight: 65, minHeight: 50),
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
                Expanded(
                  flex: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Text(
                          'Catatan $index',
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
                          'id transaksi $index',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: Center(
                    child: Text(
                      'pengeluaran $index',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: Center(
                    child: Text(
                      'pemasukan $index',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// tabbar custom
class cutomTabBar extends StatelessWidget {
  const cutomTabBar({super.key, required this.screenWidth});

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
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InputProductsPage()),
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
                  'kelola stok',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // tombol tambah di bagian tengah
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransactionPage()),
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
          Padding(
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
                'Statistik',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
