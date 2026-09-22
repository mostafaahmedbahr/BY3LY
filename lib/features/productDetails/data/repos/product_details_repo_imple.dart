import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/productDetails/data/repos/product_details_repo.dart';
 import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/add_product_to_compare_model.dart';
import '../models/product_details_model.dart';


class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ApiService? apiService;

  ProductDetailsRepoImpl(this.apiService);


  @override
  Future<Either<Failure, ProductDetailsModel>> getProductDetailsData({
    required int productId, required String type,
})async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.productDetials,
        query: {
          "product_id" : productId,
          "type" : type,
        },
      );
      ProductDetailsModel result = ProductDetailsModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }


  @override
  Future<Either<Failure, AddProductToCompareModel>> addProductToCompare({
    required int productId,
  })async {
    try {
      var response = await apiService!.getData(
        
        endPoint: EndPoints.addCompare,
        query: {
          "product_ids[]" : productId,
        },
      );
      AddProductToCompareModel result = AddProductToCompareModel.fromJson(response.data);
      return right(result);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
