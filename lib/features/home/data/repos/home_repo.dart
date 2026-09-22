import 'package:by3ly/features/home/data/models/home_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/add_remove_product_to_fav_model.dart';

abstract class HomeRepo{

   Future<Either<Failure,HomeModel>> getHomeData();
   Future<Either<Failure,AddRemoveProductToFavModel>> addRemoveProductToFav({
      required int productId,
});


}