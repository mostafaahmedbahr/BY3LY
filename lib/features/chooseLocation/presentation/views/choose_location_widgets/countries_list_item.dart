// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../../../../core/utils/app_colors/app_colors.dart';
// import '../../../../../core/utils/app_styles/app_styles.dart';
//
// class CountriesListItem extends StatelessWidget {
//     CountriesListItem({super.key, required this.name , required this.onTap, required this.index});
//   final String name;
//   final int index;
//   void Function() onTap;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: index == 1 ?
//             const Color.fromRGBO(14, 133, 101, 0.25) : const Color(0xffF8F8F8)
//         ),
//         child: Row(
//           children: [
//             SvgPicture.asset("assets/images/Map-location.svg"),
//             const SizedBox(width: 10,),
//             Text(name,
//                 style: AppStyles.textStyle16W600Black.copyWith(
//                   color: AppColors.mainColor,
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }
