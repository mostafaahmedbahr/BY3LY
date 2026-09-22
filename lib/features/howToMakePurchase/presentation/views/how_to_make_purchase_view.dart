import 'package:by3ly/main_importants.dart';

import 'how_to_make_purchase_widgets/how_to_make_purchase_view_body.dart';

class HowToMakePurchaseView extends StatelessWidget {
  const HowToMakePurchaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تعليمات الشراء"),
      ),
      body: const HowToMakePurchaseViewBody(),
    );
  }
}
