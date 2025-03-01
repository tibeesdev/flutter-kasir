import 'package:flutter/material.dart';

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
