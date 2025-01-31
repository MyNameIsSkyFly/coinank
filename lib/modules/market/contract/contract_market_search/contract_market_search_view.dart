import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'contract_market_search_logic.dart';

class ContractMarketSearchPage extends StatelessWidget {
  ContractMarketSearchPage({super.key});

  final logic = Get.find<ContractMarketSearchLogic>();
  final state = Get.find<ContractMarketSearchLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GestureDetectorWidget(
      child: Scaffold(
        appBar: AppTitleBar(
          customWidget: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    style: Styles.tsBody_16(context),
                    inputFormatters: [
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
                          color: Theme.of(context).iconTheme.color,
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
                    onChanged: logic.search,
                  ),
                ),
                InkWell(
                  onTap: Get.back,
                  child: SizedBox(
                    width: 62,
                    child: Center(
                      child: Text(
                        S.current.s_cancel,
                        style: Styles.tsSub_16(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Obx(() {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemExtent: 50,
            itemBuilder: (cnt, idx) {
              final item = state.list[idx];
              return InkWell(
                onTap: () => Get.back(result: item),
                child: ListTile(
                  title: Text(
                    item,
                    style: Styles.tsBody_14m(context),
                  ),
                ),
              );
            },
            itemCount: state.list.length,
          );
        }),
      ),
    );
  }
}
