import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sim_chefe_2021/models/product.dart';

class CartProduct extends ChangeNotifier {

  CartProduct.fromProduct(this._product) {
    productId = product!.id!;
    profissionalId  = product!.idUser!;
    quantity = 1;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = document['pid'] as String;
    profissionalId = document['profissionalId'] as String;
    quantity = document['quantity'] as int;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
      }
    );
  }

  CartProduct.fromMap(Map<String,dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    profissionalId = map['profissionalId'] as String;
    fixedPrice = map['fixedPrice'] as num;

    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
      }
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? id;

  late String productId;
  late String profissionalId;
  late int quantity;

  num? fixedPrice;

  Product? _product;
  Product? get product => _product;
  set product(Product? value){
    _product = value;
    notifyListeners();
  }

  num get totalPrice {
    if(product?.price != null)
    return product!.price! * quantity;
    return 0.0;
  }



  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'profissionalId' : profissionalId
    };
  }

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'profissionalId' : profissionalId,
      'fixedPrice': fixedPrice ?? product!.price
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.idUser == profissionalId;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    print(product?.deleted);
    if(product != null && product?.deleted == true) return false;

    if(product?.stock != null)
    return product!.stock! >= quantity;
    return false;
  }

  @override
  String toString() {
    return 'CartProduct{id: $id, productId: $productId, profissionalId: $profissionalId, quantity: $quantity, fixedPrice: $fixedPrice}';
  }
}
