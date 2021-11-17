import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sim_chefe_2021/screens/orders/components/order_product_tile.dart';
import 'package:sim_chefe_2021/screens/profissional_orders/components/export_address_dialog.dart';

import 'cancel_order_dialog.dart';

class OrderTileProfissional extends StatelessWidget {

  OrderTileProfissional(this.order,this.user);

  final Order order;
  final UserManager user;

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
              if(e.profissionalId == user.user!.id) {
                print(user.user!.id);
                return OrderProductTile(e);
              } else {
                return Container();
              }
            }).toList(),
          ),
          if(order.status != Status.canceled)
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CancelOrderDialog(order)
                      );
                    },
                  child: const Text('Cancelar'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.red,
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,

                  ),
                ),
                ElevatedButton(
                  onPressed: order. back,
                  child: const Text('Recuar'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,

                  ),
                ),
                ElevatedButton(
                  onPressed: order.advance,
                  child: const Text('Avançar'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,

                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => ExportAddressDialog(order.address)
                    );
                  },
                  child: const Text('Endereço'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.grey,
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,

                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
