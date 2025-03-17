import 'package:flutter/material.dart';
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
  @override
  void initState() {
    // inisiasi data transaksi
    widget.dataBaseNotifier.fetchTransactionProducts(widget.kode_transaksi);
    super.initState();
  }

  // buat pdf
  void _generatePdf() async {
    final pdf = pw.Document();
    var data = {
      'invoice_no': 'INV-001',
      'date': '2023-10-01',
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
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/invoice.pdf");
    await file.writeAsBytes(await pdf.save());
    setState(() {
      pdfPath = file.path; // Update the pdfPath state variable
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

  // simpan file pdf sementara
  Future<void> _savePdf() async {
    var data = {
      'invoice_no': 'INV-001',
      'date': '2023-10-01',
      'items': [
        {'name': 'Item 1', 'quantity': 2, 'unit_price': 10.0, 'total': 20.0},
        {'name': 'Item 2', 'quantity': 1, 'unit_price': 15.0, 'total': 15.0},
      ],
      'total': 35.0,
    };
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/invoice.pdf");
    await file.writeAsBytes(await InvoiceGenerator(data).generateInvoice());
    setState(() {
      pdfPath = file.path;
    });
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
            onPressed: _generatePdf, // Trigger PDF generation
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.dataBaseNotifier,
        builder: (context, child) {
          return Container(
            constraints: BoxConstraints(
              minWidth: 0, // Ensure minimum width is not negative
              minHeight: 40, // Set a minimum height
            ),
            child: Column(
              children: [
                Text(
                  widget
                      .dataBaseNotifier
                      .data_transaksi_kode
                      .pelanggan_transaksi
                      .toString(),
                ),
                Container(height: 200, child: PDFView(filePath: pdfPath)),
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
