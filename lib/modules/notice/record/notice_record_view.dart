import 'dart:convert';

import 'package:ank_app/entity/push_record_model.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/widget/app_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticeRecordPage extends StatefulWidget {
  const NoticeRecordPage({super.key});

  static const String routeName = '/noticeRecord';

  @override
  State<NoticeRecordPage> createState() => _NoticeRecordPageState();
}

class _NoticeRecordPageState extends State<NoticeRecordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 12, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).noticeRecords),
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
              children: NoticeRecordType.values.map(_TabItemView.new).toList(),
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
  final list = RxList<PushRecordModel>();
  final hugeWaveList = RxList<PushRecordHugeWaveEntity>();

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
        hugeWaveList.addAll(value ?? []);
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
        list.addAll(l);
      });
    }
  }

  Widget Function(PushRecordModel model) get builder {
    final isTw = AppUtil.shortLanguageName.contains('tw');
    return switch (widget.type) {
      NoticeRecordType.signal => (m) {
          if (AppUtil.shortLanguageName.contains('zh')) {
            return RichText(
              text: TextSpan(children: [
                TextSpan(text: m.symbol, style: Styles.tsBody_14m(context)),
                TextSpan(
                    text: ' ${S.of(context).tradingPair} ',
                    style: Styles.tsSub_14(context)),
                TextSpan(
                    text:
                        '${m.interval} ${S.of(context).level} ${m.type?.toUpperCase()} ${S.of(context).appear}',
                    style: Styles.tsSub_14(context)),
                TextSpan(
                    text:
                        ' ${m.fromTag == 'gold' ? S.of(context).goldCross : S.of(context).deadCross} ，',
                    style: Styles.tsBody_14m(context)),
                TextSpan(
                    text: S.of(context).pleasePayCloseAttentionToTheMarket,
                    style: Styles.tsSub_14(context)),
              ]),
            );
          } else {
            return RichText(
              text: TextSpan(children: [
                TextSpan(text: 'A', style: Styles.tsSub_14m(context)),
                TextSpan(
                    text:
                        ' ${m.fromTag == 'gold' ? 'gold cross' : 'dead cross'} ',
                    style: Styles.tsBody_14m(context)),
                TextSpan(
                    text: 'appears at the ', style: Styles.tsSub_14(context)),
                TextSpan(text: m.symbol, style: Styles.tsBody_14m(context)),
                TextSpan(
                    text: ' ${m.interval} level; ',
                    style: Styles.tsSub_14m(context)),
                TextSpan(
                    // text: S.of(context).pleasePayCloaseAttentionToTheMarket,
                    text: 'Please pay close attention to the market',
                    style: Styles.tsSub_14(context)),
              ]),
            );
          }
        },
      NoticeRecordType.price => (m) {
          if (AppUtil.shortLanguageName.contains('zh')) {
            return RichText(
              text: TextSpan(children: [
                TextSpan(
                    text:
                        '${m.exchange} ${m.baseCoin}-Perpetual ${S.of(context).nowAlready} ',
                    style: Styles.tsBody_14(context)),
                if (m.pushType == 'price_up')
                  TextSpan(
                      text: S.of(context).breakthrough,
                      style: TextStyle(color: Styles.cUp(context)))
                else
                  TextSpan(
                      text: S.of(context).fallingBelow,
                      style: TextStyle(color: Styles.cDown(context))),
                TextSpan(
                    text: ' \$${m.value}，${S.of(context).currentRealTimePrice}',
                    style: TextStyle(color: Styles.cBody(context))),
                TextSpan(
                    text: ' \$${m.price}',
                    style: TextStyle(
                        color: m.pushType == 'price_up'
                            ? Styles.cUp(context)
                            : Styles.cDown(context)))
              ]),
            );
          } else {
            return RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${m.exchange} ${m.baseCoin}-Perpetual is now ',
                    style: Styles.tsBody_14(context)),
                if (m.pushType == 'price_up')
                  TextSpan(
                      text: 'upward',
                      style: TextStyle(color: Styles.cUp(context)))
                else
                  TextSpan(
                      text: 'below',
                      style: TextStyle(color: Styles.cDown(context))),
                TextSpan(
                    text: ' \$${m.value} USDT, current at',
                    style: TextStyle(color: Styles.cBody(context))),
                TextSpan(
                    text: ' \$${m.price}',
                    style: TextStyle(
                        color: m.pushType == 'price_up'
                            ? Styles.cUp(context)
                            : Styles.cDown(context)))
              ]),
            );
          }
        },
      NoticeRecordType.oiAlert => (m) => SizedBox(),
      NoticeRecordType.fundingRate => (m) {
          var to = m.to ?? m.from ?? '';
          to = to.substring(0, to.length - 1);
          return Text(
            '${S.of(context).s_funding_rate} ${m.pushType == 'fundingRateTop' ? 'Top3' : 'Last3'}\n$to',
            style: Styles.tsBody_14m(context),
          );
        },
      NoticeRecordType.liquidation => (m) {
          if (AppUtil.shortLanguageName.contains('zh')) {
            if (m.pushType == 'liquidation') {
              return RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '${m.exchange} ',
                      style: Styles.tsBody_14m(context)),
                  TextSpan(text: m.symbol, style: Styles.tsBody_14m(context)),
                  TextSpan(
                      text: '${S.of(context).comesUpWithLargeAmount}【',
                      style: Styles.tsBody_14m(context)),
                  TextSpan(
                      text: m.side == 'long' ? '多单' : '空单',
                      style: TextStyle(
                          color: m.side == 'long'
                              ? Styles.cUp(context)
                              : Styles.cDown(context),
                          fontWeight: Styles.fontMedium)),
                  TextSpan(text: '】，', style: Styles.tsBody_14m(context)),
                  TextSpan(
                      text:
                          '${isTw ? '爆倉總金額' : '爆仓总金额'}【\$${AppUtil.getLargeFormatString(m.value)}】，'
                          '${isTw ? '爆倉價格' : '爆仓价格'}【\$${m.price}】',
                      style: Styles.tsBody_14m(context)),
                ]),
              );
            } else if (m.pushType == 'liqStaH1') {
              return Text(
                '${S.of(context).lastHour}，共有${m.value?.toInt()}人被${S.of(context).s_rekt}，'
                '${isTw ? '爆倉總金額為' : '爆仓总金额为'} \$${m.to}，${isTw ? m.side : m.toTag}',
                style: Styles.tsBody_14m(context),
              );
            } else if (m.pushType == 'liqSta') {
              return Text(
                '${S.of(context).last24Hours}，共有${m.value?.toInt()}人被${S.of(context).s_rekt}，'
                '${isTw ? '爆倉總金額為' : '爆仓总金额为'} \$${m.toTag}，'
                '${isTw ? '最大單筆爆倉單發生在' : '最大单笔爆仓单发生在'} ${m.symbol}'
                '${isTw ? '金額' : '金额'} \$${m.to}',
                style: Styles.tsBody_14m(context),
              );
            }
          } else {
            if (m.pushType == 'liquidation') {
              return RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: '${m.exchange} ${m.symbol} experienced a large 【',
                      style: Styles.tsBody_14m(context)),
                  TextSpan(
                      text: m.side,
                      style: TextStyle(
                          color: m.side == 'long'
                              ? Styles.cUp(context)
                              : Styles.cDown(context),
                          fontWeight: Styles.fontMedium)),
                  TextSpan(
                      text: '】 Liquidation, order TradeTurnover is '
                          '【\$${AppUtil.getLargeFormatString(m.value)}】, '
                          'order price 【\$${m.price}】',
                      style: Styles.tsBody_14m(context)),
                ]),
              );
            } else if (m.pushType == 'liqStaH1') {
              return Text(
                '${S.of(context).lastHour}，${m.value?.toInt()} traders were liquidated, '
                'the total liquidations comes in at ${m.fromTag}',
                style: Styles.tsBody_14m(context),
              );
            } else if (m.pushType == 'liqSta') {
              return Text(
                '${S.of(context).last24Hours}, ${m.value?.toInt()} traders were liquidated, '
                'the total liquidations comes in at ${m.fromTag}, The largest single liquidation order happened '
                'on ${m.exchange} - ${m.symbol} value ${m.from}',
                style: Styles.tsBody_14m(context),
              );
            }
          }
          return Text(
            '',
            style: Styles.tsBody_14m(context),
          );
        },
      NoticeRecordType.priceWave => (m) {
          if (AppUtil.shortLanguageName.contains('zh')) {
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${m.exchange} ${m.baseCoin}-Perpetual ${isTw ? '在五分鐘內劇烈波動超過' : '在五分钟内剧烈波动超过'}',
                    style: Styles.tsBody_14m(context),
                  ),
                  TextSpan(
                    text: '${m.value}%',
                    style: TextStyle(
                        color: (m.value ?? 0) > 0
                            ? Styles.cUp(context)
                            : Styles.cDown(context),
                        fontWeight: Styles.fontMedium),
                  ),
                  TextSpan(
                    text: '，${isTw ? '目前即時價格' : '当前实时价格'}\$${m.price}',
                    style: Styles.tsBody_14m(context),
                  )
                ],
              ),
            );
          } else {
            return RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${m.exchange} ${m.baseCoin}-Perpetual The current price fluctuates by more ',
                    style: Styles.tsBody_14m(context),
                  ),
                  TextSpan(
                    text: '${m.value}%',
                    style: TextStyle(
                        color: (m.value ?? 0) > 0
                            ? Styles.cUp(context)
                            : Styles.cDown(context),
                        fontWeight: Styles.fontMedium),
                  ),
                  TextSpan(
                    text: ' within 5m, and the current price: \$${m.price}',
                    style: Styles.tsBody_14m(context),
                  )
                ],
              ),
            );
          }
        },
      NoticeRecordType.transaction => (m) {
          late Widget child;
          final isZh = AppUtil.shortLanguageName.contains('zh');
          if (isZh) {
            child = RichText(
              text: TextSpan(children: [
                TextSpan(
                    text:
                        '${m.value} ${isTw ? '個' : '个'} ${m.baseCoin}，${isTw ? '總價值為' : '总价值为'}，',
                    style: Styles.tsBody_14(context)),
                TextSpan(
                    text: '\$${m.from}', style: Styles.tsBody_14m(context)),
                TextSpan(
                    text:
                        '${isTw ? '從' : '从'} ${m.fromTag} ${isTw ? '錢包轉入' : '钱包转入'} ${m.toTag} ${isTw ? '錢包' : '钱包'}',
                    style: Styles.tsBody_14(context)),
              ]),
            );
          } else {
            child = RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${m.value} ${m.baseCoin} with total of ',
                    style: Styles.tsBody_14(context)),
                TextSpan(text: '\$${m.to}', style: Styles.tsBody_14m(context)),
                TextSpan(
                    text:
                        ' transferred from ${m.fromTag} wallet to ${m.toTag} wallet',
                    style: Styles.tsBody_14(context)),
              ]),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              child,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => launchUrl(Uri.parse(m.url ?? ''),
                          mode: LaunchMode.externalApplication),
                      child: Text(S.of(context).detail)),
                ],
              ),
            ],
          );
        },
      NoticeRecordType.announcement => (m) {
          final child = Text(
            '${m.title}',
            style: Styles.tsBody_14m(context),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              child,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => launchUrl(Uri.parse(m.url ?? ''),
                          mode: LaunchMode.externalApplication),
                      child: Text(S.of(context).detail)),
                ],
              ),
            ],
          );
        },
      NoticeRecordType.hugeWaves => (m) => SizedBox(),
      NoticeRecordType.frAlert => (m) {
          return SizedBox();
        },
      NoticeRecordType.lsAlert => (m) {
          final isZh = AppUtil.shortLanguageName.contains('zh');
          return Text(
            S.of(context).noticeRecordLongshort(m.exchange ?? '',
                m.baseCoin ?? '', (isZh ? m.to : m.from) ?? '', m.value ?? 0),
            style: Styles.tsBody_14m(context),
          );
        },
      NoticeRecordType.advanced => (m) => SizedBox(),
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.type
        case NoticeRecordType.advanced ||
            NoticeRecordType.frAlert ||
            NoticeRecordType.oiAlert) {
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
              padding: const EdgeInsets.all(20.0),
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
        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _ItemContainer(
              pushTime: list[index].pushTime ?? 0,
              child: builder(list[index]),
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
