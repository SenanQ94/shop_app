import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import 'product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool _isShowFav;

  const ProductsGridView(this._isShowFav);
  @override
  Widget build(BuildContext context) {
    final Products productData = Provider.of<Products>(context);
    final products =
        _isShowFav ? productData.favoriteItems : productData.allItems;
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
          return ChangeNotifierProvider.value(
            value: products[i],
            child: ProductItem(),
          );
        });
  }
}
