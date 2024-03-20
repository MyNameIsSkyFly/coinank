import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customize/reorder_view.dart';
import '../filter/contract_coin_filter_view.dart';

class CustomizeFilterHeaderView extends StatelessWidget {
  const CustomizeFilterHeaderView({super.key, this.onFinishFilter});

  final VoidCallback? onFinishFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Styles.cLine(context)))),
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Get.toNamed(ReorderPage.routeName),
              child: Row(
                children: [
                  Image.asset(
                    Assets.commonIcPuzzlePiece,
                    width: 12,
                    height: 12,
                    color: Styles.cBody(context),
                  ),
                  const Gap(4),
                  Expanded(
                    child: Text(
                      S.of(context).customizeList,
                      style: Styles.tsBody_12(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Get.bottomSheet(const ContractCoinFilterPage(),
                        isScrollControlled: true, ignoreSafeArea: false)
                    .then((value) {
                  onFinishFilter?.call();
                });
              },
              child:
                  const ImageIcon(AssetImage(Assets.commonIcFilter), size: 20))
        ],
      ),
    );
  }
}
