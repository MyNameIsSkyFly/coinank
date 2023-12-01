import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'custom_search_bottom_sheet_logic.dart';

class CustomSearchBottomSheetPage extends StatelessWidget {
  const CustomSearchBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(CustomSearchBottomSheetLogic());
    final state = Get.find<CustomSearchBottomSheetLogic>().state;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        height: AppConst.height - AppConst.statusBarHeight - kToolbarHeight,
        color: Theme.of(context).appBarTheme.backgroundColor,
        child: Obx(() {
          return CustomScrollView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  maxHeight: 80,
                  minHeight: 80,
                  child: Container(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              // keyboardType:
                              //     const TextInputType.numberWithOptions(signed: true),
                              style: Styles.tsBody_16(context),
                              maxLines: 1,
                              inputFormatters: [
                                RegexFormatter(
                                    regex: RegexExpression.regexOnlyLetter),
                                LengthLimitingTextInputFormatter(10),
                                UpperCaseTextFormatter(),
                              ],
                              decoration: InputDecoration(
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                filled: true,
                                constraints:
                                    const BoxConstraints(maxHeight: 40),
                                contentPadding: EdgeInsets.zero,
                                hintText: S.current.s_search,
                                hintStyle: Styles.tsSub_14(context),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10),
                                  child: Image.asset(
                                    Assets.commonIconSearch,
                                    width: 16,
                                    height: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                                ),
                                prefixIconConstraints:
                                    const BoxConstraints(maxWidth: 40),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onChanged: (v) => logic.search(v),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            height: 40,
                            child: IconButton(
                              onPressed: Get.back,
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (cnt, index) {
                    return InkWell(
                      onTap: () => logic.tapCell(index),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(state.dataList.toList()[index],
                                style: Styles.tsBody_14m(context)),
                            const Spacer(),
                            Obx(() {
                              return Offstage(
                                offstage: state.dataList.toList()[index] !=
                                    state.current.value,
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
                  },
                  childCount: state.dataList.length,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 15 + AppConst.bottomBarHeight),
              )
            ],
          );
        }),
      ),
    );
  }
}
