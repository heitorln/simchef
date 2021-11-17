import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:min_id/min_id.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/models/product.dart';
import 'package:sim_chefe_2021/services/cielo_payment.dart';

import 'cart_manager.dart';
import 'credit_card.dart';

class CheckoutManager extends ChangeNotifier{

  CartManager? cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CieloPayment cieloPayment = CieloPayment();

  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout({required CreditCard creditCard,
    required Function onStockFail,
    required Function onSuccess,
    required Function onPayFail}) async{

    loading = true;

    final orderId = await _getOrderId();
    String payId;
    try {
      payId = await cieloPayment.authorize(
        creditCard: creditCard,
        price: cartManager!.totalPrice,
        orderId: orderId.toString(),
        user: cartManager!.user,
      );
      debugPrint('sucess $payId');
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    try {
      await _decrementStock();
    } catch(e) {
      onStockFail(e);
      loading = false;
      return;
    }

    try {
      await cieloPayment.capture(payId);
    } catch(e) {
      onPayFail(e);
      loading = false;
      return;
    }

    final order = Order.fromCartManager(cartManager!);
    order.orderId = orderId.toString();
    order.payId = payId;

    final pin = MinId.getId('4{d}');
    order.pin = int.tryParse(pin) as int;

    await order.save();
    cartManager!.clear();
    onSuccess(order);
    loading = false;
  }

  Future<int> _getOrderId() async {

    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final orderId = doc['current'] as int;
        await tx.update(ref, {'current': orderId + 1});
        return {'orderId': orderId};
      }, timeout: const Duration(seconds: 10));
      return result['orderId'] as int;
    } catch(e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar número do pedido');
    }
  }

  Future<void> _decrementStock() async {
    return firestore.runTransaction((tx) async {
      final List<Product> productsToUpdate = [];
      final List<Product> productsWithoutStock = [];

      for(final cartProduct in cartManager!.items) {
        Product product;
        
        if(productsToUpdate.any((p) => p.id == cartProduct.productId)){
          product = productsToUpdate.firstWhere(
                  (p) => p.id == cartProduct.productId);
        } else {
          final doc = await tx.get(
              firestore.doc('products/${cartProduct.productId}')
          );
          product = Product.fromDocument(doc);
        }

        cartProduct.product = product;

        if(product.stock! - cartProduct.quantity < 0) {
          productsWithoutStock.add(product);
        } else {
          product.stock = product.stock! - cartProduct.quantity;
          productsToUpdate.add(product);
        }
      }

      if(productsWithoutStock.isNotEmpty) {
        return Future.error(
            '${productsWithoutStock.length} produtos sem estoque'
        );
      }
      
      for(final product in productsToUpdate){
        tx.update(
            firestore.doc('products/${product.id}'),
            {'stock': product.stock});
      }
      

    });
  }

}