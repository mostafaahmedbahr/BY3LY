import 'package:flutter/material.dart';

import 'delete_account_button.dart';
import 'delete_notice_card.dart';
import 'delete_warning_hero.dart';

class DeleteAccountViewBody extends StatelessWidget {
  const DeleteAccountViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DeleteWarningHero(),
                    SizedBox(height: 16),
                    DeleteNoticeCard(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const DeleteAccountButton(),
          ],
        ),
      ),
    );
  }
}
