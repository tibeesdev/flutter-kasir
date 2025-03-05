import 'package:flutter/material.dart';
import 'widgets_assets/products_input_page_widget.dart';

class InputProductsPage extends StatefulWidget {
  const InputProductsPage({super.key});

  @override
  State<InputProductsPage> createState() => _InputProductsPageState();
}

class _InputProductsPageState extends State<InputProductsPage> {
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
      body: Column(
        children: [
          // card header data barang
          headerDataProduk(screenWidth: screenWidth),

          // list barang
          ListBarang(data: data),

          // custom tabbar
          cutomTabBar(screenWidth: screenWidth),
        ],
      ),
    );
  }
}
