import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/ItemIngredient.dart';
import 'package:sim_chefe_2021/models/product.dart';

class IngredientWidget extends StatelessWidget {

  const IngredientWidget({required this.ingredient, required this.product});

  final ItemIngredient ingredient;

  final Product product;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(Icons.circle) ,
      title: Text(ingredient.name ?? ''),
    );
  }
}
