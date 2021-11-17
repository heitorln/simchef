import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sim_chefe_2021/models/order.dart';
import 'package:sim_chefe_2021/models/user_data.dart';

import 'cart_manager.dart';

class ProfissionalOrdersManager extends ChangeNotifier{

  UserData? user;

  CartManager? cartManager;

  List<Order> orders = [];

  List<Status> statusFilter = [Status.preparing];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateProfissional({required bool profissionalEnabled, required UserData? user}) {
    this.user = user;
    orders.clear();

    _subscription?.cancel();
    if(profissionalEnabled) {
      _listenToOrders();
    }
  }

  List<Order> get filteredOrders {
    List<Order> output = orders.reversed.toList();

    return output = output.where((o) => statusFilter.contains(o.status)).toList();

  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').where('profissionalId', isEqualTo: user!.id)
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
                break;
            }
          }
          notifyListeners();
        });
  }

  void setStatusFilter({required Status status, required bool enabled}) {
    if(enabled) {
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

}