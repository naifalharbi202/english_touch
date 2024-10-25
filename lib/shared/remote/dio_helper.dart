import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'http://10.0.2.2:8000/api',
          receiveDataWhenStatusError: true,
          headers: {'accept': 'Application/json'}),
    );
  }

  static void setAuthToken(String token) {
    dio!.options.headers['Authorization'] = 'Bearer $token';
  }

  static void revokeAuthToken() {
    print('THIS IS REVOKE token ${dio!.options.headers['Authorization']}');
    dio!.options.headers.remove('Authorization');

    print('THIS IS REVOKE token ${dio!.options.headers['Authorization']}');
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
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    try {
      final headers = <String, dynamic>{
        'Accept': 'application/json',
      };

      // Add token to headers if provided
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await dio!.post(
        url,
        queryParameters: query,
        data: data,
        options: Options(headers: headers, validateStatus: (status) => true),
      );

      return response;
    } catch (error) {
      print('Error posting data: $error');
      rethrow;
    }
  }

  static Future<Response> updateData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    required String token,
  }) async {
    try {
      final headers = <String, dynamic>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final response = await dio!.put(url,
          data: data,
          options: Options(headers: headers, validateStatus: (status) => true));

      return response;
    } catch (e) {
      print('Error updating data: $e');
      rethrow;
    }
  }

  static Future<Response> deleteCard({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String lang = 'en',
    required String token,
  }) async {
    try {
      final headers = <String, dynamic>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await dio!.delete(url,
          options: Options(headers: headers, validateStatus: (status) => true));

      return response;
    } catch (e) {
      print('Error deleting data: $e');
      rethrow;
    }
  }

  static Future<Response> updateSingleResource({
    required String url,
    required Map<String, dynamic>? data,
    String lang = 'en',
    required String? token,
  }) async {
    final options = Options(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return await dio!.patch(
      url,
      data: data,
      options: options,
    );
  }
}
