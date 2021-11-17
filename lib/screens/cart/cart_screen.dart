import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/empty_card.dart';
import 'package:sim_chefe_2021/common/login_card.dart';
import 'package:sim_chefe_2021/common/price_card.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';

import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_,cartManager,__) {

          if(cartManager.user == null) {
            return LoginCard();
          }

          if(cartManager.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if(cartManager.items.isEmpty) {
            return EmptyCard(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum produto no carrinho',
            );
          }


          return ListView(
            children: [
              Column(
                children: cartManager.items.map(
                        (cartProduct) => CartTile(cartProduct)
                ).toList(),
              ),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid ? () {
                  Navigator.of(context).pushNamed('/address');
                } : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
