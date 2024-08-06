import 'package:ank_app/entity/push_record_model.dart';
import 'package:ank_app/modules/setting/setting_logic.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

final zhTitle = {
  'price_up': '价格上涨',
  'price_down': '价格下跌',
  'priceWave': '价格波动',
  'fundingRate': '资金费率',
  'fundingRateTop': '资金费率',
  'fundingRateLast': '资金费率',
  'fundingRateSpecial': '异常资金费率',
  'longShort': '多空比',
  'oiAlertAcc': '持仓累积',
  'transaction': '大额转帐',
  'liquidation': '大额爆仓',
  'liqSta': '爆仓统计(24H)',
  'liqStaH1': '爆仓统计(1H)',
  'announcement': '交易所公告',
  'openSignal': '持仓异动',
  'oiAlert': '持仓提醒',
  'lsAlert': '多空比',
  'signal': '盘口异动',
  'warnSignal': '信号提醒',
  'strategy': 'strategy',
  'bidOrder': '大额挂单',
  'Buy-Sell-Imbalance': '订单流失衡',
  'orderFlowPinBar': 'orderFlowPinBar',
  'marketSignal': '信号提醒',
  'hugeWaves': '异动',
  'kdjCross': 'KDJ',
  'rsiCross': 'RSI',
  'bollCross': 'BOLL',
  'emaCross': 'EMA',
  'smaCross': 'SMA',
  'brc20Holders': 'BRC20 持仓',
  'erc20Holders': 'ERC20 持仓',
  'asc20Holders': 'ASC20 持仓',
  'arc20Holders': 'ARC20 持仓',
};

final enTitle = {
  'price_up': 'Price Up',
  'price_down': 'Price Down',
  'priceWave': 'Price Waves',
  'fundingRate': 'Funding Rate',
  'fundingRateTop': 'Funding Rate',
  'fundingRateLast': 'Funding Rate',
  'fundingRateSpecial': 'Abnormal Funding Rate',
  'longShort': 'Long Short Ratio',
  'oiAlertAcc': 'OI Accumulation',
  'transaction': 'Large Transfer',
  'liquidation': 'Large Liquidation',
  'liqSta': 'Liquidation Statistics (24H)',
  'liqStaH1': 'Liquidation Statistics (1H)',
  'announcement': 'Exchange Announcement',
  'openSignal': 'OI Change',
  'oiAlert': 'OI Huge Waves',
  'lsAlert': 'Long Short Ratio',
  'signal': 'Signal',
  'warnSignal': 'Signal',
  'strategy': 'strategy',
  'bidOrder': 'Large Book Order',
  'Buy-Sell-Imbalance': 'Buy Sell Balance',
  'orderFlowPinBar': 'orderFlowPinBar',
  'marketSignal': 'Signal Alert',
  'hugeWaves': 'Huge Waves',
  'kdjCross': 'KDJ',
  'rsiCross': 'RSI',
  'bollCross': 'BOLL',
  'emaCross': 'EMA',
  'smaCross': 'SMA',
  'brc20Holders': 'BRC20 Holders',
  'erc20Holders': 'ERC20 Holders',
  'asc20Holders': 'ASC20 Holders',
  'arc20Holders': 'ARC20 Holdings',
};

final zhTWTitle = {
  'price_up': '價格上漲',
  'price_down': '價格下跌',
  'priceWave': '價格波動',
  'fundingRate': '資金費率',
  'fundingRateTop': '資金費率',
  'fundingRateLast': '資金費率',
  'fundingRateSpecial': '異常資金費率',
  'longShort': '多空比',
  'oiAlertAcc': '持仓累積',
  'transaction': '大額轉帳',
  'liquidation': '大額爆倉',
  'liqSta': '爆倉統計(24H)',
  'liqStaH1': '爆倉統計(1H)',
  'announcement': '交易所公告',
  'openSignal': '持倉異動',
  'oiAlert': '持倉提醒',
  'lsAlert': '多空比',
  'signal': '盤口異動',
  'warnSignal': '訊號提醒',
  'strategy': 'strategy',
  'bidOrder': '大額掛單',
  'Buy-Sell-Imbalance': '訂單流失衡',
  'orderFlowPinBar': 'orderFlowPinBar',
  'marketSignal': '訊號提醒',
  'hugeWaves': '異動',
  'kdjCross': 'KDJ',
  'rsiCross': 'RSI',
  'bollCross': 'BOLL',
  'emaCross': 'EMA',
  'smaCross': 'SMA',
  'brc20Holders': 'BRC20 持股',
  'erc20Holders': 'ERC20 持倉',
  'asc20Holders': 'ASC20 持倉',
  'arc20Holders': 'ARC20 持股',
};

final PushLanguageCont = {
  'PRICE_UP': 'price_up',
  'PRICE_DOWN': 'price_down',
  'PRICE_WAVE': 'priceWave',
  'FUNDINGRATE': 'fundingRate',
  'FUNDINGRATETOP': 'fundingRateTop',
  'FUNDINGRATELAST': 'fundingRateLast',
  'FUNDINGRATESPECIAL': 'fundingRateSpecial',
  'LONGSHORT': 'longShort',
  'OIALERTAACC': 'oiAlertAcc',
  'TRANSACTION': 'transaction',
  'LIQUIDATION': 'liquidation',
  'LIQSTA': 'liqSta',
  'LIQSTAH1': 'liqStaH1',
  'ANNOUNCEMENT': 'announcement',
  'openSignal': 'openSignal',
  'oiAlert': 'oiAlert',
  'oiAlertAcc': 'oiAlertAcc',
  'lsAlert': 'lsAlert',
  'signal': 'signal',
  'warnSignal': 'warnSignal',
  'STRATEGY': 'strategy',
  'BIGORDER': 'bidOrder',
  'ORDERFLOWUNBALANCE': 'Buy-Sell-Imbalance',
  'ORDERFLOWPINBAR': 'orderFlowPinBar',
  'MARKETSIGNAL': 'marketSignal',
  'HUGEWAVES': 'hugeWaves',
  'KDJCROSS': 'kdjCross',
  'RSICROSS': 'rsiCross',
  'BOLLCROSS': 'bollCross',
  'EMACROSS': 'emaCross',
  'SMACROSS': 'smaCross',
  'brc20Holders': 'brc20Holders',
  'erc20Holders': 'erc20Holders',
  'asc20Holders': 'asc20Holders',
  'arc20Holders': 'arc20Holders',
  'brc20Minted': 'brc20Minted',
};

Widget getRecordText(PushRecordModel pushRecord, BuildContext context) {
  final locale = AppUtil.shortLanguageName;
  if (locale == 'zh') {
    return _getRecordTextZh(pushRecord, context, locale);
  } else if (locale == 'zh-tw') {
    return _getRecordTextZhTw(pushRecord, context, locale);
  } else {
    return _getRecordTextEn(pushRecord, context, locale);
  }
}

Widget _getRecordTextZh(
    PushRecordModel m, BuildContext context, String locale) {
  final type = m.type;
  final pushType = m.pushType;
  final exName = m.exchange;
  final ex = m.exchange ?? exName;
  final baseCoin = m.baseCoin;
  final value = m.value;
  final price = m.price;
  final interval = m.interval;
  final fromTag = m.fromTag;
  final to = m.to;
  final symbol = m.symbol;
  final side = m.side;
  final openInterest = m.value;
  final from = m.from;
  final toTag = m.toTag;
  final time = m.time;

  if (PushLanguageCont['PRICE_UP'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin-Perpetual 现已'),
      TextSpan(text: '突破', style: TextStyle(color: Styles.cUp(context))),
      TextSpan(text: ' \$$value,目前实时价格'),
      TextSpan(text: ' \$$price', style: TextStyle(color: Styles.cUp(context))),
    ]));
  } else if (PushLanguageCont['PRICE_DOWN'] == pushType || 'down' == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin-Perpetual 现已'),
      TextSpan(text: '跌破', style: TextStyle(color: Styles.cDown(context))),
      TextSpan(text: ' \$$value,目前实时价格'),
      TextSpan(
          text: ' \$$price', style: TextStyle(color: Styles.cDown(context))),
    ]));
  } else if (PushLanguageCont['PRICE_WAVE'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '$ex $baseCoin-Perpetual 在五分钟内剧烈波动超过',
      ),
      TextSpan(
          text: ' $value%',
          style: TextStyle(
              color: (value ?? 0) < 0
                  ? Styles.cDown(context)
                  : Styles.cUp(context))),
      TextSpan(text: '，目前实时价格 \$$price'),
    ]));
  } else if (PushLanguageCont['FUNDINGRATE'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $symbol 资金费率$to '),
      TextSpan(
          text: '$value',
          style: TextStyle(
              color: from == 'fall to'
                  ? Styles.cDown(context)
                  : Styles.cUp(context))),
      const TextSpan(text: '，请密切关注市场'),
    ]));
  } else if (PushLanguageCont['lsAlert'] == type) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin 多空比$to '),
      TextSpan(
          text: '$value',
          style: TextStyle(
              color: from == 'up to'
                  ? Styles.cUp(context)
                  : Styles.cDown(context))),
      const TextSpan(text: '，请密切关注市场'),
    ]));
  } else if (PushLanguageCont['TRANSACTION'] == pushType) {
    final value = m.value;
    final from = m.from;
    var fromTag = m.fromTag;
    var toTag = m.toTag;
    final baseCoin = m.baseCoin;
    if ('unknown' == fromTag) {
      fromTag = '未知';
    }
    if ('unknown' == toTag) {
      toTag = '未知';
    }

    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '$value 个 $baseCoin,总价值为',
      ),
      TextSpan(text: ' $from', style: Styles.tsBody_14m(context)),
      TextSpan(
        text: ', 从 $fromTag 钱包转入 $toTag 钱包',
      ),
    ]));
  } else if (PushLanguageCont['LIQUIDATION'] == pushType) {
    final amount = m.value;

    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$ex $symbol 发生一笔大额【'),
        TextSpan(
            text: to,
            style: TextStyle(
                color: side == 'short'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(
            text:
                '】爆仓，爆仓总金额 【${AppUtil.getLargeFormatString(amount)}，爆仓价格 【$price】')
      ],
    ));
  } else if (PushLanguageCont['ANNOUNCEMENT'] == pushType) {
    final child = Text('${m.title}', style: Styles.tsBody_14m(context));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      child,
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(
            onPressed: () => launchUrl(Uri.parse(m.url ?? ''),
                mode: LaunchMode.externalApplication),
            child: Text(S.of(context).detail))
      ])
    ]);
  } else if (PushLanguageCont['FUNDINGRATETOP'] == pushType ||
      PushLanguageCont['FUNDINGRATELAST'] == pushType) {
    final isTop = pushType == PushLanguageCont['FUNDINGRATETOP'];
    return Text(
        '${isTop ? '资金费率Top3' : '资金费率Last3'}\n${isTop ? m.from?.substring(0, m.from!.length - 1) : m.to?.substring(0, m.to!.length - 1)}');
  } else if (PushLanguageCont['signal'] == pushType) {
    return Text('$baseCoin 盘口出现异动，当前价格为： \$$price 请密切关注市场');
  } else if (PushLanguageCont['openSignal'] == pushType) {
    return Text('$baseCoin 持仓出现异动，当前持仓为$openInterest ,当前价格为： \$$price 请密切关注市场');
  } else if (PushLanguageCont['warnSignal'] == pushType) {
    var baseCoin = m.baseCoin;

    if (baseCoin == 'ST') {
      baseCoin = '超级趋势';
    } else if (baseCoin == 'orderFlow') {
      baseCoin = '订单流';
    }

    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$symbol', style: Styles.tsBody_14m(context)),
        TextSpan(text: '交易对 $to 级别 $baseCoin 出现 '),
        TextSpan(text: from, style: Styles.tsBody_14m(context)),
        const TextSpan(text: ' 信号，请密切关注市场')
      ],
    ));
  } else if (PushLanguageCont['BIGORDER'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$ex $symbol'),
        TextSpan(text: '委托价格：\$$price，委托金额：$toTag，成交金额：$from，成交比例：$fromTag%'),
      ],
    ));
  } else if (PushLanguageCont['ORDERFLOWUNBALANCE'] == pushType) {
    return Text.rich(TextSpan(
      children: [TextSpan(text: '$ex $symbol $interval 出现买卖失衡提醒，请密切关注市场')],
    ));
  } else if (PushLanguageCont['MARKETSIGNAL'] == pushType) {
    return Text.rich(TextSpan(
      children: [TextSpan(text: '$ex $symbol 出现CVD异动信号，请密切关注市场')],
    ));
  } else if (PushLanguageCont['ORDERFLOWPINBAR'] == pushType) {
    return Text.rich(TextSpan(
      children: [TextSpan(text: '$ex $symbol $interval 出现订单流见顶信号，请密切关注市场')],
    ));
  } else if (PushLanguageCont['oiAlert'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text: '$baseCoin $interval 内持仓波动',
            style: Styles.tsBody_14m(context)),
        TextSpan(
            text: '$value%',
            style: TextStyle(
                color: (value ?? 0) < 0
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: '，变化：', style: Styles.tsBody_14m(context)),
        TextSpan(
            text: '$fromTag',
            style: TextStyle(
                color: (fromTag?.indexOf('-') ?? -1) > -1
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: '当前持仓：$to'),
      ],
    ));
  } else if (PushLanguageCont['oiAlertAcc'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$baseCoin 在$time 内变动'),
        TextSpan(
            text: '$toTag',
            style: TextStyle(
                color: (toTag?.indexOf('-') ?? -1) > -1
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: '当前持仓：$to', style: Styles.tsBody_14m(context)),
        TextSpan(text: '，当前价格:\$$price', style: Styles.tsBody_14m(context)),
      ],
    ));
  } else if (PushLanguageCont['FUNDINGRATESPECIAL'] == pushType) {
    return const Text('异常资金费率');
  } else if (PushLanguageCont['LIQSTA'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text:
                '最近24小时，共有 $value 人被爆仓爆仓，总金额为 $toTag，最大单笔爆仓单发生在 $ex - $symbol 金額 $to')
      ],
    ));
  } else if (PushLanguageCont['LIQSTAH1'] == pushType) {
    return Text('最近1小时，共有 ${m.value} 人被爆仓爆仓，总金额为 ${m.to}');
  } else if (PushLanguageCont['brc20Holders'] == pushType ||
      PushLanguageCont['erc20Holders'] == pushType ||
      PushLanguageCont['asc20Holders'] == pushType ||
      PushLanguageCont['arc20Holders'] == pushType) {
    final amountZh = m.amountZh, totalZh = m.totalZh;
    //let typeName = pushType.replace("Holders", "");
    final typeName = pushType?.replaceAll('Holders', '');
    if (amountZh != null && totalZh != null) {
      return Text.rich(TextSpan(children: [
        //${typeName} ${maskString(side)}
        TextSpan(text: '$typeName ${maskString(side)}'),
        TextSpan(
            text: time,
            style: TextStyle(
                color: time == '转出'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(text: from, style: Styles.tsBody_14m(context)),
        TextSpan(text: '个 $baseCoin，总价值'),
        TextSpan(text: to, style: Styles.tsBody_14m(context)),
        TextSpan(
          text: '，当前地址总数量：$amountZh，总余额：\$$totalZh',
        ),
      ]));
    } else {
      return Text.rich(TextSpan(children: [
        //${typeName} ${maskString(side)}
        TextSpan(text: '$typeName ${maskString(side)}'),
        TextSpan(
            text: time,
            style: TextStyle(
                color: time == '转出'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(text: from, style: Styles.tsBody_14m(context)),
        TextSpan(text: '个 $baseCoin，总价值'),
        TextSpan(text: to, style: Styles.tsBody_14m(context)),
      ]));
    }
  }
  //brc20Minted
  else if (PushLanguageCont['brc20Minted'] == pushType) {
    //return `${baseCoin}${interval}内铭刻${value}%，持有人数增加${amountZh},当前铸造进度:${price}%.`;
    final amountZh = m.amountZh;
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$baseCoin$interval内铭刻$value%，持有人数增加'),
      TextSpan(text: amountZh, style: Styles.tsBody_14m(context)),
      const TextSpan(text: '，当前铸造进度'),
      TextSpan(text: '$price', style: Styles.tsBody_14m(context)),
      const TextSpan(text: '%'),
    ]));
  } else {
    return TextButton(
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
        ));
  }
}

String? maskString(String? str) {
  final suffix = str?.substring(str.length - 4);
  const masked = '***';
  return masked + (suffix ?? '');
}

Widget _getRecordTextZhTw(
    PushRecordModel m, BuildContext context, String locale) {
  final type = m.type;
  final pushType = m.pushType;
  final exName = m.exchange;
  final ex = m.exchange ?? exName;
  final baseCoin = m.baseCoin;
  final value = m.value;
  final price = m.price;
  final interval = m.interval;
  final fromTag = m.fromTag;
  final to = m.to;
  final symbol = m.symbol;
  final side = m.side;
  final openInterest = m.value;
  final from = m.from;
  final toTag = m.toTag;
  final time = m.time;

  if (PushLanguageCont['PRICE_UP'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '$ex $baseCoin-Perpetual 现已',
      ),
      TextSpan(text: '突破', style: TextStyle(color: Styles.cUp(context))),
      TextSpan(
        text: ' \$$value,目前即時價格',
      ),
      TextSpan(text: ' \$$price', style: TextStyle(color: Styles.cUp(context))),
    ]));
  } else if (PushLanguageCont['PRICE_DOWN'] == pushType || 'down' == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '$ex $baseCoin-Perpetual 現已',
      ),
      TextSpan(text: '跌破', style: TextStyle(color: Styles.cDown(context))),
      TextSpan(
        text: ' \$$value,目前即時價格',
      ),
      TextSpan(
          text: ' \$$price', style: TextStyle(color: Styles.cDown(context))),
    ]));
  } else if (PushLanguageCont['PRICE_WAVE'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '$ex $baseCoin-Perpetual 在五分鐘內劇烈波動超過',
      ),
      TextSpan(
          text: ' $value%',
          style: TextStyle(
              color: (value ?? 0) < 0
                  ? Styles.cDown(context)
                  : Styles.cUp(context))),
      TextSpan(text: '，目前即時價格 \$$price'),
    ]));
  } else if (PushLanguageCont['FUNDINGRATE'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $symbol 資金費率$to '),
      TextSpan(
          text: '$value',
          style: TextStyle(
              color: from == 'fall to'
                  ? Styles.cDown(context)
                  : Styles.cUp(context))),
      const TextSpan(text: '，請密切注意市場'),
    ]));
  } else if (PushLanguageCont['lsAlert'] == type) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin 多空比$to '),
      TextSpan(
          text: '$value',
          style: TextStyle(
              color: from == 'up to'
                  ? Styles.cUp(context)
                  : Styles.cDown(context))),
      const TextSpan(text: '，請密切注意市場'),
    ]));
  } else if (PushLanguageCont['TRANSACTION'] == pushType) {
    final value = m.value;
    final from = m.from;
    var fromTag = m.fromTag;
    var toTag = m.toTag;
    final baseCoin = m.baseCoin;
    if ('unknown' == fromTag) {
      fromTag = '未知';
    }
    if ('unknown' == toTag) {
      toTag = '未知';
    }

    return Text.rich(TextSpan(children: [
      TextSpan(text: '$value 個 $baseCoin,總價值為'),
      TextSpan(text: ' $from', style: Styles.tsBody_14m(context)),
      TextSpan(text: ', 從 $fromTag 錢包轉入 $toTag 錢包'),
    ]));
  } else if (PushLanguageCont['LIQUIDATION'] == pushType) {
    final amount = m.value;

    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$ex $symbol 發生一筆大額【'),
        TextSpan(
            text: to,
            style: TextStyle(
                color: side == 'short'
                    ? Styles.cUp(context)
                    : Styles.cDown(context))),
        TextSpan(
            text:
                '】爆倉，爆倉總金額 【${AppUtil.getLargeFormatString(amount)}，爆倉價格 【$price】')
      ],
    ));
  } else if (PushLanguageCont['ANNOUNCEMENT'] == pushType) {
    final child = Text('${m.title}', style: Styles.tsBody_14m(context));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      child,
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(
            onPressed: () => launchUrl(Uri.parse(m.url ?? ''),
                mode: LaunchMode.externalApplication),
            child: Text(S.of(context).detail))
      ])
    ]);
  } else if (PushLanguageCont['FUNDINGRATETOP'] == pushType ||
      PushLanguageCont['FUNDINGRATELAST'] == pushType) {
    final isTop = pushType == PushLanguageCont['FUNDINGRATETOP'];
    return Text(
        '${isTop ? '資金費率Top3' : '資金費率Last3'}\n${isTop ? m.from?.substring(0, m.from!.length - 1) : m.to?.substring(0, m.to!.length - 1)}');
  } else if (PushLanguageCont['signal'] == pushType) {
    return Text('$baseCoin 盤口出現異動，目前價格為： \$$price 請密切注意市場');
  } else if (PushLanguageCont['openSignal'] == pushType) {
    return Text('$baseCoin 持仓出現異動，目前持仓為$openInterest ,目前價格為： \$$price 請密切注意市場');
  } else if (PushLanguageCont['warnSignal'] == pushType) {
    var baseCoin = m.baseCoin;

    if (baseCoin == 'ST') {
      baseCoin = '買賣趨勢';
    } else if (baseCoin == 'orderFlow') {
      baseCoin = '訂單流';
    }

    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$symbol', style: Styles.tsBody_14m(context)),
        TextSpan(text: '交易對 $to 等級 $baseCoin 出現 '),
        TextSpan(text: from, style: Styles.tsBody_14m(context)),
        const TextSpan(text: ' 訊號 ，請密切注意市場')
      ],
    ));
  } else if (PushLanguageCont['BIGORDER'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$ex $symbol'),
        TextSpan(text: '委託價格：\$$price，委託金額：$toTag，成交金額：$from，成交比例：$fromTag%'),
      ],
    ));
  } else if (PushLanguageCont['ORDERFLOWUNBALANCE'] == pushType) {
    return Text.rich(TextSpan(
      children: [TextSpan(text: '$ex $symbol $interval 出現買賣失衡提醒，請密切注意市場')],
    ));
  } else if (PushLanguageCont['MARKETSIGNAL'] == pushType) {
    return Text.rich(TextSpan(
      children: [TextSpan(text: '$ex $symbol 出現CVD異動訊號，請密切注意市場')],
    ));
  } else if (PushLanguageCont['ORDERFLOWPINBAR'] == pushType) {
    return Text.rich(TextSpan(
      children: [TextSpan(text: '$ex $symbol $interval 出現訂單流見頂訊號，請密切注意市場')],
    ));
  } else if (PushLanguageCont['oiAlert'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text: '$baseCoin $interval 內部持股波動',
            style: Styles.tsBody_14m(context)),
        TextSpan(
            text: '$value%',
            style: TextStyle(
                color: (value ?? 0) < 0
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: '，變動：', style: Styles.tsBody_14m(context)),
        TextSpan(
            text: '$fromTag',
            style: TextStyle(
                color: (fromTag?.indexOf('-') ?? -1) > -1
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: '目前持倉：$to'),
      ],
    ));
  } else if (PushLanguageCont['oiAlertAcc'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$baseCoin 在$time 內變動'),
        TextSpan(
            text: '$toTag',
            style: TextStyle(
                color: (toTag?.indexOf('-') ?? -1) > -1
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: '目前持股：$to', style: Styles.tsBody_14m(context)),
        TextSpan(text: '，當前價格:\$$price', style: Styles.tsBody_14m(context)),
      ],
    ));
  } else if (PushLanguageCont['FUNDINGRATESPECIAL'] == pushType) {
    return const Text('異常資金費率');
  } else if (PushLanguageCont['LIQSTA'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text:
                '最近24小時，總共有 $value 人被爆倉 ，爆倉總金額為 $toTag，最大單筆爆倉單發生在 $ex - $symbol 金額 $to')
      ],
    ));
  } else if (PushLanguageCont['LIQSTAH1'] == pushType) {
    return Text('最近1小時，共有 ${m.value} 人被爆倉 ，爆倉總金額為 ${m.to}');
  } else if (PushLanguageCont['brc20Holders'] == pushType ||
      PushLanguageCont['erc20Holders'] == pushType ||
      PushLanguageCont['asc20Holders'] == pushType ||
      PushLanguageCont['arc20Holders'] == pushType) {
    final amountZh = m.amountZh, totalZh = m.totalZh;
    //let typeName = pushType.replace("Holders", "");
    final typeName = pushType?.replaceAll('Holders', '');
    if (amountZh != null && totalZh != null) {
      return Text.rich(TextSpan(children: [
        //${typeName} ${maskString(side)}
        TextSpan(text: '$typeName ${maskString(side)}'),
        TextSpan(
            text: time,
            style: TextStyle(
                color: time == '轉出'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(text: from, style: Styles.tsBody_14m(context)),
        TextSpan(text: '個 $baseCoin，總價值'),
        TextSpan(text: to, style: Styles.tsBody_14m(context)),
        TextSpan(
          text: '，當前地址縂數量：$amountZh，縂餘額：\$$totalZh',
        ),
      ]));
    } else {
      return Text.rich(TextSpan(children: [
        //${typeName} ${maskString(side)}
        TextSpan(text: '$typeName ${maskString(side)}'),
        TextSpan(
            text: time,
            style: TextStyle(
                color: time == '轉出'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(text: from, style: Styles.tsBody_14m(context)),
        TextSpan(text: '個 $baseCoin，總價值'),
        TextSpan(text: to, style: Styles.tsBody_14m(context)),
      ]));
    }
  }
  //brc20Minted
  else if (PushLanguageCont['brc20Minted'] == pushType) {
    final amountZh = m.amountZh;
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$baseCoin$interval内铭刻$value%，持有人数增加'),
      TextSpan(text: amountZh, style: Styles.tsBody_14m(context)),
      const TextSpan(text: '，当前铸造进度'),
      TextSpan(text: '$price', style: Styles.tsBody_14m(context)),
      const TextSpan(text: '%'),
    ]));
  } else {
    return TextButton(
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
        ));
  }
}

Widget _getRecordTextEn(
    PushRecordModel m, BuildContext context, String locale) {
  final type = m.type;
  final pushType = m.pushType;
  final exName = m.exchange;
  final ex = m.exchange ?? exName;
  final baseCoin = m.baseCoin;
  final value = m.value;
  final price = m.price;
  final interval = m.interval;
  final fromTag = m.fromTag;
  final to = m.to;
  final symbol = m.symbol;
  final side = m.side;
  final openInterest = m.value;
  final from = m.from;
  final toTag = m.toTag;

  if (PushLanguageCont['PRICE_UP'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin-Perpetual is now '),
      TextSpan(text: 'upward', style: TextStyle(color: Styles.cUp(context))),
      TextSpan(text: ' \$$value USDT, currently at'),
      TextSpan(text: ' \$$price', style: TextStyle(color: Styles.cUp(context))),
    ]));
  } else if (PushLanguageCont['PRICE_DOWN'] == pushType || 'down' == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin-Perpetual is now '),
      TextSpan(text: 'below', style: TextStyle(color: Styles.cDown(context))),
      TextSpan(text: ' \$$value USDT, currently at'),
      TextSpan(
          text: ' \$$price', style: TextStyle(color: Styles.cDown(context))),
    ]));
  } else if (PushLanguageCont['PRICE_WAVE'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: '$ex $baseCoin-Perpetual The current price  fluctuates by more  ',
      ),
      TextSpan(
          text: '$value% ',
          style: TextStyle(
              color: (value ?? 0) < 0
                  ? Styles.cDown(context)
                  : Styles.cUp(context))),
      TextSpan(text: 'within 5m, and the current price: \$$price'),
    ]));
  } else if (PushLanguageCont['FUNDINGRATE'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $symbol funding rate $from '),
      TextSpan(
          text: '$value',
          style: TextStyle(
              color: from == 'fall to'
                  ? Styles.cDown(context)
                  : Styles.cUp(context))),
      const TextSpan(text: ', Please pay close attention to the market'),
    ]));
  } else if (PushLanguageCont['lsAlert'] == type) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$ex $baseCoin long short ratio $from '),
      TextSpan(
          text: '$value',
          style: TextStyle(
              color: from == 'up to'
                  ? Styles.cUp(context)
                  : Styles.cDown(context))),
      const TextSpan(text: ', Please pay close attention to the market'),
    ]));
  } else if (PushLanguageCont['TRANSACTION'] == pushType) {
    return Text.rich(TextSpan(children: [
      TextSpan(text: '$value $baseCoin with a total of'),
      TextSpan(text: ' $to', style: Styles.tsBody_14m(context)),
      TextSpan(text: ' transferred from $to wallet to $toTag wallet'),
    ]));
  } else if (PushLanguageCont['LIQUIDATION'] == pushType) {
    final amount = m.value;

    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$ex $symbol experienced a large【'),
        TextSpan(
            text: side,
            style: TextStyle(
                color: side == 'short'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(
            text:
                '】Liquidation, order TradeTurnover is 【${AppUtil.getLargeFormatString(amount)} , order price【$price】')
      ],
    ));
  } else if (PushLanguageCont['ANNOUNCEMENT'] == pushType) {
    final child =
        Text('【${m.exchange}】${m.title}', style: Styles.tsBody_14m(context));
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      child,
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        TextButton(
            onPressed: () => launchUrl(Uri.parse(m.url ?? ''),
                mode: LaunchMode.externalApplication),
            child: Text(S.of(context).detail))
      ])
    ]);
  } else if (PushLanguageCont['FUNDINGRATETOP'] == pushType ||
      PushLanguageCont['FUNDINGRATELAST'] == pushType) {
    final isTop = pushType == PushLanguageCont['FUNDINGRATETOP'];
    return Text(
        '${isTop ? 'FundingRate Top3' : 'FundingRate Last3'}\n${isTop ? m.from?.substring(0, m.from!.length - 1) : m.to?.substring(0, m.to!.length - 1)}');
  } else if (PushLanguageCont['signal'] == pushType) {
    return Text(
        '$baseCoin Market Huge Waves . the current price is: \$$price Please pay close attention to the market');
  } else if (PushLanguageCont['openSignal'] == pushType) {
    return Text(
        '$baseCoin OI Huge Waves. the current OI is $openInterest the current price is: \$$price Please pay close attention to the market');
  } else if (PushLanguageCont['warnSignal'] == pushType) {
    var baseCoin = m.baseCoin;

    if (baseCoin == 'ST') {
      baseCoin = 'Super Trend';
    } else if (baseCoin == 'orderFlow') {
      baseCoin = 'OrderFlow';
    }

    return Text.rich(TextSpan(
      children: [
        const TextSpan(text: 'A'),
        TextSpan(text: ' $fromTag cross ', style: Styles.tsBody_14m(context)),
        const TextSpan(text: 'signal appears at the '),
        TextSpan(text: '$symbol ', style: Styles.tsBody_14m(context)),
        TextSpan(text: '$to level'),
        const TextSpan(text: '; Please pay close attention to the market`;')
      ],
    ));
  } else if (PushLanguageCont['BIGORDER'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$ex $symbol'),
        TextSpan(
            text:
                ',order price：\$$price，order amount：$toTag，filled amount：$from，filled proportion：$fromTag%'),
      ],
    ));
  } else if (PushLanguageCont['ORDERFLOWUNBALANCE'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text:
                '$ex $symbol $interval has experienced a buy-sell imbalance signal,Please pay close attention to the market')
      ],
    ));
  } else if (PushLanguageCont['MARKETSIGNAL'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text:
                '$ex $symbol has experienced a CVD signal,Please pay close attention to the market')
      ],
    ));
  } else if (PushLanguageCont['ORDERFLOWPINBAR'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text:
                '$ex $symbol $interval has experienced a order flow signal,Please pay close attention to the market')
      ],
    ));
  } else if (PushLanguageCont['oiAlert'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text: '$baseCoin $interval OI Huge Waves .Chg:',
            style: Styles.tsBody_14m(context)),
        TextSpan(
            text: '$toTag',
            style: TextStyle(
                color: (fromTag?.indexOf('-') ?? -1) > -1
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(text: 'the current OI: $from'),
      ],
    ));
  } else if (PushLanguageCont['oiAlertAcc'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(text: '$baseCoin OI accumulated to '),
        TextSpan(
            text: '$fromTag ',
            style: TextStyle(
                color: (toTag?.indexOf('-') ?? -1) > -1
                    ? Styles.cDown(context)
                    : Styles.cUp(context),
                fontWeight: Styles.fontMedium)),
        TextSpan(
            text:
                'within $side, current OI are $from, and the current price is $price'),
      ],
    ));
  } else if (PushLanguageCont['FUNDINGRATESPECIAL'] == pushType) {
    return Text(m.to ?? 'null');
  } else if (PushLanguageCont['LIQSTA'] == pushType) {
    return Text.rich(TextSpan(
      children: [
        TextSpan(
            text:
                'In the past 24 hours , traders were liquidated , the total liquidations comes in at $from, The largest single liquidation order happened on $ex - $symbol value $from')
      ],
    ));
  } else if (PushLanguageCont['LIQSTAH1'] == pushType) {
    return Text(
        'In the past 1 hours , $value traders were liquidated , the total liquidations comes in at $fromTag');
  } else if (PushLanguageCont['brc20Holders'] == pushType ||
      PushLanguageCont['erc20Holders'] == pushType ||
      PushLanguageCont['asc20Holders'] == pushType ||
      PushLanguageCont['arc20Holders'] == pushType) {
    final amountEn = m.amountEn;
    final totalEn = m.totalEn;
    //let typeName = pushType.replace("Holders", "");
    final typeName = pushType?.replaceAll('Holders', '');
    if (amountEn != null && totalEn != null) {
      return Text.rich(TextSpan(children: [
        //${typeName} ${maskString(side)}
        TextSpan(text: '$typeName'),
        TextSpan(text: '$fromTag', style: Styles.tsBody_14m(context)),
        TextSpan(text: '$baseCoin were '),
        TextSpan(
            text: ex,
            style: TextStyle(
                color: side == 'transferred to'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(text: '${AppUtil.getLargeFormatString(side)}, total value '),
        TextSpan(text: '\$$toTag}', style: Styles.tsBody_14m(context)),
        TextSpan(
            text:
                ', total holding of current address: $amountEn, total balance: \$$totalEn'),
      ]));
    } else {
      return Text.rich(TextSpan(children: [
        //${typeName} ${maskString(side)}
        TextSpan(text: '$typeName'),
        TextSpan(text: '$fromTag', style: Styles.tsBody_14m(context)),
        TextSpan(text: '$baseCoin were '),
        TextSpan(
            text: ex,
            style: TextStyle(
                color: side == 'transferred to'
                    ? Styles.cDown(context)
                    : Styles.cUp(context))),
        TextSpan(text: '${AppUtil.getLargeFormatString(side)}, total value '),
        TextSpan(text: '\$$toTag}', style: Styles.tsBody_14m(context)),
      ]));
    }
  }
  //brc20Minted
  else if (PushLanguageCont['brc20Minted'] == pushType) {
    return Text(
        '$baseCoin has minted over $value% within $interval, added ${m.amountZh} new holding addresses. Current minting progress: $price%.');
  } else {
    return TextButton(
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
        ));
  }
}
