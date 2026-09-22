import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/product_seller_model.dart';

abstract class ProductSellerRepo{

  Future<Either<Failure,ProductSellerModel>> getProductSellerData(
      {required int sellerId  });


}