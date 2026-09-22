import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/all_products_search_model.dart';

abstract class SearchRepos{

    Future<Either<Failure,AllProductsSearchModel>> getAllProductsForSearch();


}