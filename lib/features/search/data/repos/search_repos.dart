import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter_sheet.dart';
import '../models/all_products_search_model.dart';

abstract class SearchRepos{

    Future<Either<Failure,AllProductsSearchModel>> getAllProductsForSearch({
      int page = 1,
      ProductsFilter? filter,
    });


}