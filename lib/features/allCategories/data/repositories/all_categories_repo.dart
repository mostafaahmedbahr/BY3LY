import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class AllCategoriesRepo{

   Future<Either<Failure,AllCategoriesModel>> getAllCategories();



}