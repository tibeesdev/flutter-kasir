import 'package:flutter/material.dart';
import 'widgets_assets/transaction_page_widget.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ukuran layar
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int total_modal = 10000;
    int total_keuntungan = 20000;
    int total_keuntungan_bersih = total_keuntungan - total_modal;
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
              child: dataTransaksi(
                screenWidth: screenWidth,
                total_modal: total_modal,
                total_keuntungan: total_keuntungan,
                total_keuntungan_bersih: total_keuntungan_bersih,
              ),
            ),

            // card input catatan, kode, dan tanggal transaksi
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFbfcfff),
                  border: Border.all(color: Color(0xFF6e8aff), width: 2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  minHeight: 180,
                  maxWidth: screenWidth - 20,
                ),
                child: Column(
                  children: [
                    // bagian atas
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                        //margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        //color: const Color.fromARGB(255, 255, 255, 255),
                        constraints: BoxConstraints(
                          minHeight: 80,
                          maxHeight: 80,
                          maxWidth: screenWidth - 20,
                        ),

                        child: TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            constraints: BoxConstraints(
                              maxWidth: screenWidth - 30,
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
                    Container(
                      //margin: EdgeInsets.all(1),
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                        minWidth: screenWidth - 20,
                        minHeight: 70,
                      ),
                      //color: Colors.amber,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // container id transaksi
                          Container(
                            alignment: Alignment.center,
                            //padding: EdgeInsets.all(5),
                            constraints: BoxConstraints(
                              maxWidth: screenWidth / 2,
                              maxHeight: 50,
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: false,

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                labelText: 'id transaksi',
                                prefixIcon: Icon(Icons.edit_note_outlined),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),

                          // container berisi tgl transaksi
                          Container(
                            alignment: Alignment.center,
                            //padding: EdgeInsets.all(1),
                            constraints: BoxConstraints(
                              maxHeight: 50,
                              maxWidth: screenWidth / 2 - 80,
                            ),

                            //color: Colors.red,
                            child: MaterialButton(
                              color: Colors.white,
                              elevation: 5,
                              minWidth: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,

                              onPressed: () => _selectDate(context),
                              child: Text(
                                '${_selectedDate.toString().split(' ')[0]}',
                              ),
                            ),
                          ),
                        ],
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
  }
}
