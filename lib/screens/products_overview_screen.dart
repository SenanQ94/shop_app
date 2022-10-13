import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import './cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_gridview.dart';

enum FiltersOption {
  Favorits,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption selectedFilter) {
              setState(() {
                if (selectedFilter == FiltersOption.Favorits) {
                  // productsContainer.showFavsOnly();
                  _showOnlyFavorites = true;
                } else {
                  // productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show Favorites'),
                value: FiltersOption.Favorits,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FiltersOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (_, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount > 99 ? '+99' : cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: ProductsGridView(_showOnlyFavorites),
    );
  }
}
