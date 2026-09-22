// import '../../main_imports.dart';
//
// class ErrorUi extends StatelessWidget {
//   const ErrorUi({super.key, required this.errorState, required this.onPressed});
//   final dynamic errorState;
//   final void Function() onPressed;
//
//   @override
//   Widget build(BuildContext context) {
//     // استخراج رسالة الخطأ بناءً على نوع errorState
//     String errorMessage = _getErrorMessage(errorState);
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             color: AppColors.warningLight,
//             size: 64.sp,
//           ),
//           Gap(16.h),
//           Text(
//             "Error",
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.bold,
//               color: AppColors.warningLight,
//             ),
//           ),
//           Gap(8.h),
//           Text(
//             errorMessage, // استخدام المتغير الجديد
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: AppColors.gray,
//             ),
//           ),
//           Gap(16.h),
//           CustomButton(
//             width: 200.w,
//             btnText:
//             "Try Again",
//             onPressed: onPressed,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // دالة مساعدة لاستخراج رسالة الخطأ
//   String _getErrorMessage(dynamic error) {
//     if (error is String) {
//       return error; // إذا كان الخطأ نصاً، أرجع النص مباشرة
//     } else if (error is Map && error.containsKey('error')) {
//       return error['error']; // إذا كان Map به خاصية error
//     } else if (error is Exception) {
//       return error.toString(); // إذا كان Exception
//     } else {
//       return 'An unexpected error occurred'; // رسالة افتراضية
//     }
//   }
// }