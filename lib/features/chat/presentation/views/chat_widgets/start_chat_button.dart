import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../data/repos/chat_repository_impl.dart';
import '../../view_model/chat_states.dart';
import '../../view_model/start_chat_cubit.dart';
import '../chat_helpers.dart';

/// Starts a conversation from an ad (`productId`) or with a user directly
/// (`userId`) and opens the chat on success.
///
/// The actual API call lives in [StartChatCubit]; the widget only renders the
/// button so no request is performed from the UI layer.
class StartChatButton extends StatefulWidget {
  const StartChatButton({
    super.key,
    this.productId,
    this.userId,
    this.sellerId,
    required this.builder,
  }) : assert(productId != null || userId != null);

  final int? productId;
  final int? userId;

  /// Owner of the ad when [productId] is used. It lets the widget block a
  /// conversation with the signed-in user's own ad before calling the API.
  final int? sellerId;
  final Widget Function(
    BuildContext context,
    bool isLoading,
    VoidCallback onPressed,
  )
  builder;

  @override
  State<StartChatButton> createState() => _StartChatButtonState();
}

class _StartChatButtonState extends State<StartChatButton> {
  late final StartChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = StartChatCubit(getIt<ChatRepositoryImpl>());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await GuestGuard.requireLogin(context)) return;
    if (!mounted) return;
    if (_isSelfChat()) {
      Toast.showErrorToast(
        msg: context.tr(LocaleKeys.cannotChatWithYourself),
        context: context,
      );
      return;
    }
    await _cubit.start(productId: widget.productId, userId: widget.userId);
  }

  /// The API rejects `POST /conversations` with 422 when the other party is the
  /// current user. Detect it early so the button never produces a failed call.
  bool _isSelfChat() {
    int? currentUserId;
    try {
      currentUserId = ProfileCubit.get(context).profileModel?.data?.user?.id;
    } catch (_) {
      currentUserId = null;
    }
    if (currentUserId == null) return false;
    return widget.userId == currentUserId || widget.sellerId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartChatCubit, StartChatStates>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is StartChatSuccess) {
          context.pushNamed(
            Routes.chatView,
            arguments: {'conversation': state.conversation},
          );
        } else if (state is StartChatError) {
          Toast.showErrorToast(
            msg: chatErrorText(state.message),
            context: context,
          );
        }
      },
      builder: (context, state) {
        return widget.builder(context, state is StartChatLoading, _start);
      },
    );
  }
}
