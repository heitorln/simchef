import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/common/custom_icon_button.dart';
import 'package:sim_chefe_2021/models/ItemPreparation.dart';
import 'package:sim_chefe_2021/models/product.dart';

import 'edit_item_preparation.dart';

class PreparationForm2 extends StatelessWidget {

  PreparationForm2(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    FormField<List<ItemPreparation>>(
    initialValue: product.preparations,
      validator: (prep) {
        if(prep!.isEmpty)
          return 'Insira o modo de preparo';
        return null;

      },
      builder: (estado) {
        return Column(
          children: [
        Row(
        children: [
        Expanded(
        child: Text(
          'Modo de Preparo',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
          ),
        ),
        ),
        CustomIconButton(
        iconData: Icons.add,
        color: Colors.black,
        onTap: (){
          estado.value?.add(ItemPreparation());
          estado.didChange(estado.value);
        },
          size: 24,
        )
        ],
        ),
        Column(
        children: estado.value!.map((prep){
          return EditItemPreparation(
              prep: prep,
            onRemove: (){
                estado.value?.remove(prep);
                estado.didChange(estado.value);
            },
          );
        }).toList(),
        ),
            if(estado.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  estado.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    )
      ],
    );
  }
}
