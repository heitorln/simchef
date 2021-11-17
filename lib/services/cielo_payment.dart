import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sim_chefe_2021/models/credit_card.dart';
import 'package:sim_chefe_2021/models/user_data.dart';

class CieloPayment {

  final functions = FirebaseFunctions.instance;

  Future<String> authorize({required CreditCard creditCard, required num price,
    required String orderId, UserData? user}) async{

    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': 'Sim Chefe',
        'installments': 1,
        'creditCard': creditCard.toJson(),
        'cpf': user!.cpf,
        'paymentType': 'CreditCard',
      };

      final HttpsCallable callable = functions.httpsCallable(
          'authorizeCreditCard'
      );

      final response = await callable.call(dataSale);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['sucess'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente');
    }
  }

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {
      'payId': payId
    };
    final HttpsCallable callable = functions.httpsCallable(
        'captureCreditCard'
    );
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['sucess'] as bool) {
      debugPrint('Captura realizada com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {
      'payId': payId
    };
    final HttpsCallable callable = functions.httpsCallable(
        'cancelCreditCard'
    );
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['sucess'] as bool) {
      debugPrint('Cancelamento realizado com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }

}