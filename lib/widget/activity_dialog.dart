import 'package:ank_app/entity/activity_entity.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityDialog extends StatelessWidget {
  const ActivityDialog({super.key, required this.data});

  final ActivityEntity data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minHeight: 230, maxHeight: 490),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 45),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              StoreLogic.to.isDarkMode
                  ? Assets.commonIcActivityNight
                  : Assets.commonIcActivityLight,
              width: 40,
              height: 40,
            ),
            const Gap(15),
            Text(
              data.title ?? '',
              style: Styles.tsBody_18m(context),
            ),
            const Gap(10),
            Container(
              constraints: const BoxConstraints(maxHeight: 280),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Text(
                    data.content ?? '',
                    style: Styles.tsBody_14(context),
                  ),
                ],
              ),
            ),
            const Gap(20),
            InkWell(
              onTap: Get.back,
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Styles.cMain,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  S.current.s_ok,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
