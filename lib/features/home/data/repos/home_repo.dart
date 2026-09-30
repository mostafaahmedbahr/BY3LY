import 'package:by3ly/features/home/data/models/home_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class HomeRepo{

   Future<Either<Failure,HomeModel>> getHomeData();


}