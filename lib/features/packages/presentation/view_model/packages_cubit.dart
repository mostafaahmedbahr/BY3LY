import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/packages_model.dart';
import '../../data/repos/packages_repos.dart';
import 'packages_states.dart';

class PackagesCubit extends Cubit<PackagesStates> {
  PackagesCubit(this.packagesRepos) : super(PackagesInitState());

  static PackagesCubit get(BuildContext context) =>
      BlocProvider.of(context);

  PackagesRepos? packagesRepos;
  PackagesModel? packagesModel;

  /// The four duration tabs: monthly / 3 months / 6 months / yearly.
  static const List<Map<String, dynamic>> durations = [
    {'months': 1, 'label': 'شهرى'},
    {'months': 3, 'label': '3 شهور'},
    {'months': 6, 'label': '6 شهور'},
    {'months': 12, 'label': 'سنوى'},
  ];

  int selectedDurationIndex = 0;

  void changeDuration(int index) {
    if (selectedDurationIndex == index) return;
    selectedDurationIndex = index;
    emit(PackagesDurationChangedState());
  }

  List<Package> get allPackages => packagesModel?.data ?? [];

  /// Client-side filter by the selected duration tab.
  /// If no package carries duration info, everything is shown under
  /// every tab so the screen never ends up empty because of filtering.
  List<Package> get filteredPackages {
    final all = allPackages;
    if (all.isEmpty) return all;
    final months = durations[selectedDurationIndex]['months'] as int;
    final hasInfo = all.any((p) => p.hasDurationInfo);
    if (!hasInfo) return all;
    return all.where((p) => p.matchesDuration(months)).toList();
  }

  Future<void> getPackages() async {
    emit(GetPackagesLoadingState());
    var result = await packagesRepos!.getPackages();
    return result.fold((failure) {
      emit(GetPackagesErrorState(failure.errMessage));
    }, (data) {
      packagesModel = data;
      emit(GetPackagesSuccessState(data));
    });
  }
}
