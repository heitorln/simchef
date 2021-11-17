import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sim_chefe_2021/models/cepaberto_address.dart';

const token = 'c0bfcd2382862f04d46e81218c2f3c5c';

class CepAbertoService {

  Future<CepAbertoAddress> getAddressFromCep(String cep) async{
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try {

      final response = await dio.get<Map<String, dynamic>>(endPoint);

      if(response.data!.isEmpty) {
        return Future.error('CEP Inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data!);

      return address;

    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }

  }

}