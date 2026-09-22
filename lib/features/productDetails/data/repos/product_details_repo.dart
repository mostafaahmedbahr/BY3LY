import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/add_product_to_compare_model.dart';
import '../models/product_details_model.dart';

abstract class ProductDetailsRepo{

  Future<Either<Failure,ProductDetailsModel>> getProductDetailsData(
      {required int productId , required String type});

  Future<Either<Failure,AddProductToCompareModel>> addProductToCompare(
      {required int productId });


}