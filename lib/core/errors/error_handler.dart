import 'package:dio/dio.dart';
import 'failure.dart';

Failure handleError(dynamic e) {
  if (e is DioException) {
    return ServerFailure.fromDioError(e);
  } else {
    return ServerFailure(e.toString());
  }
}