import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/common/custom_icon_button.dart';
import 'package:sim_chefe_2021/models/ItemIngredient.dart';


class EditItemIngredient extends StatelessWidget {

  EditItemIngredient({required this.ingre, required this.onRemove});

  final ItemIngredient ingre;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: ingre.name ?? '',
            decoration: const InputDecoration(
              hintText: 'Ingredientes',
              isDense: true
            ),
            validator: (name) {
              if(name!.isEmpty)
                return 'Preencha o Ingrediente';
              return null;
            },
            onChanged: (name) => ingre.name = name,
          ),
        ),
        CustomIconButton(
            iconData: Icons.delete,
            color: Colors.red,
            onTap: onRemove,
          size: 24,
        )
      ],
    );
  }
}
