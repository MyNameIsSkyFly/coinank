import 'dart:io';

import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class SelectorSheetWithInterceptor extends StatefulWidget {
  const SelectorSheetWithInterceptor(
      {super.key, required this.title, required this.dataList});

  final String title;
  final List<String> dataList;

  @override
  State<SelectorSheetWithInterceptor> createState() =>
      _SelectorSheetWithInterceptorState();
}

class _SelectorSheetWithInterceptorState
    extends State<SelectorSheetWithInterceptor> {
  RxString current = ''.obs;

  void tapCell(int index) {
    current.value = widget.dataList[index];
    Get.back(result: current.value);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (Platform.isIOS)
          Container(
            constraints: BoxConstraints(
                minHeight:
                    AppConst.height - kToolbarHeight - AppConst.statusBarHeight,
                maxHeight: AppConst.height -
                    kToolbarHeight -
                    AppConst.statusBarHeight),
            child: PointerInterceptor(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: Get.back,
                child: Container(),
              ),
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
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
                        child: Container(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          child: Row(
                            children: [
                              Text(
                                widget.title,
                                style: Styles.tsBody_16(context),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: Get.back,
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
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((cnt, index) {
                        return InkWell(
                          onTap: () => tapCell(index),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Text(widget.dataList[index],
                                    style: Styles.tsBody_14m(context)),
                                const Spacer(),
                                Obx(() {
                                  return Offstage(
                                    offstage:
                                        widget.dataList[index] != current.value,
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
                      }, childCount: widget.dataList.length),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 15 + AppConst.bottomBarHeight),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
