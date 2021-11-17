import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/cart_manager.dart';
import 'package:sim_chefe_2021/models/cart_product.dart';
import 'package:sim_chefe_2021/models/user_data.dart';
import 'order.dart';

class OrdersManager extends ChangeNotifier{

  UserData? user;
  CartManager? cartManager;

  List<Order> orders = [];

  List<Order> allOrders = [];
  List<CartProduct> allOrders2 = [];
  String? allOrders3;

  String? docs2;
  String? docsProductId;
  String? pidProduct1;


  Order? order;

  String? pinDigitado;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;


  Future<void> pinReceita() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('user', isEqualTo: user!.id).get();

    var docs = snapshot.docs.map((e) => e.get('pin'));
    var docsProductId1 = snapshot.docs.map((e) => e.get('profissionalId'));
    var pidProduct = snapshot.docs.map((e) => e.get('pid'));

    pidProduct1 = pidProduct.toString().replaceAll('(', '').replaceAll(')', '');
    print(pidProduct1);
    docsProductId = docsProductId1.toString();
    docs2 = docs.toString().replaceAll('(', '').replaceAll(')', '');
    notifyListeners();
  }


  void updateUser(UserData? user) {
    this.user = user;
    orders.clear();

    _subscription?.cancel();
    if(user != null) {
      // loadAllOrders();
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').where('user', isEqualTo: user!.id)
        .snapshots().listen(
    (event) {
      for(final change in event.docChanges) {
        switch(change.type) {
          case DocumentChangeType.added:
            orders.add(Order.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final modOrder = orders.firstWhere(
                    (o) => o.orderId == change.doc.id);
            modOrder.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            orders.clear();
            break;
        }
      }
      notifyListeners();
    });
  }

  // Future<void> loadAllOrders() async{
  //   final QuerySnapshot snapProducts =
  //   await firestore.collection('orders').get();
  //
  //   allOrders = snapProducts.docs.map(
  //           (d) => Order.fromDocument(d)).toList();
  //   print('$allOrders teste');
  //   print(allOrders.map((e) {
  //     allOrders2 = e.items;
  //   }));
  //  print(allOrders2.map((c) {
  //    allOrders3 = c.profissionalId;
  //  }));
  //  print('$allOrders3 profissionalId');
  //
  //
  //   notifyListeners();
  //
  // }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}