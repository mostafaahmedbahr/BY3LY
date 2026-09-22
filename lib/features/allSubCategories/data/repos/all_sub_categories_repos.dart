   import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/all_sub_categories_model.dart';

abstract class AllSubCategoriesRepos{

  Future<Either<Failure,AllSubCategoriesModel>> getAllSubCategoriesData({
    required int categoryId,
  });




}