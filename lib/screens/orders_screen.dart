import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            setState(() {
              _obtainOrdersFuture();
            });
          });
        },
        child: FutureBuilder(
          future: _ordersFuture,
          builder: (BuildContext context, AsyncSnapshot dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (dataSnapshot.error != null) {
              return Center(
                child: Text(
                  'An error occured, please try again later!',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                return orderData.orders.isNotEmpty
                    ? ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItemWidget(orderData.orders[i]),
                      )
                    : Center(
                        child: Text(
                          'There is no orders!',
                          textAlign: TextAlign.center,
                        ),
                      );
              });
            }
          },
        ),
      ),
    );
  }
}
