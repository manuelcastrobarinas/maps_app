
import 'package:dio/dio.dart';


class PlacesInterceptor extends Interceptor {
  
  final accessToken = 'pk.eyJ1IjoibWFkYXZ6Y29yZSIsImEiOiJjbGN1b2VsaWYxYmhpM3BtdjJhYWZmYmN4In0.sdaYCKsrXTMu1b0cRFAu_g';
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'access_token' : accessToken,
      'language'     : 'es',
    });

    super.onRequest(options, handler);
  }
}