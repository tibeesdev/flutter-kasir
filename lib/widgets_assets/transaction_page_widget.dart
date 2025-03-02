import 'package:flutter/material.dart';

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

// widget untuk bagian catatan transaski, tanggal transaksi, dan cari barang

class DetailTransaksi extends StatefulWidget {
  DetailTransaksi({
    super.key,
    required this.screenWidth,
    required this.catatan_transaksi,
    required this.cari_barang,
    required this.onUpdateCariBarang,
    required this.onUpdateCatatanTransaksi,
    required this.onUpdateSelectDate,
  });
  // controller
  TextEditingController catatan_transaksi;
  TextEditingController cari_barang;

  // lebar layar
  double screenWidth;

  // fungsi call back untuk ambil data
  final Function(String) onUpdateCatatanTransaksi;
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
          // catatan transaksi
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
              // texformfielc catatan transaksi
              child: TextFormField(
                controller: widget.catatan_transaksi,
                onChanged: (value) {
                  widget.onUpdateCatatanTransaksi(value);
                  setState(() {
                    widget.catatan_transaksi.text = value.toString();
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
                  labelText: 'catatan transaksi',
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
