import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/screens/add_or_edit_product_screen.dart';

import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  //static const String routeName = '/user_products_screen';

  final String title;
  final String imageUrl;
  final String productId;

  const UserProductItem(
      {required this.title, required this.imageUrl, required this.productId});

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddOrEditProduct.routeName, arguments: productId);
            },
            icon: Icon(
              Icons.edit,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(productId);
              } catch (error) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text('deleting faild!'),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ]),
      ),
    );
  }
}
