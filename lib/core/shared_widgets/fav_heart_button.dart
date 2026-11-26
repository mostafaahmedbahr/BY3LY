import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

/// Shared favourite (heart) button used on every product card in the app.
///
/// - Instant UI: the colour flips at once (optimistic update in [FavCubit])
///   with a small pop animation, and reverts automatically on failure.
/// - Toast is guarded by [productId], so tapping one card never shows
///   duplicate toasts from the other mounted cards.
/// - Only states that concern THIS product trigger a rebuild. A toggle no
///   longer rebuilds every heart on the screen.
class FavHeartButton extends StatefulWidget {
  const FavHeartButton({
    super.key,
    required this.productId,
    this.initialIsFavourite = false,
    this.size = 30,
    this.iconSize = 18,
    this.withBackground = true,
    this.favIconColor = AppColors.redColor,
  });

  /// Null-safe: renders nothing when the product has no id.
  final int? productId;

  /// Server value (e.g. `product.isFavourite`) used before any local toggle.
  final bool initialIsFavourite;
  final double size;
  final double iconSize;
  final bool withBackground;

  /// Colour of the heart when favourited (white when sitting on a red bubble).
  final Color favIconColor;

  @override
  State<FavHeartButton> createState() => _FavHeartButtonState();
}

class _FavHeartButtonState extends State<FavHeartButton> {
  /// Local override so an explicit remove stays un-favourited even when
  /// [widget.initialIsFavourite] came as true from the server.
  bool? _localFav;

  /// True while this button's own request is in flight (for toast guarding).
  bool _waiting = false;

  void _setLocalFav(bool? value) {
    if (_localFav == value || !mounted) return;
    setState(() => _localFav = value);
  }

  bool _isFav(FavCubit cubit) {
    // Guests always see a plain (non-favourited) heart.
    if (GuestGuard.isGuest) return false;
    return _localFav ??
        cubit.isFavourite(widget.productId) || widget.initialIsFavourite;
  }

  void _onTap() async {
    if (widget.productId == null || _waiting) return;
    // Guests must log in before favouriting.
    if (!await GuestGuard.requireLogin(context)) return;
    if (!mounted) return;
    final cubit = FavCubit.get(context);
    final nowFav = _isFav(cubit);
    setState(() {
      _localFav = !nowFav;
      _waiting = true;
    });
    cubit.toggleFavourite(productId: widget.productId!);
  }

  void _showToast(String? serverMessage, bool isNowFavourite) {
    final msg = (serverMessage?.trim().isNotEmpty ?? false)
        ? serverMessage!
        : (isNowFavourite
              ? context.tr(LocaleKeys.addedToFav)
              : context.tr(LocaleKeys.removedFromFav));
    CherryToast.success(
      title: Text(msg, style: const TextStyle(color: AppColors.mainColor)),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.productId == null) return const SizedBox.shrink();
    // read (not watch): updates arrive through the filtered listener below.
    final cubit = context.read<FavCubit>();
    final isFav = _isFav(cubit);
    final icon = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Icon(
        key: ValueKey(isFav),
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? widget.favIconColor : AppColors.textSecondary,
        size: widget.iconSize,
      ),
    );
    final child = !widget.withBackground
        ? InkWell(onTap: _onTap, child: icon)
        : Container(
            height: widget.size,
            width: widget.size,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: _onTap,
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: Center(child: icon),
            ),
          );

    return BlocListener<FavCubit, FavStates>(
      listener: (context, state) {
        if (state is GetFavDataSuccess ||
            state is AddProductToFavSuccess ||
            state is RemoveProductFromFavSuccess) {
          // Server list refreshed — re-read the ids for this product.
          if (mounted) setState(() {});
          return;
        }
        if (state is FavToggleOptimistic &&
            state.productId == widget.productId) {
          // Toggle may have been started from another screen/card.
          _setLocalFav(state.isNowFavourite);
          return;
        }
        if (!_waiting) return;
        if (state is FavToggleSuccess && state.productId == widget.productId) {
          _waiting = false;
          _setLocalFav(state.isNowFavourite);
          _showToast(state.message, state.isNowFavourite);
        } else if (state is FavToggleError) {
          // Revert the local override, cubit already reverted its set.
          _waiting = false;
          _setLocalFav(null);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: child,
    );
  }
}
