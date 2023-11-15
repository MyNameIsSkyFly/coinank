import 'package:flutter/material.dart';
import 'package:ank_app/res/export.dart';
import 'package:get/get.dart';

import 'contract_market_logic.dart';

class ContractMarketPage extends StatelessWidget {
  ContractMarketPage({Key? key}) : super(key: key);

  final logic = Get.put(ContractMarketLogic());
  final state = Get.find<ContractMarketLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Wrap(
                    children: List.generate(
                      10,
                      (index) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        height: 24,
                        decoration: BoxDecoration(
                          color: index == 0
                              ? Styles.cMain.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'BTC',
                          style: index == 0
                              ? Styles.tsMain_14m.copyWith(height: 1.4)
                              : Styles.tsSub_14(context).copyWith(height: 1.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8),
              color: Theme.of(context).colorScheme.tertiary,
              width: 39,
              height: 24,
              alignment: Alignment.centerLeft,
              child: Image.asset(
                Assets.commonIconSearch,
                width: 16,
                height: 16,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
          child: Row(
            children: [
              Text(
                'Coin',
                style: Styles.tsSub_14(context).copyWith(height: 1.4),
              ),
              const Spacer(),
              SortWithArrow(title: S.current.s_price),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text('/', style: Styles.tsSub_12m(context)),
              ),
              SortWithArrow(title: S.current.s_24h_turnover),
              SizedBox(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SortWithArrow(title: S.current.s_oi),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text('/', style: Styles.tsSub_12m(context)),
                    ),
                    SortWithArrow(title: S.current.s_funding_rate),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            itemCount: 20,
            itemBuilder: (cnt, idx) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        color: Colors.yellow,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Okex',
                          style:
                              Styles.tsBody_12m(context).copyWith(height: 1.4),
                        ),
                        const Gap(5),
                        Text(
                          'BTC-USDC-240329',
                          style: Styles.tsSub_10(context).copyWith(
                            fontSize: 9,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$35388.2',
                          style: Styles.tsBody_12(context).copyWith(height: 1.4),
                        ),
                        const Gap(3),
                        Text(
                          '\$1.23万',
                          style:
                          Styles.tsSub_12(context).copyWith(height: 1.4),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$55.79万',
                            style: Styles.tsBody_12(context).copyWith(height: 1.4),
                          ),
                          const Gap(3),
                          Text(
                            '0.0000%',
                            style:
                                Styles.tsSub_12(context).copyWith(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
