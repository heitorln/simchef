import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sim_chefe_2021/models/cart_product.dart';
import 'package:sim_chefe_2021/models/product.dart';
import 'package:sim_chefe_2021/models/user_data.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:sim_chefe_2021/services/cepaberto_service.dart';
import 'package:geolocator/geolocator.dart';

import 'address.dart';

class CartManager extends ChangeNotifier{

  List<CartProduct> items = [];
  String? profissionalId;

  late UserData? user;
  Address? address;

  num productsPrice = 0.0;
  num deliveryPrice = 0.0;

  num get totalPrice => productsPrice + deliveryPrice;

  bool _loading = false;
  bool get loading => _loading;
  set loadind(bool value){
    _loading = value;
    notifyListeners();
  }

  bool _validCart = false;
  bool get validCart => _validCart;
  set validCart(bool value){
    _validCart = value;
    notifyListeners();
  }

  Position? _currentPosition;
  String? _currentAddress;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> updateUser(UserManager userManager) async {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if(user != null) {
     await _loadCartItems();
    _loadUserAddress();
    }
  }

  Future<void> _loadCartItems () async {
    loading = true;
    final QuerySnapshot cartSnap = await user!.cartReference.get();

    items = cartSnap.docs.map(
            (d) => CartProduct.fromDocument(d)..addListener(_ontItemUpdated)
    ).toList();
    loading = false;
  }

  Future<void> _loadUserAddress() async {
    if(user!.address != null ){
      address = user!.address;
      deliveryPrice = 15.0;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    try {
      validCart = true;
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_ontItemUpdated);

      if(items.map((item) => item.profissionalId).contains(cartProduct.profissionalId) || items.isEmpty) {

      } else {
        print('não tem');
        validCart = false;
        notifyListeners();
        return;
      }
      validCart = true;
      items.add(cartProduct);
      profissionalId = cartProduct.profissionalId;


      user!.cartReference.add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.id);
      _ontItemUpdated();
    }
    notifyListeners();
  }

  void clear() {
    for(final cartProduct in items) {
      user!.cartReference.doc(cartProduct.id).delete();
    }
    items.clear();
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_ontItemUpdated);
    notifyListeners();
  }

  void _ontItemUpdated() {
    productsPrice = 0.0;

    for(int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      if(cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if(cartProduct.id != null)
    user!.cartReference.doc(cartProduct.id)
        .update(cartProduct.toCartItemMap());
  }

  bool get isCartValid {
    for(final cartProduct in items) {
      if(!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != 0.0;

  // ADDRESS

  Future<void> getAddress(String cep) async{
    loading = true;
    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      if(cepAbertoAddress != null) {
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude,
          complement: '',
          number: '',
        );
      }

      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('CEP Inválido');
    }
  }

  getCurrentLocation() async {
    await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) async {
         _currentPosition = position;
        await _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async{
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude
      );

      Placemark place = await placemarks[0];
      address = Address(
        street: place.thoroughfare,
        district: place.subLocality,
        zipCode: place.postalCode,
        city: place.country,
        state: place.administrativeArea,
        number: place.subThoroughfare,
        lat: _currentPosition!.latitude,
        long: _currentPosition!.longitude,
        complement: ''
      );
      notifyListeners();
        //_currentAddress = 'Rua:${place.name}, Bairro:${place.subLocality}, UF:${place.administrativeArea}, CEP:${place.postalCode}';

    } catch (e){
      return Future.error('CEP inválido');
    }
  }

  void setAddress(Address address) {
    this.address = address;
    deliveryPrice = 15.0;
    user!.setAddress(address);
    notifyListeners();
  }

  void removeAddress(){
    address = null;
    deliveryPrice = 0.0;
    notifyListeners();
  }


}