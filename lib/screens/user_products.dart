import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/add_or_edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user_products_screen';

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final Products productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddOrEditProduct.routeName,
                    arguments: 'NewProduct');
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshData(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshData(context),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Consumer<Products>(
                    builder: (context, productsData, child) => ListView.builder(
                      itemCount: productsData.allItems.length,
                      itemBuilder: (_, i) {
                        return Column(
                          children: [
                            UserProductItem(
                              productId: productsData.allItems[i].id,
                              title: productsData.allItems[i].title,
                              imageUrl: productsData.allItems[i].imageUrl,
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
