import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  //const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartList = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Cart",
            ),
            Text(
              "${cart.itemCount} items",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 1,
                right: 15,
                left: 15,
              ),
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) {
                    return CartItemWidget(
                      id: cartList[i].id,
                      productId: cart.items.keys.toList()[i],
                      title: cartList[i].title,
                      imageUrl: cartList[i].imageUrl,
                      price: cartList[i].price,
                      quantity: cartList[i].quantity,
                    );
                  }),
            ),
          ),
          IntrinsicHeight(
            child: InkWell(
              onTap: cart.itemCount > 0
                  ? () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Your Order has been submitted!',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                width: double.infinity,
                color: cart.itemCount > 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${cart.totalPrice.toStringAsFixed(2)} \$',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                      'Order Now',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.local_shipping_outlined,
                      size: 24,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
