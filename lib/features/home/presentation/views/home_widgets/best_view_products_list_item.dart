import 'package:by3ly/core/shared_widgets/fav_heart_button.dart';
import 'package:by3ly/features/home/presentation/view_model/home_states.dart';

import '../../../../../main_importants.dart';
import '../../../data/models/home_model.dart';
import '../../view_model/home_cubit.dart';

class BestViewProductsListItem extends StatelessWidget {
   const BestViewProductsListItem({super.key, required this.bestView});
   final BestView bestView;
   @override
   Widget build(BuildContext context) {
     return BlocConsumer<HomeCubit,HomeStates>(
       listener: (context,state){},
       builder:  (context,state){
         return InkWell(
           onTap: () {
             context.pushNamed(Routes.productDetailsView, arguments: {
               "type": "home",
               "productId": bestView.id ?? 0,
             });
           },
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Stack(
                 children: [
                   CustomNetWorkImage(
                     imageUrl: "${bestView.image}",
                     raduis: 10,
                     fit: BoxFit.cover,
                     width: double.infinity,
                     height: 120,
                   ),
                   Positioned(
                     top: 5,
                     right: 5,
                     child: FavHeartButton(
                       productId: bestView.id,
                       initialIsFavourite: bestView.isFavourite == true,
                     ),
                   ),
                 ],
               ),
               const SizedBox(height: 10),
               Text(
                 "${bestView.name}",
                 maxLines: 2,
                 overflow: TextOverflow.ellipsis,
                 style: const TextStyle(
                   fontSize: 12,
                   fontWeight: FontWeight.w400,
                   color: Color(0xff000000),
                 ),
               ),
               const SizedBox(height: 5),
               Row(
                 children: [
                   SvgPicture.asset(AppImages.location),
                   const SizedBox(width: 5),
                   Expanded(
                     child: Text(
                       (bestView.location?.toString().trim().isNotEmpty ??
                               false)
                           ? bestView.location.toString()
                           : "لا يوجد",
                       maxLines: 1,
                       overflow: TextOverflow.ellipsis,
                       style: AppStyles.textStyle10W400Green,
                     ),
                   ),
                 ],
               ),
               const SizedBox(height: 5),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Row(
                     children: [
                       const Text(
                         "النوع ",
                         style: AppStyles.textStyle10W400Gray,
                       ),
                       Text(
                         "${bestView.type}",
                         style: AppStyles.textStyle10W400Yellow,
                       ),
                     ],
                   ),
                   Row(
                     children: [
                       const Text(
                         "الاثاث ",
                         style: AppStyles.textStyle10W400Gray,
                       ),
                       Text(
                         " ${bestView.model}",
                         style: AppStyles.textStyle10W400Yellow,
                       ),
                     ],
                   ),
                 ],
               ),
               const SizedBox(height: 5),
               Text(
                 "${bestView.price}",
                 style: const TextStyle(
                   fontSize: 18,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               const SizedBox(height: 5),
               Text(
                 "${bestView.createdAt}",
                 style: AppStyles.textStyle10W400Green.copyWith(
                   color: const Color(0xff7A7A7A),
                 ),
               ),
             ],
           ),
         );
       },

     );
   }
 }
