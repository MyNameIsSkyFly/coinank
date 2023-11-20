import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/sliver_app_bar_delegate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_bottom_sheet_logic.dart';

class CustomBottomSheetPage extends StatelessWidget {
  CustomBottomSheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(CustomBottomSheetLogic());
    final state = Get.find<CustomBottomSheetLogic>().state;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 62,
              minHeight: 62,
              child: Row(
                children: [
                  Text(
                    state.title,
                    style: Styles.tsBody_16(context),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Text(
                      S.current.s_cancel,
                      style: Styles.tsSub_16(context),
                    ),
                    constraints: const BoxConstraints.tightFor(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((cnt, index) {
              return InkWell(
                onTap: () => logic.tapCell(index),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(state.dataList[index],
                          style: Styles.tsBody_14m(context)),
                      const Spacer(),
                      Obx(() {
                        return Offstage(
                          offstage:
                              state.dataList[index] != state.current.value,
                          child: const Icon(
                            Icons.check_sharp,
                            size: 20,
                            color: Styles.cMain,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            }, childCount: state.dataList.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15 + AppConst.bottomBarHeight),
          )
        ],
      ),
    );
  }
}
