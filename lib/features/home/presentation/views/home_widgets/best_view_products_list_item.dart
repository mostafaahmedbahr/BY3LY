import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
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
                     child: Container(
                       height: 30,
                       width: 30,
                       decoration:   BoxDecoration(
                         color: Colors.grey.withOpacity(0.5),
                         shape: BoxShape.circle,
                       ),
                       child: BlocConsumer<FavCubit, FavStates>(
                         listener: (context, favState) {
                           if (favState is FavToggleSuccess) {
                             CherryToast.success(
                               title: Text(
                                   favState.message ?? '',
                                   style: const TextStyle(
                                       color: AppColors.mainColor)),
                             ).show(context);
                           } else if (favState is FavToggleError) {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(favState.message)),
                             );
                           }
                         },
                         builder: (context, favState) {
                           final isFav = FavCubit.get(context)
                                   .isFavourite(bestView.id) ||
                               bestView.isFavourite == true;
                           final toggling = favState
                                   is FavToggleOptimistic &&
                               favState.productId == bestView.id;
                           return InkWell(
                               onTap: () {
                                 if (bestView.id != null && !toggling) {
                                   FavCubit.get(context).toggleFavourite(
                                       productId: bestView.id!);
                                 }
                               },
                               child: toggling
                                   ? const Padding(
                                       padding: EdgeInsets.all(7.0),
                                       child: SizedBox(
                                         width: 16,
                                         height: 16,
                                         child: CircularProgressIndicator(
                                           strokeWidth: 2,
                                           color: AppColors.whiteColor,
                                         ),
                                       ),
                                     )
                                   : Icon(
                                       isFav
                                           ? Icons.favorite
                                           : Icons.favorite_border,
                                       color: isFav
                                           ? AppColors.redColor
                                           : Colors.grey,
                                       size: 18));
                         },
                       )
                       ,
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
