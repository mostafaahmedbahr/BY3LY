import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import '../models/all_sub_categories_products_model.dart';

abstract class AllSubCategoriesProductsRepos {
  Future<Either<Failure, AllSubCategoriesProductsModel>>
  getAllSubCategoriesProductsData({
    required int subCategoryId,
    int page = 1,
    int perPage = 10,
    ProductsFilter? filter,
  });
}
