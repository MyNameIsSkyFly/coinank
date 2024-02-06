import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TipDialog extends StatelessWidget {
  const TipDialog({super.key, required this.title, required this.content});

  final String title;
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 45),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Styles.tsBody_18m(context),
            ),
            const Gap(10),
            Text(
              content ?? '',
              style: Styles.tsBody_14(context),
            ),
            const Gap(20),
            Center(
              child: InkWell(
                onTap: Get.back,
                child: Container(
                  decoration: BoxDecoration(
                    color: Styles.cMain,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    S.current.s_ok,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
