import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'funding_rate_search_logic.dart';

class FundingRateSearchPage extends StatefulWidget {
  const FundingRateSearchPage({super.key});

  @override
  State<FundingRateSearchPage> createState() => _FundingRateSearchPageState();
}

class _FundingRateSearchPageState extends State<FundingRateSearchPage> {
  final logic = Get.put(FundingRateSearchLogic());
  final state = Get.find<FundingRateSearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConst.height - AppConst.statusBarHeight - kToolbarHeight,
      padding: EdgeInsets.only(bottom: AppConst.bottomBarHeight + 15),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    // keyboardType:
                    //     const TextInputType.numberWithOptions(signed: true),
                    style: Styles.tsBody_16(context),
                    inputFormatters: [
                      RegexFormatter(regex: RegexExpression.regexOnlyLetter),
                      LengthLimitingTextInputFormatter(10),
                      UpperCaseTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      filled: true,
                      constraints: const BoxConstraints(maxHeight: 40),
                      contentPadding: EdgeInsets.zero,
                      hintText: S.current.s_search,
                      hintStyle: Styles.tsSub_14(context),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10),
                        child: Image.asset(
                          Assets.commonIconSearch,
                          width: 16,
                          height: 16,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(maxWidth: 40),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
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
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Gap(20),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: state.data.length,
                shrinkWrap: true,
                itemExtent: 50,
                itemBuilder: (cnt, idx) {
                  String item = state.data.toList()[idx];
                  return InkWell(
                    onTap: () => logic.tapItem(item),
                    child: Row(
                      children: [
                        ClipOval(
                          child: idx == 0
                              ? Image.asset(
                                  Assets.commonIconExchangeAll,
                                  width: 24,
                                  height: 24,
                                )
                              : ImageUtil.networkImage(
                                  AppConst.imageHost(item),
                                  width: 24,
                                  height: 24,
                                ),
                        ),
                        const Gap(10),
                        Text(
                          item,
                          style: Styles.tsBody_16m(context),
                        ),
                        const Spacer(),
                        Obx(() {
                          return Image.asset(
                            state.selects.toList().contains(item)
                                ? Assets.commonIconCheckCircleSelect
                                : Assets.commonIconCheckCircleNormal,
                            width: 20,
                          );
                        }),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          const Gap(16),
          InkWell(
            onTap: () => Get.back(result: state.selects.toList()),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Styles.cMain,
              ),
              alignment: Alignment.center,
              child: Text(
                S.current.s_ok,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<FundingRateSearchLogic>();
    super.dispose();
  }
}
