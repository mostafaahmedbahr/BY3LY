import 'package:flutter/material.dart';

import 'all_categories_widgets/all_categories_view_body.dart';

class AllCategoriesView extends StatelessWidget {
  const AllCategoriesView({super.key,});


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("جميع الفئات",style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold
        ),),
      ),
      body:   const AllCategoriesViewBody(),
    );
  }
}
