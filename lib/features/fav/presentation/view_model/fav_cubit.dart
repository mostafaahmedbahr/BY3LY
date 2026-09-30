  import 'package:by3ly/core/general_models/general_model.dart';
    import 'package:by3ly/features/fav/data/models/fav_model.dart';

import '../../../../main_importants.dart';
import '../../data/repos/fav_repos.dart';
import 'fav_states.dart';


class FavCubit extends Cubit<FavStates> {
  FavCubit(this.favRepos) : super(FavInitState());

  static FavCubit get(context) => BlocProvider.of(context);


  FavRepos? favRepos;
  FavDataModel? favDataModel;

  /// Source of truth for hearts across the whole app.
  /// Synced from [getFavData] and updated optimistically by [toggleFavourite].
  final Set<int> favouriteIds = {};

  bool isFavourite(int? productId) =>
      productId != null && favouriteIds.contains(productId);

  void _syncIds() {
    favouriteIds
      ..clear()
      ..addAll([
        for (final f in favDataModel?.data?.favourites ?? <Favourites>[])
          if (f.id != null) f.id!,
      ]);
  }

  Future<void> getFavData() async {
    emit(GetFavDataLoading());
    var result = await favRepos!.getFavData();
    return result.fold((failure) {
      debugPrint('FavCubit getFavData failed: ${failure.errMessage}');
      emit(GetFavDataError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        favDataModel = data;
        _syncIds();
        emit(GetFavDataSuccess(data));
      }
      else{
        emit(GetFavDataError(data.message ?? 'Something went wrong'));
      }
    });
  }

  GeneralModel? removeProductFromFavModel;
  Future<void> removeProductFromFav({
    required int productId,
}) async {
    emit(RemoveProductFromFavLoading());
    var result = await favRepos!.removeProductFromFav(productId: productId);
    return result.fold((failure) {
      debugPrint('FavCubit removeProductFromFav failed: ${failure.errMessage}');
      emit(RemoveProductFromFavError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        removeProductFromFavModel = data;
        favouriteIds.remove(productId);
        favDataModel?.data?.favourites
            ?.removeWhere((f) => f.id == productId);
        emit(RemoveProductFromFavSuccess(data));
        // Refresh silently so ids stay in sync without a loading flash.
        getFavData();
      }
      else{
        emit(RemoveProductFromFavError(data.message ?? 'Something went wrong'));
      }
    });
  }

  GeneralModel? addProductToFavModel;
  Future<void> addProductToFav({
    required int productId,
  }) async {
    emit(AddProductToFavLoading());
    var result = await favRepos!.addProductToFav(productId: productId);
    return result.fold((failure) {
      debugPrint('FavCubit addProductToFav failed: ${failure.errMessage}');
      emit(AddProductToFavError(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        addProductToFavModel = data;
        favouriteIds.add(productId);
        emit(AddProductToFavSuccess(data));
        getFavData();
      } else {
        emit(AddProductToFavError(data.message ?? 'Something went wrong'));
      }
    });
  }

  /// Toggle from anywhere (home cards, details, search...).
  /// Emits an optimistic state first so hearts update instantly,
  /// reverts on failure.
  Future<void> toggleFavourite({required int productId}) async {
    final wasFav = favouriteIds.contains(productId);
    if (wasFav) {
      favouriteIds.remove(productId);
    } else {
      favouriteIds.add(productId);
    }
    emit(FavToggleOptimistic(productId, !wasFav));

    final result = wasFav
        ? await favRepos!.removeProductFromFav(productId: productId)
        : await favRepos!.addProductToFav(productId: productId);

    return result.fold((failure) {
      debugPrint('FavCubit toggleFavourite failed: ${failure.errMessage}');
      // Revert optimistic change.
      if (wasFav) {
        favouriteIds.add(productId);
      } else {
        favouriteIds.remove(productId);
      }
      emit(FavToggleError(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        if (!wasFav) {
          addProductToFavModel = data;
        } else {
          removeProductFromFavModel = data;
          favDataModel?.data?.favourites
              ?.removeWhere((f) => f.id == productId);
        }
        emit(FavToggleSuccess(productId, !wasFav, data.message));
        getFavData();
      } else {
        if (wasFav) {
          favouriteIds.add(productId);
        } else {
          favouriteIds.remove(productId);
        }
        emit(FavToggleError(data.message ?? 'Something went wrong'));
      }
    });
  }
}
