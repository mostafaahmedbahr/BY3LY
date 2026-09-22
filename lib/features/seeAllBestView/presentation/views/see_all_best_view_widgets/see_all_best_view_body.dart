  import 'package:by3ly/core/shared_widgets/container_search_widget.dart';
 import 'package:by3ly/features/seeAllBestView/presentation/views/see_all_best_view_widgets/see_all_best_view_body_list.dart';
  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 import '../../view_model/sell_all_best_view_cubit.dart';
import '../../view_model/sell_all_best_view_states.dart';

class SeeAllBestViewBody extends StatelessWidget {
  const SeeAllBestViewBody({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocConsumer<SellAllBestViewCubit , SellAllBestViewStates>(
       listener: (context ,state){},
       builder:  (context ,state){
         return const Padding(
           padding: EdgeInsets.all(20.0),
           child:  Column(
             children: [
               ContainerSearchWidget(),
               SizedBox(height: 20,),
               Expanded(child: SeeAllBestViewBodyList()),

             ],
           ),
         );
       },

     );
  }
}
