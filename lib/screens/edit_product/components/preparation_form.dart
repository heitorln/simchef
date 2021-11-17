// import 'package:flutter/material.dart';
// import 'package:sim_chefe_2021/common/custom_icon_button.dart';
// import 'package:sim_chefe_2021/models/product.dart';
//
// import 'edit_preparation.dart';
//
// class PreparationForm extends StatelessWidget {
//
//   PreparationForm(this.product);
//
//   final Product product;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//
//         children: [
//
//           Row(
//           children: [
//           Expanded(
//           child: ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: product.preparation.length,
//           itemBuilder: (_,index) {
//
//           int count = index + 1;
//
//           return ListTile(
//                 trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       color: Colors.red,
//                       onPressed: () {  product.preparation.removeAt(index);},
//                 ),
//           leading: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//           Text(
//           '$count',
//           style: TextStyle(
//           fontSize: 20
//           ),
//           )
//           ],
//           ),
//           title: TextFormField(
//           initialValue: product.preparation[index],
//                 decoration: InputDecoration(
//                       hintText: 'Modo de preparo',
//                       border: InputBorder.none
//                 ),
//                 maxLines: null,
//                 validator: (preparation) {
//                 if(preparation!.length < 10)
//                       return 'Modo de preparo muito curto';
//                 return null;
//                 },
//
//           ),
//           );
//           }
//           ),
//           ),
//           ],
//           )
//           ],
//
//
//           );
//         }
//   }
//
