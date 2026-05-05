import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle Token Expiration
      bool refreshed = await _refreshToken();
      if (refreshed) {
        // Retry original request
        final requestOptions = err.requestOptions;
        try {
          final response = await dio.request(
            requestOptions.path,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
            ),
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    return super.onError(err, handler);
  }

  Future<bool> _refreshToken() async {
    // Logic to call refresh token API
    // e.g., await api.refreshToken();
    // Update stored tokens
    return true; // Simulate success
  }
}
