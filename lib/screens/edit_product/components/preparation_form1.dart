// import 'package:flutter/material.dart';
// import 'package:sim_chefe_2021/common/custom_icon_button.dart';
// import 'package:sim_chefe_2021/models/product.dart';
// import 'package:sim_chefe_2021/screens/edit_product/components/edit_preparation.dart';
//
// class PreparationForm1 extends StatelessWidget {
//
//   PreparationForm1(this.product);
//
//   Product product;
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return FormField<List<dynamic>>(
//       initialValue: List.from(product.preparation),
//       validator: (prep) {
//         if(prep!.isEmpty)
//           return 'Insira o modo de preparo';
//         return null;
//
//       },
//       builder: (state) {
//         return Column(
//           children: [
//             Row(
//             children: [
//               Expanded(
//         child: Text(
//             'Modo de Preparo',
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
//         children: state.value!.map<Widget>((prep) {
//           return Row(
//             children: [
//               Expanded(
//                 child: TextFormField(
//                   initialValue: prep,
//                   maxLines: null,
//                   decoration: InputDecoration(
//                       hintText: 'Modo de Preparo'
//                   ),
//                   validator: (prep) {
//                     if(prep!.isEmpty)
//                       return 'Inválido';
//                     return null;
//                   },
//
//                   onChanged: (prep) => product.preparation = prep as List<String>
//                 ),
//               ),
//               CustomIconButton(
//                 onTap: () {
//                   state.value!.remove(prep);
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
