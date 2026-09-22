import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/productSeller/data/repos/product_seller_repos.dart';
 import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/app_services/remote_services/api_service.dart';
import '../../../../core/app_services/remote_services/end_points.dart';
import '../models/product_seller_model.dart';


class ProductSellerRepoImpl implements ProductSellerRepo {
  final ApiService? apiService;

  ProductSellerRepoImpl(this.apiService);


  @override
  Future<Either<Failure, ProductSellerModel>> getProductSellerData({
    required int sellerId,
  })async {
    try {
      var response = await apiService!.getData(
        endPoint: EndPoints.sellerProduct,
        
        query: {
          "seller_id" : sellerId,
        },
      );
      ProductSellerModel result = ProductSellerModel.fromJson(response.data);
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
