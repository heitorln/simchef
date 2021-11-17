import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sim_chefe_2021/common/price_card.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';
import 'package:sim_chefe_2021/models/checkout_manager.dart';
import 'package:sim_chefe_2021/models/credit_card.dart';

import 'components/cpf_field.dart';
import 'components/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
        checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Pagamento'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Consumer<CheckoutManager>(
            builder: (_,checkoutManager, __) {
              if(checkoutManager.loading) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      const SizedBox(height: 16,),
                      Text(
                        'Processando seu pagamento...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16
                        ),
                      )
                    ],
                  ),
                );
              }
              return Form(
                key: formKey,
                child: ListView(
                  children: [
                    CreditCardWidget(creditCard),
                    CpfField(),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          checkoutManager.checkout(
                            creditCard: creditCard,
                            onStockFail: (e) {
                              Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/cart');
                              },
                              onPayFail: (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$e'),
                                      backgroundColor: Colors.red,
                                    )
                                );
                              },
                              onSuccess: (order){
                              Navigator.of(context).popUntil(
                                (route) => route.settings.name == '/');
                              Navigator.of(context).pushNamed(
                                '/confirmation',
                                arguments: order
                              );
                              }
                          );
                        }

                      },
                    )
                  ],
                ),
              );
            },
          ),
        )
      ),
    );
  }
}
