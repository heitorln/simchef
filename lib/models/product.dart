import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sim_chefe_2021/models/user_manager.dart';
import 'package:uuid/uuid.dart';

import 'ItemIngredient.dart';
import 'ItemPreparation.dart';

class Product extends ChangeNotifier{

  late UserManager userManager;
  
  
  Product({ this.id,  this.name,  this.description,  this.images,  this.ingredients, this.preparations, required this.stock, this.price, this.preparationTime, this.deleted = false, this.urlVideo}) {
    images = images ?? [];
    ingredients = ingredients ?? [];
    preparations = preparations ?? [];
    stock = stock;
    idUser = idUser;

  }

  Product.fromDocument(DocumentSnapshot document) {
    id = document.id;
    name = document['name'] as String;
    description = document['description'] as String;
    images = List<String>.from((document.data() as Map)['images'] as List<dynamic>);
    ingredients = (document['ingredients'] as List<dynamic>).map(
            (ingredient) => ItemIngredient .fromMap(ingredient as Map<String, dynamic>)).toList();
    preparations = (document['preparation'] as List<dynamic>).map(
            (prep) => ItemPreparation.fromMap(prep as Map<String, dynamic>)).toList();
    stock = document['stock'] as int;
    price = document['price'] as num;
    idUser = document['idUser'] as String;
    createBy = document['createBy'] as String;
    preparationTime = document['preparationTime'] as num;
    deleted = (document['deleted'] ?? false) as bool;
    urlVideo = document['urlVideo'] as String;

  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  
  DocumentReference get firestoreRef => firestore.doc('products/$id');
  Reference get storageRef => storage.ref().child('products').child(id!);

  String? id;
  String? name;
  String? description;
  List<String>? images;
  List<ItemIngredient>? ingredients;
  List<ItemPreparation>? preparations;
  int? stock;
  num? price;
  String? idUser;
  String? createBy;
  num? preparationTime;
  String? urlVideo;

  List<dynamic>? newImages;

  bool? deleted;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  bool get hasStock => stock! > 0;

  List<Map<String, dynamic>> exportIngredientsList() {
    return ingredients!.map((ingredient) => ingredient.toMap()).toList();
  }

  List<Map<String, dynamic>> exportPreparationsList() {
    return preparations!.map((preparation) => preparation.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String,dynamic> data = {
      'name' : name,
      'description' : description,
      'ingredients' : exportIngredientsList(),
      'preparation' : exportPreparationsList(),
      'stock' : stock,
      'price' : price,
      'preparationTime' : preparationTime,
      'deleted': deleted,
      'urlVideo': urlVideo
    };


    if(id == null) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
      await firestore.collection('products').doc(id).update({'idUser' : idUser,'createBy' : createBy});
    } else {
      await firestoreRef.update(data);
    }

    final List<String> updateImages = [];
    
    for(final newImage in newImages!) {
      if(images!.contains(newImage)) {
        updateImages.add(newImage as String);
      } else {
        final UploadTask task = storageRef.child(Uuid().v1()).putFile(newImage as File);
        await task
            .then((TaskSnapshot snapshot) async{
          print('Upload complete!');
          final String url = await snapshot.ref.getDownloadURL() ;
          updateImages.add(url.toString());
          await firestoreRef.update({'images': updateImages});
        })
            .catchError((Object e) {
          print(e); // FirebaseException
        });
      }
    }

    for(final image in images!) {
      if(!newImages!.contains(image) && image.contains('firebase')) {
        try {
          final ref = storage.refFromURL(image);
          await ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar: $image');
        }
      }
    }


    images = updateImages;

    loading = false;

  }

  void delete() {
    firestoreRef.update({'deleted': true});
    notifyListeners();
  }

  Product clone() {
    return Product(
      id: id,
      name: name,
      description: description,
      images: List.from(images!),
      ingredients: ingredients!.map((ingredients) => ingredients.clone()).toList(),
      preparations: preparations!.map((preparation) => preparation.clone()).toList(),
      stock: stock,
      price: price,
      preparationTime : preparationTime,
      deleted: deleted,
      urlVideo: urlVideo

    );
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, images: $images, ingredients: $ingredients, preparations: $preparations, stock: $stock, price: $price, idUser: $idUser, newImages: $newImages}';
  }
}