import 'dart:convert';

import 'package:ank_app/entity/push_record_entity.dart';
import 'package:ank_app/modules/alert/alert_manage_view.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:ank_app/widget/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'alert_text_parse.dart';

class AlertRecordPage extends StatefulWidget {
  const AlertRecordPage({super.key});

  static const String routeName = '/noticeRecord';

  @override
  State<AlertRecordPage> createState() => _AlertRecordPageState();
}

class _AlertRecordPageState extends State<AlertRecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late String type;

  final indexMap = {
    'signal': 0,
    'price': 1,
    'oiAlert': 2,
    'fundingRate': 3,
    'liquidation': 4,
    'priceWave': 5,
    'transaction': 6,
    'announcement': 7,
    'hugeWaves': 8,
    'frAlert': 9,
    'lsAlert': 10
  };

  @override
  void initState() {
    type = Get.arguments?['type'] ?? '';
    _tabController = TabController(
        length: 12, vsync: this, initialIndex: indexMap[type] ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).noticeRecords),
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(AlertManagePage.routeName);
              },
              icon: Icon(Icons.settings, color: Styles.cSub(context)))
        ],
      ),
      body: Column(
        children: [
          TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              labelStyle: Styles.tsBody_14(context).medium,
              unselectedLabelStyle: Styles.tsSub_14(context),
              labelColor: Styles.cBody(context),
              unselectedLabelColor: Styles.cSub(context),
              tabs: [
                Tab(text: S.of(context).signal),
                Tab(text: S.of(context).price),
                Tab(text: S.of(context).oiAlert),
                Tab(text: S.of(context).s_funding_rate),
                Tab(text: S.of(context).largeLiquidation),
                Tab(text: S.of(context).priceWave),
                Tab(text: S.of(context).largeTransaction),
                Tab(text: S.of(context).announcement),
                Tab(text: S.of(context).hugeWave),
                Tab(text: S.of(context).fundingRateAlert),
                Tab(text: S.of(context).longShortAlert),
                Tab(text: S.of(context).advanced),
              ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: NoticeRecordType.values
                  .where((p0) => p0 != NoticeRecordType.unknown)
                  .map(_TabItemView.new)
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItemView extends StatefulWidget {
  const _TabItemView(this.type, {super.key});

  final NoticeRecordType type;

  @override
  State<_TabItemView> createState() => _TabItemViewState();
}

class _TabItemViewState extends State<_TabItemView>
    with AutomaticKeepAliveClientMixin {
  final list = RxList<PushRecordEntity>();
  final hugeWaveList = RxList<PushRecordHugeWaveEntity>();
  final _loading = true.obs;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future<void> onRefresh() async {
    if (widget.type == NoticeRecordType.hugeWaves) {
      await Apis()
          .getUserHugeWavePushRecords(
              type: NoticeRecordType.hugeWaves,
              language: AppUtil.shortLanguageName)
          .then((value) {
        hugeWaveList.assignAll(value ?? []);
        _loading.value = false;
      });
    } else {
      await Apis()
          .getUserPushRecords(
              type: widget.type, language: AppUtil.shortLanguageName)
          .then((value) {
        final l = value ?? [];
        if (widget.type == NoticeRecordType.announcement) {
          l.removeWhere((element) {
            final data =
                jsonDecode(element.from ?? '{}') as Map<String, dynamic>;
            final title = (data['title']
                as Map<String, dynamic>)[AppUtil.shortLanguageName];
            element.title = title;
            return title == null;
          });
        }
        list.assignAll(l);
        _loading.value = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.type case NoticeRecordType.advanced) {
      return Center(
        child: TextButton(
            onPressed: () => AppNav.openWebUrl(
                  dynamicTitle: true,
                  url: Get.find<SettingLogic>()
                          .state
                          .settingList
                          .firstWhereOrNull((element) =>
                              element.url?.contains('noticeRecords') == true)
                          ?.url ??
                      'https://coinank.com/zh/m/noticeRecords?pushType=warnSignal&type=signal&lng=${AppUtil.shortLanguageName}',
                ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                S.of(context).tmpToast,
                textAlign: TextAlign.center,
              ),
            )),
      );
    }
    late Widget child;
    if (widget.type == NoticeRecordType.hugeWaves) {
      child = Obx(() {
        if (_loading.value) {
          return ListView(children: const [LottieIndicator()]);
        }
        if (hugeWaveList.isEmpty) {
          return ListView(
              children: const [EmptyView(padding: EdgeInsets.only(top: 200))]);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: hugeWaveList.length,
          itemBuilder: (context, index) {
            final m = hugeWaveList[index];
            late String text;
            if (m.type == 'openSignal') {
              text = S.of(context).hugeWaveTypeOi(
                  m.baseCoin ?? '', m.openInterest ?? 0, m.price ?? 0);
            } else {
              text = S
                  .of(context)
                  .hugeWaveTypeMarket(m.baseCoin ?? '', m.price ?? 0);
            }
            return _ItemContainer(
              pushTime: hugeWaveList[index].ts ?? 0,
              child: Text(
                text,
                style: Styles.tsBody_14m(context),
              ),
            );
          },
        );
      });
    } else {
      child = Obx(() {
        if (_loading.value) {
          return ListView(children: const [LottieIndicator()]);
        }
        if (list.isEmpty) {
          return Center(
            child: ListView(shrinkWrap: true, children: const [
              EmptyView(
                padding: EdgeInsets.symmetric(vertical: 200),
              )
            ]),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _ItemContainer(
              pushTime: list[index].pushTime ?? 0,
              child: getRecordText(list[index], context),
            );
          },
        );
      });
    }
    return AppRefresh(onRefresh: onRefresh, child: child);
  }
}

class _ItemContainer extends StatelessWidget {
  const _ItemContainer({required this.child, required this.pushTime});

  final Widget child;
  final int pushTime;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                height: 6,
                width: 2,
                color: Styles.cTextFieldFill(context),
              ),
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Styles.cSub(context), width: 2),
                ),
              ),
              Expanded(
                  child: Container(
                height: double.infinity,
                width: 2,
                color: Styles.cTextFieldFill(context),
              ))
            ],
          ),
          const Gap(11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    DateFormat('MM-dd HH:mm')
                        .format(DateTime.fromMillisecondsSinceEpoch(pushTime)),
                    style: Styles.tsSub_14m(context)),
                const Gap(10),
                child,
                const Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
