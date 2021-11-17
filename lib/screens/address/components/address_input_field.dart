import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sim_chefe_2021/models/address.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';

class AddressInputField extends StatelessWidget {

  AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {

    final cartManager = context.watch<CartManager>();


    if(address.zipCode != '' && cartManager.deliveryPrice == 0.0)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          initialValue: address.street,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Rua/Avenida',
            hintText: 'Av. Paulista'
          ),
          validator: (text) {
            if(text!.isEmpty)
              return 'Campo obrigatório';
            return null;
          },
          onSaved: (t) => address.street = t!,
        ),
        Row(
          children: [
             Expanded(
                 child: TextFormField(
                   initialValue:address.number,
                   decoration: const InputDecoration(
                     isDense: true,
                     labelText: 'Número',
                     hintText: '123',
                   ),
                   inputFormatters: [
                     FilteringTextInputFormatter.digitsOnly
                   ],
                   keyboardType: TextInputType.number,
                   onSaved: (t) => address.number = t!,
                   validator: (text) {
                     if(text!.isEmpty)
                       return 'Campo obrigatório';
                     return null;
                   },
                 ),
             ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: TextFormField(
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => address.complement = t!,
                ),
            ),
          ],
        ),
        TextFormField(
          initialValue: address.district,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'Bairro',
            hintText: 'Vila Mariana'
          ),
          validator: (text) {
            if(text!.isEmpty)
              return 'Campo obrigatório';
            return null;
          },
          onSaved: (t) => address.district = t!,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                enabled: false,
                initialValue: address.city,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Cidade',
                  hintText: 'São Paulo'
                ),
                validator: (text) {
                  if(text!.isEmpty)
                    return 'Campo obrigatório';
                  return null;
                },
                onSaved: (t) => address.city = t!,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'SP',
                    counterText: ''
                  ),
                  maxLength: 2,
                  validator: (e) {
                    if(e!.isEmpty) {
                      return 'Campo obrigatório';
                    } else if(e.length != 2) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onSaved: (t) => address.state = t!,
                ),
            ),
          ],
        ),
        const SizedBox(width: 8,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            onPressed: (){
              if(Form.of(context)!.validate()) {
                Form.of(context)!.save();
                context.read<CartManager>().setAddress(address);
              }
            },
            child: const Text('Calcular Frete'))
      ],
    );
    else if(address.zipCode != '')
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
            '${address.street}, ${address.number},\n${address.district}\n'
                '${address.city} - ${address.state}'
        ),
      );
    else return Container();
  }
}
