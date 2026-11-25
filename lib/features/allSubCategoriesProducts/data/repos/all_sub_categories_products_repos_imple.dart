import 'package:by3ly/core/extensions/log.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';

import '../../../allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import '../models/all_sub_categories_products_model.dart';
import 'all_sub_categories_products_repos.dart';

class AllSubCategoriesProductsReposImpl
    implements AllSubCategoriesProductsRepos {
  final ApiService apiService;

  AllSubCategoriesProductsReposImpl(this.apiService);

  @override
  Future<Either<Failure, AllSubCategoriesProductsModel>>
  getAllSubCategoriesProductsData({
    required int subCategoryId,
    int page = 1,
    int perPage = 10,
    ProductsFilter? filter,
  }) async {
    try {
      final query = <String, dynamic>{
        "sub_category_id": subCategoryId,
        "page": page,
        "per_page": perPage,
      };
      // Same server-side filter keys used by the search screen.
      if (filter != null) query.addAll(filter.toQueryParams());
      var response = await apiService.getData(
        endPoint: EndPoints.productBySubCategory,
        query: query,
      );
      AllSubCategoriesProductsModel result =
          AllSubCategoriesProductsModel.fromJson(response.data);
      logWarning(
        'SubCategoryProducts page=$page query=$query '
        'lastPage=${result.data?.pagination?.resolvedLastPage ?? '-'}',
      );
      return right(result);
    } catch (e, s) {
      logWarning(
        'AllSubCategoriesProductsReposImpl getAllSubCategoriesProductsData error: $e',
      );
      logWarning(s.toString());
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
