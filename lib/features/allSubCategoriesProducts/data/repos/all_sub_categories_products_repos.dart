import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/all_sub_categories_products_model.dart';

abstract class AllSubCategoriesProductsRepos{

  Future<Either<Failure,AllSubCategoriesProductsModel>> getAllSubCategoriesProductsData({
    required int subCategoryId,
  });




}