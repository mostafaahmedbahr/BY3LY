import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../models/how_to_make_purchase_model.dart';

abstract class HowToMakePurchaseRepos{

  Future<Either<Failure,HowToMakePurchaseModel>> getHowToMakePurchaseData();

}