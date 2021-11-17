import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/custom_drawer/custor_drawer.dart';
import 'package:sim_chefe_2021/common/empty_card.dart';
import 'package:sim_chefe_2021/common/login_card.dart';
import 'package:sim_chefe_2021/models/orders_manager.dart';
import 'package:sim_chefe_2021/common/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Meus Pedidos'),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if(ordersManager.user == null) {
            return LoginCard();
          }
          if(ordersManager.orders.isEmpty) {
            return EmptyCard(
                title: 'Nenhum pedido encontrado!',
                iconData: Icons.border_clear
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_, index) {
              return OrderTile(
                ordersManager.orders.reversed.toList()[index]
              );
            }
          );

        },
      ),
    );
  }
}
