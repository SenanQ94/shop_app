import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/product_model.dart';
import '../screens/Product_detail.dart';
import '../screens/add_or_edit_product_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
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
                            onTap: () async {
                              try {
                                await Provider.of<Products>(context,
                                        listen: false)
                                    .deleteProduct(product.id);
                              } catch (error) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text('deleting faild!'),
                                  ),
                                );
                              }
                            },
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
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AddOrEditProduct.routeName,
                                arguments: product.id);
                          },
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
            trailing: Row(
              children: [
                Tooltip(
                  padding: EdgeInsets.all(0),
                  message: 'Add to cart',
                  child: Badge(
                    //key: Key(product.id),
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () => {
                        // cart.addItem(product.id, product.title, product.price,
                        //     product.imageUrl)
                      },
                    ),
                    value: cart.itemQuantity(product.id) > 99
                        ? '+99'
                        : cart.itemQuantity(product.id).toString(),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Tooltip(
                          message: 'increase',
                          child: GestureDetector(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            onTap: () => {
                              cart.addItem(product.id, product.title,
                                  product.price, product.imageUrl),
                              ScaffoldMessenger.of(context).clearSnackBars(),
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.title} added to your cart!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            },
                          )),
                      Tooltip(
                        message: 'decrease',
                        child: GestureDetector(
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                          onTap: () => {
                            cart.isInCart(product.id)
                                ? {
                                    cart.decQuantity(product.id),
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars(),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.title} removed from your cart!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  }
                                : {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar(),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'you don\'t have any \"${product.title}\" in your cart!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
