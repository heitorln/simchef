import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/common/custom_icon_button.dart';
import 'package:sim_chefe_2021/models/ItemPreparation.dart';

class EditItemPreparation extends StatelessWidget {

  EditItemPreparation({required this.prep, required this.onRemove});

  final ItemPreparation prep;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            initialValue: prep.name ?? '',
            decoration: const InputDecoration(
              hintText: 'Modo de Preparo',
              isDense: true
            ),
            validator: (name) {
              if(name!.isEmpty)
                return 'Preencha o modo de preparo';
              return null;
            },
            onChanged: (name) => prep.name = name,
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
