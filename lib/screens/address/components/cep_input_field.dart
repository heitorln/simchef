import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/custom_icon_button.dart';
import 'package:sim_chefe_2021/models/address.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';

class CepInputField extends StatefulWidget {

  CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {

  final cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    if(widget.address.zipCode == '')
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
         TextFormField(
              initialValue: cartManager.address?.zipCode,
              enabled: !cartManager.loading,
              controller: cepController,
              decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'CEP',
                  hintText: '12345-413'
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CepInputFormatter(),
              ],
              keyboardType: TextInputType.number,
              validator: (cep) {
                if(cep!.isEmpty)
                  return 'Campo obrigatório';
                else if(cep.length != 10)
                  return 'CEP Inválido';
                return null;
              },
        ),
        if(cartManager.loading)
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation(primaryColor),
            backgroundColor: Colors.transparent,
          ),
        ElevatedButton(
          onPressed: !cartManager.loading ? () async {
            if(Form.of(context)!.validate()) {
              try {
                await context.read<CartManager>().getAddress(cepController.text);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$e'),
                      backgroundColor: Colors.red,
                    )
                );
              }
            }
          } : null,
          style: ElevatedButton.styleFrom(
          primary: primaryColor,
          ),
          child: const Text('Buscar CEP')
        ),
      ],
    );
    else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                  'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
                iconData: Icons.edit,
                color: primaryColor,
                onTap: () {
                  context.read<CartManager>().removeAddress();
                },
              size: 20,
                ),
          ],
        ),
      );
    }
  }
}
