import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product_model.dart';
import '../screens/Product_detail.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      elevation: 5,
      child: GridTile(
        child: Stack(
          children: [
            // Product Image:
            GestureDetector(
              onTap: (() {
                Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                    arguments: product.id);
              }),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  product.imageUrl,
                  //height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Product Price:
            ...[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: 26,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: FittedBox(
                    child: Text(
                      '\$${product.price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        //fontSize: priceFontSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            // Action Buttons (Delete & Edit):
            ...[
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  height: 26,
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Tooltip(
                          message: 'Delete',
                          child: GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(right: 8),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            onTap: () {},
                          )),
                      Tooltip(
                        message: 'Edit',
                        child: GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),

        // Footer: Favorite icon, Title & Add to cart icon
        footer: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: GridTileBar(
            backgroundColor: Colors.black87,

            // Favorite icon:
            leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                iconSize: 24,
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: product.isFavorite
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
                  size: 24,
                ),
                tooltip: 'Favorite',
                onPressed: () => product.toggleFavoriteStatus(),
              ),
            ),

            // Product Title:
            title: Text(
              product.title,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),

            // Add to cart icon:
            trailing: Tooltip(
              padding: EdgeInsets.all(0),
              message: 'Add to cart',
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () =>
                    {cart.addItem(product.id, product.title, product.price)},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
