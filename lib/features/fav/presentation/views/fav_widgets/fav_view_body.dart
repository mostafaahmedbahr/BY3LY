import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:by3ly/features/fav/data/models/fav_model.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/shared_widgets/custom_text_form_filed.dart';
import '../../../../../core/utils/app_images/app_images.dart';
import 'fav_data_list_loading.dart';
import 'fav_item_widget.dart';

class FavViewBody extends StatefulWidget {
  const FavViewBody({super.key});

  @override
  State<FavViewBody> createState() => _FavViewBodyState();
}

class _FavViewBodyState extends State<FavViewBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The startup call may have run before login (401) or on a bad
    // network, so fetch again when the tab is opened with no data.
    // Guests never fire the request.
    if (GuestGuard.isGuest) return;
    final cubit = FavCubit.get(context);
    if (cubit.favDataModel?.data?.favourites == null) {
      cubit.getFavData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Favourites> _filtered(List<Favourites> source) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return source;
    return source.where((f) {
      final name = (f.name ?? '').toLowerCase();
      final desc = (f.desc ?? '').toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Favourites are account-scoped: guests see the standard wall.
    if (GuestGuard.isGuest) {
      return const GuestPlaceholder();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            hintText: context.tr(LocaleKeys.searchWithBy3ly),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(AppImages.search),
            ),
            suffixIcon: _searchController.text.trim().isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () =>
                        setState(() => _searchController.clear()),
                  )
                : null,
            onChanged: (_) => setState(() {}),
          ),
          const CustomSizedBox(height: 16),
          Expanded(
            child: BlocConsumer<FavCubit, FavStates>(
              listener: (context, state) {
                if (state is RemoveProductFromFavSuccess) {
                  final msg = (state.removeProductFromFavModel.message
                              ?.trim()
                              .isNotEmpty ??
                          false)
                      ? state.removeProductFromFavModel.message!
                      : context.tr(LocaleKeys.removedFromFav);
                  CherryToast.success(
                    title: Text(msg,
                        style: const TextStyle(color: AppColors.mainColor)),
                  ).show(context);
                } else if (state is RemoveProductFromFavError ||
                    state is FavToggleError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state is RemoveProductFromFavError
                            ? state.message
                            : (state as FavToggleError).message,
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final favCubit = context.read<FavCubit>();
                final favorites =
                    favCubit.favDataModel?.data?.favourites;
                if (state is GetFavDataLoading && favorites == null) {
                  return const FavDataListLoading();
                } else if (state is GetFavDataError && favorites == null) {
                  return CustomErrorWidget(
                    error: state.message,
                    onTap: () => favCubit.getFavData(),
                  );
                }
                final query = _searchController.text.trim();
                final items = _filtered(favorites ?? const <Favourites>[]);
                if (items.isEmpty) {
                  // Distinguish "search found nothing" from "nothing saved".
                  if (query.isNotEmpty) {
                    return _EmptyHint(text: context.tr(LocaleKeys.noResults));
                  }
                  return const _EmptyFavourites();
                }
                return RefreshIndicator(
                  onRefresh: () => favCubit.getFavData(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        FavItemWidget(favourite: items[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// One-line hint used when a search query matches nothing.
class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Premium empty state — saved favourites show as a soft heart hero.
class _EmptyFavourites extends StatelessWidget {
  const _EmptyFavourites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.redColor.withValues(alpha: 0.08),
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: AppColors.redColor,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              context.tr(LocaleKeys.favEmptyTitle),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr(LocaleKeys.favEmptySubtitle),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
