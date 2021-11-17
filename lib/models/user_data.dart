import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sim_chefe_2021/models/address.dart';

class UserData {

  UserData({required this.email,this.password, required this.name, required this.id});

  UserData.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = (document.data() as Map)['name'] as String;
    email = (document.data() as Map)['email'] as String;
    cpf = (document.data() as Map)['cpf'] as String;
    profile = (document.data() as Map)['type'] as String;
    Map<String,dynamic> dataMap = document.data() as Map<String,dynamic>;
    if(dataMap.containsKey('address')) {
      address = Address.fromMap(
          document['address'] as Map<String,dynamic>);
    }
  }

  late String id;
  late String name;
  late String email;
  String? cpf;
  String? password;
  late String profile;

  late String confirmPassword;

  Address? address;

  DocumentReference get firestoreRef =>
    FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference =>
    firestoreRef.collection('cart');

  CollectionReference get tokensReference =>
      firestoreRef.collection('tokens');


  Future<void> saveData() async{
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'email' : email,
      'type' : profile,
      if(address != null)
        'address': address!.toMap(),
      if(cpf != '')
        'cpf' : cpf
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  void setCpf(String? cpf){
    this.cpf = cpf!;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    await tokensReference.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'plataform': Platform.operatingSystem,
    });
  }

}