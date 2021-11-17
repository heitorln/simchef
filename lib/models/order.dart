import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sim_chefe_2021/models/address.dart';
import 'package:sim_chefe_2021/models/cart_product.dart';
import 'package:sim_chefe_2021/services/cielo_payment.dart';

import 'cart_manager.dart';

enum Status { canceled, preparing, transporting, delivered }

class Order {

  CartProduct? cartProduct;

  String? pinDigitado;

  Order.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user!.id;
    address = cartManager.address!;
    profissionalId = cartManager.profissionalId!;
    status = Status.preparing;
  }

  Order.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String,dynamic>);
    }).toList();

    price = doc['price'] as num;
    userId = doc['user'] as String;
    address = Address.fromMap(doc['address'] as Map<String, dynamic>);
    profissionalId = doc['profissionalId'] as String;
    date = doc['date'] as Timestamp;

    status = Status.values[doc['status'] as int];

    payId = doc['payId'] as String;

    pin = doc['pin'] as int;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc['status'] as int];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items':items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address.toMap(),
        'profissionalId': profissionalId,
        'status': status.index,
        'date': Timestamp.now(),
        'payId': payId,
        'pin': pin,
      });
  }

  Function()? get back {
    return status.index >= Status.transporting.index ?
    () {
      status = Status.values[status.index - 1];
      firestore.collection('orders').doc(orderId).update(
        {'status': status.index}
      );
    } : null;
  }

  Function()? get advance {
    return status.index <= Status.transporting.index ?
    () {
      status = Status.values[status.index + 1];
      firestore.collection('orders').doc(orderId).update(
          {'status': status.index}
      );
    } : null;
  }

  Future<void> cancel() async {
    try {
      await CieloPayment().cancel(payId);

      status = Status.canceled;
      firestore.collection('orders').doc(orderId).update({'status': status.index});
    } catch (e) {
      debugPrint('Erro ao cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  late String orderId;
  late String payId;
  late int pin;

  late List<CartProduct> items;
  late num price;

  late String userId;

  late Address address;

  late Status status;

  late Timestamp date;

  String? profissionalId;

  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch(status){
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em preparação';
      case Status.transporting:
        return 'Em transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Order{cartProduct: $cartProduct, firestore: $firestore, orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date, profissionalId: $profissionalId}';
  }
}