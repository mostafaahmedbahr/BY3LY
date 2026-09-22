import 'dart:io';

import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';

import '../../view_model/add_advertisements_cubit.dart';
import '../../view_model/add_advertisements_states.dart';

class UploadImages extends StatelessWidget {
  const UploadImages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddAdvertisementsCubit , AddAdvertisementsStates>(
        builder: (context,state){
          var addAdvertisementsCubit = AddAdvertisementsCubit.get(context);
      return Column(
        children: [
          Center(
            child: InkWell(
              onTap: (){
                AddAdvertisementsCubit.get(context).pickImages(context);
              },
              child: SvgPicture.asset(AppImages.camera),
            ),
          ),
          Center(
            child: Text(LocaleKeys.uploadImages.tr(),
              style: AppStyles.textStyle16W500Black,
            ),
          ),
          const CustomSizedBox(height: 10,),
          AddAdvertisementsCubit.get(context).images.isNotEmpty ? Wrap(
            spacing: 10,
            runSpacing: 10,
            children: addAdvertisementsCubit.images.asMap().entries.map((entry) {
              int index = entry.key;
              File image = entry.value;
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.whiteColor,
                      ),
                      padding: const EdgeInsets.all(2),
                      child: const Icon(Icons.close,color: Colors.black87,size: 18,),
                    ),
                    onTap: (){
                      addAdvertisementsCubit.deleteImage(index);
                    },
                  ),
                ],
              );
            }).toList(),
          )
              :   Text(
            LocaleKeys.youNotUploadAnyImage.tr(),
            style: AppStyles.textStyle16W500Black,
          ),
        ],
      );
    });
  }
}
