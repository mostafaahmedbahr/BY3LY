import 'package:by3ly/features/chat/presentation/views/chat_widgets/start_chat_button.dart';

import '../../../../../main_importants.dart';

class SellerContactButton extends StatelessWidget {
  const SellerContactButton({super.key, required this.sellerId});

  final int sellerId;

  @override
  Widget build(BuildContext context) {
    return StartChatButton(
      userId: sellerId,
      builder: (context, isLoading, onPressed) => InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainColor,
            border: Border.all(color: AppColors.mainColor),
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.whiteColor,
                    ),
                  )
                : const Text(
                    "تواصل الان",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
          ),
        ),
      ),
    );
  }
}
