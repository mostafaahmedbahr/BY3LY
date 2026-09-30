  import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';

abstract class SellAllBestViewRepo{

  Future<Either<Failure,SellAllBestViewModel>> getAllBestViewProducts();


}