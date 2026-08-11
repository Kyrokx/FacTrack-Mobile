import 'package:dio/dio.dart';
import 'constants.dart';
import 'storage.dart';

class ApiClient {
  static Dio get dio {
    final dio = Dio(BaseOptions(baseUrl: Constants.baseUrl));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await Storage.getAccess();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _refreshToken(dio);
          if (refreshed) {
            final token = await Storage.getAccess();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          }
        }
        handler.next(error);
      },
    ));

    return dio;
  }

  static Future<bool> _refreshToken(Dio dio) async {
    try {
      final refresh = await Storage.getRefresh();
      final response = await Dio().post(
        '${Constants.baseUrl}/auth/token/refresh/',
        data: {'refresh': refresh},
      );
      await Storage.saveTokens(
        response.data['access'],
        refresh ?? '',
      );
      return true;
    } catch (_) {
      await Storage.clear();
      return false;
    }
  }
}