import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/models/orders_manager.dart';
import 'package:sim_chefe_2021/models/product.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sim_chefe_2021/screens/edit_product/components/video_player.dart';

import 'components/ingredient_widget.dart';
import 'components/preparation_widget.dart';

class ProductScreen extends StatelessWidget {

  final TextEditingController pinController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProductScreen(this.product);

  final Product product;

  String? pin;


  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(product.name ?? ''),
          centerTitle: true,
          actions: [

            Consumer<UserManager>(
              builder: (_,userManager,__) {
                if(product.idUser == userManager.user?.id && product.deleted == false) {
                  return IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                          '/edit_product',
                          arguments: product
                      );
                    },
                  );

                } else {
                  return Container();
                }
              },
            )
          ],
        ),
        body:  ListView(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images:
                product.images!.map((url) {
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.name ?? '',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$${product.price}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Criado por',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    product.createBy ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tempo de preparo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    '${product.preparationTime.toString()} minutos',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    product.description ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Modo de Preparo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Wrap(
                    children:
                    product.preparations!.map((e) {
                      return PreparationWidget(
                        preparation: e, product: product);
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Wrap(
                    children:
                    product.ingredients!.map((e) {
                        return IngredientWidget(
                            ingredient: e, product: product);
                      }).toList()),
                  VideoApp(product.urlVideo!),

                  // ElevatedButton(
                  //     onPressed: () {
                  //       showDialog(
                  //           context: context,
                  //           builder: (_) {
                  //             return AlertDialog(
                  //               title: const Text('Desbloquear Receita'),
                  //               content: Container(
                  //                 padding: const EdgeInsets.all(8),
                  //                 color: Colors.white,
                  //                 child: Form(
                  //                   key: formKey,
                  //                   child: Column(
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       TextFormField(
                  //                         controller: pinController,
                  //                         // enabled:  !userManager.loading,
                  //                         decoration: const InputDecoration(hintText: 'PIN'),
                  //                         autocorrect: false,
                  //                         obscureText: true,
                  //                         onSaved: (val) => pin = val,
                  //                         validator: (pin){
                  //                           if(pin!.isEmpty || pin.length < 4)
                  //                             return 'Pin Inválido';
                  //                           return null;
                  //                         },
                  //                       ),
                  //                       ElevatedButton(
                  //                           onPressed: () {
                  //                             if(formKey.currentState!.validate()) {
                  //                               formKey.currentState!.save();
                  //                               context.read<OrdersManager>().pinReceita();
                  //
                  //                             }
                  //                           },
                  //                           child: const Text('Desbloquear Receita'))
                  //                     ],
                  //                   ),
                  //                 )
                  //               ),
                  //             );
                  //           }
                  //       );
                  //
                  //     },
                  //     child: Text('Texte')),

                  // Consumer<OrdersManager>(
                    // builder: (_, orderManager, __) {

                      // Future<String> pegarPin() async{
                      //   String pin2 = await context.read<OrdersManager>().pinReceita();
                      //   print('$pin2 dasdsas');
                      //   return pin2;
                      // }

                      // context.read<OrdersManager>().pinReceita();

                      // print('${orderManager.docs2} tesadsa');
                      // print('$pin pinnn');
                      // var docs3 = orderManager.docs2?.replaceAll(' ', '');
                      // print('$docs3 o que ta');
                      // print('${product.idUser} id user criou');
                      // print('${orderManager.docsProductId} profissionalID order');

                      // if(pin != null) {
                      //   print(docs3?.contains(pin!));
                      //   print('${product.id} product.id');
                      //   print('${orderManager
                      //       .pidProduct1} orderManager.pidProduct1');
                      //   print(orderManager.pidProduct1!.contains(product.id!));
                      // }


                      // if(pin != null) {
                      //   if(docs3 != null)
                      //   if(docs3.contains(pin!) && product.id!.contains(orderManager.pidProduct1!)) {
                      //     print('entrou');
                      //     return Column(
                      //       children: [
                      //         Padding(
                      //           padding: const EdgeInsets.only(top: 16, bottom: 8),
                      //           child: Text(
                      //             'Ingredientes',
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w500,
                      //             ),
                      //           ),
                      //         ),
                      //         Wrap(
                      //             children:
                      //             product.ingredients!.map((e) {
                      //               return IngredientWidget(
                      //                   ingredient: e, product: product);
                      //             }).toList()),
                      //       ],
                      //     );
                      //   }
                      // }
                      // return Container();
                  //   },
                  // ),

                  const SizedBox(height: 20,),
                  Consumer3<UserManager,Product,CartManager>(
                      builder: (_, userManager, product,cartManager, __) {
                        print(product.deleted);
                        if(product.hasStock && product.deleted == false)
                          return SizedBox(
                            height: 44,
                            child: TextButton(
                              onPressed: () {
                                if(userManager.isLoggedIn) {
                                  context.read<CartManager>().addToCart(product);
                                  if(cartManager.validCart) {

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Você só pode adicionar receita de um chef por pedido'),
                                          backgroundColor: Colors.red,
                                        )
                                    );
                                  }
                                  Navigator.of(context).pushNamed('/cart');
                                } else {
                                  Navigator.of(context).pushNamed('/login');
                                }

                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  primary: Colors.white
                              ),
                              child: Text(
                                userManager.isLoggedIn
                                    ? 'Adicionar ao Carrinho'
                                    : 'Entre para Comprar',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        else
                          return SizedBox(
                            height: 44,
                            child: Text(
                              product.deleted == true ? 'Produto indisponível'
                              : 'Produto sem estoque!',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                          );
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
