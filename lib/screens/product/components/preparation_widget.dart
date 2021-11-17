import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/ItemPreparation.dart';
import 'package:sim_chefe_2021/models/product.dart';

class PreparationWidget extends StatelessWidget {

  const PreparationWidget({required this.preparation, required this.product});

  final ItemPreparation preparation;

  final Product product;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: Icon(Icons.circle),
      title: Text(preparation.name ?? ''),
    );
  }
}
