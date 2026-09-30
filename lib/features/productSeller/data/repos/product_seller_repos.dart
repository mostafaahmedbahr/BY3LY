import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import 'package:by3ly/features/productSeller/data/models/product_seller_model.dart';

abstract class ProductSellerRepo{

  Future<Either<Failure,ProductSellerModel>> getProductSellerData(
      {required int sellerId  });


}