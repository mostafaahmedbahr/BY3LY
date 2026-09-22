import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/general_models/general_model.dart';

abstract class FavRepos{

  Future<Either<Failure , FavDataModel>> getFavData();
  Future<Either<Failure , GeneralModel>> removeProductFromFav({required int productId});

}