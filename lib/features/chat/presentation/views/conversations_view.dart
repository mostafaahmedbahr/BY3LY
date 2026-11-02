import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

import '../view_model/chat_states.dart';
import '../view_model/chat_unread_cubit.dart';
import '../view_model/conversations_cubit.dart';
import 'conversations_widgets/conversations_view_body.dart';

class ConversationsView extends StatelessWidget {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.mainColor,
        shadowColor: AppColors.mainColor,
        title: Row(
          children: [
            Text(
              context.tr(LocaleKeys.conversations),
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            BlocBuilder<ChatUnreadCubit, ChatUnreadStates>(
              builder: (context, state) {
                final unread = ChatUnreadCubit.get(context).count;
                if (unread <= 0) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.redColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: context.tr(LocaleKeys.refresh),
            onPressed: () => ConversationsCubit.get(context).refresh(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: const ConversationsViewBody(),
    );
  }
}
