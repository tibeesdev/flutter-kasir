import 'package:flutter/material.dart';
import 'widgets_assets/products_input_page_widget.dart';
import 'database_handler/database_instance.dart';
import 'database_handler/database_model.dart';

class InputProductsPage extends StatefulWidget {
  const InputProductsPage({super.key});

  @override
  State<InputProductsPage> createState() => _InputProductsPageState();
}

class _InputProductsPageState extends State<InputProductsPage> {
  // inisiasi instance
  DatabaseInstance databaseInstance = DatabaseInstance();

  // status loading database
  bool isLoading = true;

  //fetch produk
  List<ProductsModel> data_produk = [];
  Future fetchProducts() async {
    // ambil data produk
    List<ProductsModel> produk = await databaseInstance.showAllProducts();
    setState(() {
      data_produk = produk;
      print('object');
    });

    print('berhasil fetch produk');
  }

  // load produk
  Future loadDatabase() async {
    await Future.wait([fetchProducts()]);
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
          ListBarang(data_produk: data_produk, onInsertProducts: loadDatabase),
        ],
      ),
      // custom tabbar
      bottomNavigationBar: cutomTabBar(
        screenWidth: screenWidth,
        onInsertProduct: loadDatabase,
      ),
    );
  }
}
