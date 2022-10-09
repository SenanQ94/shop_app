import 'package:flutter/material.dart';

import '../widgets/products_gridview.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: ProductsGridView(),
    );
  }
}
