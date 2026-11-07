import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:by3ly/features/legalContent/data/repos/legal_content_repos.dart';

class LegalContentRepoImpl implements LegalContentRepos {
  final ApiService? apiService;

  LegalContentRepoImpl(this.apiService);

  String _endPoint(LegalContentType type) => switch (type) {
    LegalContentType.about => EndPoints.about,
    LegalContentType.terms => EndPoints.terms,
    LegalContentType.privacy => EndPoints.privacy,
  };

  @override
  Future<Either<Failure, LegalContentModel>> getLegalContent(
    LegalContentType type,
  ) async {
    try {
      var response = await apiService!.getData(endPoint: _endPoint(type));
      LegalContentModel result = LegalContentModel.fromJson(response.data);
      debugPrint(
        'LegalContentRepoImpl(${_endPoint(type)}): '
        'title=${result.data?.title}, '
        'contentLength=${result.data?.content?.length ?? 0}',
      );
      return right(result);
    } catch (e, s) {
      debugPrint('LegalContentRepoImpl(${_endPoint(type)}) error: $e');
      debugPrint(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
