import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/widgets/cart_item.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) {
                    print(cartList[i].title);
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
            ElevatedButton(
                onPressed: cart.itemCount > 0
                    ? () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        cart.clear();
                        Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.shopping_cart_checkout_rounded),
                    Text(cart.totalPrice.toString()),
                    Text('Order Now!'),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
