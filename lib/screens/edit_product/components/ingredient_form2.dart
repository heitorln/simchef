import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/common/custom_icon_button.dart';
import 'package:sim_chefe_2021/models/ItemIngredient.dart';
import 'package:sim_chefe_2021/models/product.dart';
import 'package:sim_chefe_2021/screens/edit_product/components/edit_item_ingredient.dart';

class IngredientForm2 extends StatelessWidget {

  IngredientForm2(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    FormField<List<ItemIngredient>>(
    initialValue: product.ingredients,
      validator: (ingre) {
        if(ingre!.isEmpty)
          return 'Insira o Ingrediente';
        return null;

      },
      builder: (estado2) {
        return Column(
          children: [
        Row(
        children: [
        Expanded(
        child: Text(
          'Inredientes',
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
          estado2.value?.add(ItemIngredient());
          estado2.didChange(estado2.value);
        },
          size: 24,
        )
        ],
        ),
        Column(
        children: estado2.value!.map((ingre){
          return EditItemIngredient(
            ingre: ingre,
            onRemove: (){
              estado2.value?.remove(ingre);
              estado2.didChange(estado2.value);
            },
          );
        }).toList(),
        ),
            if(estado2.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  estado2.errorText!,
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
