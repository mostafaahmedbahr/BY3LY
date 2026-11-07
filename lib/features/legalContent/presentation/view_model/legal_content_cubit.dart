import 'package:by3ly/features/legalContent/data/models/legal_content_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/legalContent/data/repos/legal_content_repos.dart';
import 'package:by3ly/features/legalContent/presentation/view_model/legal_content_states.dart';

class LegalContentCubit extends Cubit<LegalContentStates> {
  LegalContentCubit(this.legalContentRepos) : super(LegalContentInitState());

  static LegalContentCubit get(dynamic context) => BlocProvider.of(context);

  final LegalContentRepos legalContentRepos;

  LegalContentModel? legalContentModel;

  Future<void> getLegalContent(LegalContentType type) async {
    emit(GetLegalContentLoadingState());
    var result = await legalContentRepos.getLegalContent(type);
    return result.fold((failure) {
      debugPrint('LegalContentCubit failed: ${failure.errMessage}');
      emit(GetLegalContentErrorState(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        legalContentModel = data;
        emit(GetLegalContentSuccessState(data));
      } else {
        emit(GetLegalContentErrorState(data.message ?? 'Something went wrong'));
      }
    });
  }
}
