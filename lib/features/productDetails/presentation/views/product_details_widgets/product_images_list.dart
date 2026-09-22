import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared_widgets/custom_cached_network_image.dart';
import '../../../../../core/shared_widgets/custom_sized_box.dart';
import '../../../../../core/utils/app_colors/app_colors.dart';
import '../../../data/models/product_details_model.dart';
import '../../view_model/product_details_cubit.dart';
import '../../view_model/product_details_states.dart';

class ProductImagesList extends StatelessWidget {
  const ProductImagesList({super.key, required this.imagesList});
  final List<Images>? imagesList;
  @override
  Widget build(BuildContext context) {
    return   BlocBuilder<ProductDetailsCubit , ProductDetailsStates >(
      builder: (context , state ){
        var productDetailsCubit = ProductDetailsCubit.get(context);
        return SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context , index ){
              return InkWell(
                onTap: (){
                  productDetailsCubit.toggleBetweenImages(index);
                },
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 3,
                        color:productDetailsCubit.imageIndex  == index ? AppColors.mainColor : Colors.transparent,
                      )
                  ),
                  child:    CustomNetWorkImage(
                    height: 56,
                    imageUrl: imagesList![index].image.toString(),
                    fit: BoxFit.cover,
                    raduis: 10,
                  ),
                ),
              );
            },
            separatorBuilder: (context , index ){
              return const CustomSizedBox(width: 10,);
            },
            itemCount:  imagesList!.length,
          ),
        );
      },

    );
  }
}
