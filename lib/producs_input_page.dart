import 'package:flutter/material.dart';
import 'package:kasirapp2/transaction_provider.dart';
import 'widgets_assets/products_input_page_widget.dart';
import 'database_handler/database_instance.dart';
import 'database_handler/database_model.dart';

class InputProductsPage extends StatefulWidget {
  InputProductsPage({super.key, required this.dataBaseNotifier});

  DataBaseNotifier dataBaseNotifier;

  @override
  State<InputProductsPage> createState() => _InputProductsPageState();
}

class _InputProductsPageState extends State<InputProductsPage> {
  // inisiasi instance
  DatabaseInstance databaseInstance = DatabaseInstance();
  

  // status loading database
  bool isLoading = true;

  // load produk
  Future loadDatabase() async {
    await Future.wait([widget.dataBaseNotifier.fetchProducts()]);
    print('berhasil load database produk');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // inisiasi database
    loadDatabase();
    // TODO: implement initState
    super.initState();
  }



  // data dummy
  List data = List.generate(10, (index) => index += 1);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Kelola stok', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        // leading widget list
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        //trailing widget status loading
        actions: [
          IconButton(
            icon: isLoading ? Icon(Icons.circle_outlined) : Icon(Icons.check),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Upload ditekan!")));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // card header data barang
          headerDataProduk(screenWidth: screenWidth),

          // list barang
          ListenableBuilder(
            listenable: widget.dataBaseNotifier,
            builder: (context, child) {
              return ListBarang(
                data_produk: widget.dataBaseNotifier.data_produk,
                dataBaseNotifier: widget.dataBaseNotifier,
              );
            },
          ),
        ],
      ),
      // custom tabbar
      bottomNavigationBar: cutomTabBar(
        screenWidth: screenWidth,
        onInsertProduct: loadDatabase,
        dataBaseNotifier: widget.dataBaseNotifier,
      ),
    );
  }
}
