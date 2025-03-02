import 'package:dio/dio.dart';

import '../../storage/models/request_model.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio();

  Future request(Request request) async {
    switch (request.method) {
      case 'GET':
        return await _get(request);
      case 'POST':
        return await _post(request);
    }
  }

  Future _get(Request request) async {
    Response response =
        await _dio.get(request.path, options: Options(headers: request.auth));
    return response;
  }

  Future _post(Request request) async {
    Response response = await _dio.post(request.path,
        data: request.body, options: Options(headers: request.auth));
    return response;
  }
}
