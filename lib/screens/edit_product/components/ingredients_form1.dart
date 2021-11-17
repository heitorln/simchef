// import 'package:flutter/material.dart';
// import 'package:sim_chefe_2021/common/custom_icon_button.dart';
// import 'package:sim_chefe_2021/models/product.dart';
// import 'package:sim_chefe_2021/screens/edit_product/components/edit_preparation.dart';
//
// class IngredientsForm1 extends StatelessWidget {
//
//   IngredientsForm1(this.product);
//
//   Product product;
//
//   @override
//   Widget build(BuildContext context) {
//     return FormField<List<dynamic>>(
//       initialValue: List.from(product.ingredients),
//       validator: (ingre) {
//         if(ingre!.isEmpty)
//           return 'Preencha o ingrediente';
//         return null;
//     },
//       builder: (state) {
//         return Column(
//           children: [
//             Row(
//             children: [
//               Expanded(
//         child: Text(
//             'Ingredientes',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500
//           ),
//         )
//         ),
//         CustomIconButton(
//         iconData: Icons.add,
//         color: Colors.black,
//         onTap: () {
//           state.value!.add('');
//           state.didChange(state.value);
//         })
//           ],
//         ),
//         Column(
//         children: state.value!.map<Widget>((ingrediente) {
//           return Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   initialValue: ingrediente,
//                   maxLines: null,
//                   decoration: InputDecoration(
//                       hintText: 'Ingrediente'
//                   ),
//                   validator: (ingre) {
//                     if(ingre!.isEmpty)
//                       return 'Inválido';
//                     return null;
//                   },
//                   onChanged: (ingrediente) => product.ingredients = ingrediente as List<String>,
//                 ),
//               ),
//               CustomIconButton(
//                 onTap: () {
//                   state.value!.remove(ingrediente);
//                   state.didChange(state.value);
//                 },
//                 iconData: Icons.delete,
//                 color: Colors.red,
//               )
//             ],
//           );
//         }).toList(),
//         ),
//             if(state.hasError)
//               Container(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   state.errorText!,
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontSize: 12,
//                   ),
//                 ),
//               )
//           ],
//         );
//       },
//     );
//   }
// }
