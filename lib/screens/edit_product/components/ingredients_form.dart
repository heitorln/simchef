// import 'package:flutter/material.dart';
// import 'package:sim_chefe_2021/models/product.dart';
//
// class IngredientsForm extends StatelessWidget {
//
//   IngredientsForm(this.product);
//
//   Product product;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//                 child: ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: product.ingredients.length,
//                     itemBuilder: (_,index) {
//
//                       int count = index + 1;
//
//                       return ListTile(
//                         leading: Icon(Icons.circle),
//                         title: TextFormField(
//                           initialValue: product.ingredients[index],
//                           decoration: InputDecoration(
//                               hintText: 'Ingredientes',
//                               border: InputBorder.none
//                           ),
//                           maxLines: null,
//                           validator: (preparation) {
//                             if(preparation!.isEmpty)
//                               return 'Preencha o ingrediente';
//                             return null;
//                           },
//
//                         ),
//                       );
//
//                     }
//                 )
//             )
//           ],
//         )
//       ],
//     );
//   }
// }
