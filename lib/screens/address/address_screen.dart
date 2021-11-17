import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/price_card.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';

import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Entrega'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(),
          Consumer<CartManager>(
              builder: (_, cartManager, __) {
                return PriceCard(
                  buttonText: 'Continuar para o Pagamento',
                  onPressed: cartManager.isAddressValid ? (){
                    Navigator.of(context).pushNamed('/checkout');
                  }: null,
                );
              }
          )
        ],
      ),
    );
  }
}
