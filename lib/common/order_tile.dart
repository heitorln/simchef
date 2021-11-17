import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/screens/orders/components/order_product_tile.dart';

class OrderTile extends StatelessWidget {

  OrderTile(this.order);

  final Order order;

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor
                  ),
                ),
                Text(
                  'R\$ ${order.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              order.statusText,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: order.status == Status.canceled ?
                Colors.red : Colors.black,
                fontSize: 14
              ),
            )
          ],
        ),
        children: [
          Column(
            children:
              order.items.map((e) {
                return OrderProductTile(e);
              }).toList(),
          )
        ],
      ),
    );
  }
}
