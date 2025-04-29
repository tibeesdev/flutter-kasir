import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasirapp2/database_handler/database_instance.dart';
import 'package:kasirapp2/database_handler/database_model.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class InvoicePage extends StatefulWidget {
  InvoicePage({
    super.key,
    required this.kode_transaksi,
    required this.dataBaseNotifier,
  });

  // kode transaksi
  String kode_transaksi;
  DataBaseNotifier dataBaseNotifier;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  String pdfPath = '';
  String tanggal_transaksi = '';
  DatabaseInstance databaseInstance = DatabaseInstance();
  bool _isLoading = true;

  //TransactionsModel data_transaksi = dataBaseNotifier.data_transaksi_kode;
  List<ProductsTransactionsModel> data_produk = [ProductsTransactionsModel()];
  TransactionsModel data_transaksi = TransactionsModel();

  @override
  void initState() {
    super.initState();
    // Generate PDF automatically on page load
    // inisiasi data transaksi
    widget.dataBaseNotifier.fetchTransactionProducts(widget.kode_transaksi);
    //dapatkan data tanngal transaksi
    _dataTransaksi();
  }

  // dapatkan data transaksi
  Future _dataTransaksi() async {
    // data transaksi
    data_transaksi = await databaseInstance.showTransactionsByKode(
      widget.kode_transaksi,
    );
    // data produk
    data_produk = await databaseInstance.showProductsTransactionsByKode(
      widget.kode_transaksi,
    );
    print(data_produk.length.toString());

    String rawdate = data_transaksi.kode_transaksi!.split('_')[0].trim();
    DateTime datetime = DateTime(
      int.parse(rawdate.substring(0, 4)), // year
      int.parse(rawdate.substring(4, 6)), // month
      int.parse(rawdate.substring(6, 8)), // day
      int.parse(rawdate.substring(8, 10)), // hour
      int.parse(rawdate.substring(10, 12)), // minute
      int.parse(rawdate.substring(12, 14)), // second
    ); // manual parsing untuk datetime

    tanggal_transaksi = DateFormat(
      "dd-MMM-yyyy HH:mm",
    ).format(datetime); // tanggal transaksi untuk dimasukkan ke dalam invoice

    // fetch data

    print('data $tanggal_transaksi');

    print('data transaksi ${data_transaksi.total_keuntungan}');

    _generatePdf();
  }

  // buat pdf
  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    var data = {
      'invoice_id': '${data_transaksi.kode_transaksi}',
      'date': '${tanggal_transaksi}',
      'items': [
        {'name': 'Item 1', 'quantity': 2, 'unit_price': 10.0, 'total': 20.0},
        {'name': 'Item 2', 'quantity': 1, 'unit_price': 15.0, 'total': 15.0},
      ],
      'total': 35.0,
    };

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(data),
              pw.SizedBox(height: 20),
              _buildTable(data['items'] as List<dynamic>),
              pw.SizedBox(height: 20),
              _buildTotal(data['total'] as double),
            ],
          ); // Column
        },
      ),
    );

    // Save the PDF to a temporary file
    final tempdir = await getTemporaryDirectory();
    final dir = await getExternalStorageDirectory();
    final invoiceDir = Directory('${dir!.path}/invoice');
    // Pastikan direktori ada, kalau belum maka dibuat
    if (!await invoiceDir.exists()) {
      await invoiceDir.create(recursive: true); // recursive penting!
    }
    final f = File('${invoiceDir.path}/inv.pdf');
    await f.writeAsBytes(await pdf.save());
    print(f.toString());

    final file = File("${tempdir.path}/invoice.pdf");

    await file.writeAsBytes(await pdf.save());
    setState(() {
      pdfPath = f.path; // Update the pdfPath state variable
    });
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
  }

  pw.Widget _buildHeader(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'INVOICE',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Invoice No: ${data['invoice_no']}'),
        pw.Text('Date: ${data['date']}'),
      ],
    );
  }

  pw.Widget _buildTable(List<dynamic> items) {
    return pw.TableHelper.fromTextArray(
      headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
      data:
          items
              .map(
                (item) => [
                  item['name'],
                  item['quantity'].toString(),
                  '\$${item['unit_price']}',
                  '\$${item['total']}',
                ],
              )
              .toList(),
    );
  }

  pw.Widget _buildTotal(double total) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Total: \$${total}',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  //release resource
  @override
  void dispose() {
    // hapus file pdf sementara jika ada
    if (pdfPath.isNotEmpty) {
      final file = File(pdfPath);
      if (file.existsSync()) {
        file.deleteSync();
        print('file telah dihapus');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('INVOICE'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              // This button can be removed since PDF is generated automatically
            }, // Trigger PDF generation
            onLongPress: _generatePdf,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.dataBaseNotifier,
        builder: (context, child) {
          print('${pdfPath}');
          return Container(
            constraints: BoxConstraints(
              minWidth: 0, // Ensure minimum width is not negative
              minHeight: 40, // Set a minimum height
            ),
            child: Column(
              children: [
                _isLoading
                    ? Text(_isLoading.toString())
                    : Text(_isLoading.toString()),
                //debug
                Text(
                  widget
                      .dataBaseNotifier
                      .data_transaksi_kode
                      .pelanggan_transaksi
                      .toString(),
                ),

                _isLoading
                    ? CircularProgressIndicator()
                    : File(pdfPath).existsSync()
                    ? Container(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: PDFView(filePath: pdfPath),
                    )
                    : Text('PDF tidak ditemukan'),

                //Container(height: 700, child: PDFView(filePath: pdfPath)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InvoiceGenerator {
  final Map<String, dynamic> invoiceData;

  InvoiceGenerator(this.invoiceData);

  Future<Uint8List> generateInvoice() async {
    final pdf = pw.Document();
    final itemsPerPage = 10;
    final items = invoiceData['items'] as List<dynamic>;

    for (var i = 0; i < items.length; i += itemsPerPage) {
      final pageItems = items.sublist(
        i,
        (i + itemsPerPage > items.length) ? items.length : i + itemsPerPage,
      );
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                pw.SizedBox(height: 20),
                _buildTable(pageItems),
                pw.SizedBox(height: 20),
                if (i + itemsPerPage >= items.length) _buildTotal(),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'INVOICE',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Invoice No: ${invoiceData['invoice_no']}'),
        pw.Text('Date: ${invoiceData['date']}'),
      ],
    );
  }

  pw.Widget _buildTable(List<dynamic> items) {
    return pw.TableHelper.fromTextArray(
      headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
      data:
          items
              .map(
                (item) => [
                  item['name'],
                  item['quantity'].toString(),
                  '\$${item['unit_price']}',
                  '\$${item['total']}',
                ],
              )
              .toList(),
    );
  }

  pw.Widget _buildTotal() {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        'Total: \$${invoiceData['total']}',
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }
}
