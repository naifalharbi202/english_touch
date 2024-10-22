import 'package:dio/dio.dart';

class DictApi {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://api.dictionaryapi.dev/api/v2/entries/en',
          receiveDataWhenStatusError: true,
          headers: {'accept': 'Application/json'}),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String lang = 'ar',
    String? token,
  }) async {
    dio!.options.headers = {
      'lang': lang,
      'Authorization': token,
    };

    return dio!.post(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
