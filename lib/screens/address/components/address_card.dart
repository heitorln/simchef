import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/address.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';

import 'address_input_field.dart';
import 'cep_input_field.dart';

class AddressCard extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager> (
          builder: (_, cartManager, __) {
            final address = cartManager.address ?? Address(street: '', number: '', complement: '', district: '', zipCode: '', city: '', state: '', lat: 0.0, long: 0.0);
            print(address.zipCode);

            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ),
                  ),
                  CepInputField(address),
                  AddressInputField(address),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
