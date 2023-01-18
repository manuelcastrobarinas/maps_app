import 'package:dio/dio.dart';


class TrafficInterceptor extends Interceptor {

  final accessToken = 'pk.eyJ1IjoibWFkYXZ6Y29yZSIsImEiOiJjbGN1b2VsaWYxYmhpM3BtdjJhYWZmYmN4In0.sdaYCKsrXTMu1b0cRFAu_g';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries'  : 'polyline6',
      'overview'    : 'simplified',
      'steps'       : false,
      'access_token': accessToken
    });

    super.onRequest(options, handler);
  }
}