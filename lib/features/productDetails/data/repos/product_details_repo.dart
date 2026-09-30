import 'package:by3ly/core/general_models/general_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/add_product_to_compare_model.dart';
import '../models/product_details_model.dart';

abstract class ProductDetailsRepo{

  Future<Either<Failure,ProductDetailsModel>> getProductDetailsData(
      {required int productId , required String type});

  Future<Either<Failure,AddProductToCompareModel>> addProductToCompare(
      {required int productId });

  Future<Either<Failure,GeneralModel>> rateProduct(
      {required int productId, required int rate, required String commenet});


}