import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItemWidget({
    required this.id,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Dismissible(
          key: ValueKey(id),
          confirmDismiss: (direction) {
            if (direction == DismissDirection.startToEnd) {
              return showDialog(
                context: context,
                builder: ((ctx) => AlertDialog(
                      title: Text('Are You Sure?'),
                      content: Text('Do you want to place this order?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text('Yes'),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text('No'),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).errorColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                          ),
                        ),
                      ],
                    )),
              );
            } else {
              return showDialog(
                context: context,
                builder: ((ctx) => AlertDialog(
                      title: Text('Are You Sure?'),
                      content: Text('Do you want to remove from Cart?'),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text('Yes'),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text('No'),
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).errorColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                          ),
                        ),
                      ],
                    )),
              );
            }
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              Provider.of<Orders>(context, listen: false).addOrder([
                CartItem(
                    id: id,
                    title: title,
                    quantity: quantity,
                    price: price,
                    imageUrl: imageUrl)
              ], price * quantity);
              Provider.of<Cart>(context, listen: false).removeItem(productId);
            } else if (direction == DismissDirection.endToStart) {
              Provider.of<Cart>(context, listen: false).removeItem(productId);
            }
          },
          background: slideRightBackground(),
          secondaryBackground: slideLeftBackground(),
          child: IntrinsicHeight(
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 50,
              child: Row(
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: price.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ThemeData.light().primaryColor),
                          children: [
                            TextSpan(
                                text: "  x${quantity}",
                                style: Theme.of(context).textTheme.bodyText1),
                            TextSpan(
                                text:
                                    "   |   ${(quantity * price).toStringAsFixed(2)} \$",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IntrinsicWidth(
                    child: Container(
                      color: Colors.black45,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Icon(
                              Icons.add,
                              color: Colors.grey[400],
                              size: 25,
                            ),
                            onTap: () => {
                              cart.addItem(productId, title, price, imageUrl),
                              ScaffoldMessenger.of(context).clearSnackBars(),
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${title} added to your cart!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            },
                          ),
                          Divider(
                            color: Colors.white38,
                            thickness: 0.3,
                          ),
                          Text(
                            '${quantity}',
                            style:
                                TextStyle(color: Colors.white60, fontSize: 18),
                          ),
                          Divider(
                            color: Colors.white38,
                            thickness: 0.3,
                          ),
                          GestureDetector(
                              child: Icon(
                                cart.items[productId]!.quantity > 1
                                    ? Icons.remove
                                    : Icons.delete_outline,
                                color: Colors.grey[400],
                                size: 25,
                              ),
                              onTap: () => {
                                    cart.decQuantity(productId),
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars(),
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${title} removed from your cart!',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget slideRightBackground() {
  return Container(
    color: Colors.green.withOpacity(0.7),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.local_shipping_outlined,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " Order Now...",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red.withOpacity(0.7),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete_sweep_outlined,
            size: 40,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
