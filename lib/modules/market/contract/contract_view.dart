import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'contract_logic.dart';

class ContractPage extends StatelessWidget {
  const ContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(ContractLogic());
    final state = Get.find<ContractLogic>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset(
                  Assets.commonIconSearch,
                  width: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const Gap(10),
                Text(
                  S.current.s_search,
                  style: Styles.tsSub_12(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
            child: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    Assets.commonIconStar,
                    width: 17,
                    height: 17,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const Gap(15),
                SortWithArrow(
                  title: S.current.s_oi_vol,
                  status: state.oiSort,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '/',
                    style: Styles.tsSub_12m(context),
                  ),
                ),
                SortWithArrow(
                  title: S.current.s_oi_chg,
                  status: state.oiChangeSort,
                ),
                const Spacer(),
                SortWithArrow(
                  title: S.current.s_price,
                  status: state.priceSort,
                ),
                // const Gap(30),
                Container(
                  width: 90,
                  alignment: Alignment.centerRight,
                  child: SortWithArrow(
                    title: S.current.s_price_chg,
                    status: state.priceChangSort,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemBuilder: (cnt, idx) {
                return _DataItem();
              },
              itemCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataItem extends StatelessWidget {
  const _DataItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              Assets.commonIconStarFill,
              width: 17,
              height: 17,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .color!
                  .withOpacity(0.3),
            ),
          ),
          const Gap(15),
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
                'BTC',
                style: Styles.tsBody_12m(context).copyWith(height: 1.4),
              ),
              const Gap(5),
              Row(
                children: [
                  Text(
                    '65.65亿',
                    style: Styles.tsSub_12(context).copyWith(height: 1.4),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '+2.82%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Styles.cUp(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            '\$1889.6',
            style: Styles.tsBody_14(context).copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const Gap(25),
          Container(
            width: 65,
            height: 27,
            decoration: BoxDecoration(
              color: Styles.cUp(context),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              '+1.22%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
