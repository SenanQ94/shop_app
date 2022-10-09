import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class ProductsGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductsProvider productData = Provider.of<ProductsProvider>(context);
    final products = productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 7 / 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider(
            create: (context) => products[i],
            child: ProductItem(),
          );
        });
  }
}
