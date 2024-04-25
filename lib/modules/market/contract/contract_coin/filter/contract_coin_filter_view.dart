import 'package:ank_app/modules/market/utils/text_maps.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContractCoinFilterPage extends StatefulWidget {
  const ContractCoinFilterPage(
      {super.key, this.isSpot = false, this.isCategory = false});

  final bool isSpot;
  final bool isCategory;

  @override
  State<ContractCoinFilterPage> createState() => _ContractCoinFilterPageState();
}

class _ContractCoinFilterPageState extends State<ContractCoinFilterPage>
    with _Data {
  var selectedFilterKeys = <String>{};

  //form key
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.isSpot) {
      filterKeys.clear();
      filterKeys.addAll({
        'price': null,
        'priceChangeH24': null,
        'priceChangeH1': null,
        'turnover24h': null,
        'marketCap': null,
        'circulatingSupply': null
      });
    }
    filterKeys.addAll((widget.isSpot
            ? (widget.isCategory
                ? StoreLogic().spotCoinFilterCategory
                : StoreLogic().spotCoinFilter)
            : (widget.isCategory
                ? StoreLogic().contractCoinFilterCategory
                : StoreLogic().contractCoinFilter)) ??
        {});
    filterKeys.forEach((key, value) {
      if (value == null) return;
      final valueList = value.split('~');
      filterKeyCache[key]?.ctrl1.text = '${num.tryParse(valueList[0]) ?? ''}';
      filterKeyCache[key]?.ctrl2.text = '${num.tryParse(valueList[1]) ?? ''}';
    });
    super.initState();
  }

  @override
  void dispose() {
    filterKeyCache.forEach((key, value) {
      value.ctrl1.dispose();
      value.ctrl2.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sof = S.of(context);
    return Container(
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          44,
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Styles.cScaffoldBackground(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Gap(15),
              Expanded(
                child: Text(
                  S.of(context).filter,
                  style: Styles.tsBody_16(context),
                ),
              ),
              //close button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Icon(
                    Icons.close,
                    color: Styles.cBody(context),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [...filterKeys.keys.map((e) => _item(e))],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom,
                top: 10,
                left: 15,
                right: 15),
            decoration: BoxDecoration(
              color: Styles.cScaffoldBackground(context),
              boxShadow: [
                BoxShadow(
                  color: Styles.cBody(context).withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Styles.cLine(context)),
                        onPressed: () {
                          setState(() {
                            filterKeyCache.forEach((key, value) {
                              value.ctrl1.clear();
                              value.ctrl2.clear();
                            });
                          });
                        },
                        child: Text(
                          sof.s_reset,
                          style: Styles.tsBody_16(context),
                        ))),
                const Gap(10),
                Expanded(
                  child: FilledButton(
                      onPressed: () {
                        filterKeyCache.forEach((key, value) {
                          filterKeys[key] = value.convertedValue;
                        });
                        if (widget.isSpot) {
                          if (widget.isCategory) {
                            StoreLogic().saveSpotCoinFilterCategory(filterKeys
                              ..removeWhere((key, value) => value == null));
                          } else {
                            StoreLogic().saveSpotCoinFilter(filterKeys
                              ..removeWhere((key, value) => value == null));
                          }
                        } else {
                          if (widget.isCategory) {
                            StoreLogic().saveContractCoinFilterCategory(
                                filterKeys
                                  ..removeWhere((key, value) => value == null));
                          } else {
                            StoreLogic().saveContractCoinFilter(filterKeys
                              ..removeWhere((key, value) => value == null));
                          }
                        }
                        Get.back(result: true);
                      },
                      child: Text(sof.s_ok,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _item(String filterKey) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedFilterKeys.contains(filterKey)) {
            selectedFilterKeys.remove(filterKey);
          } else {
            selectedFilterKeys.add(filterKey);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
        decoration: BoxDecoration(
            color: Styles.cScaffoldBackground(context),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Styles.cBody(context).withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 46,
              child: Row(
                children: [
                  Expanded(child: Text(MarketMaps.contractTextMap(filterKey))),
                  Text(filterKeyCache[filterKey]?.convertedValue ?? '',
                      style: Styles.tsMain_12.medium),
                  const Gap(10),
                  const Icon(CupertinoIcons.right_chevron, size: 10),
                ],
              ),
            ),
            AnimatedCrossFade(
                firstCurve: Curves.easeOutBack,
                secondCurve: Curves.easeOutBack,
                firstChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _textField(
                          filterKeyCache[filterKey]?.ctrl1,
                          isPercent: percentKeys.contains(filterKey),
                          validator: filterValidators(filterKey),
                          hint: _filterHintMap[filterKey]?.$1,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(top: 13),
                          child: const Text('To'),
                        ),
                        Expanded(
                          child: _textField(
                            filterKeyCache[filterKey]?.ctrl2,
                            isPercent: percentKeys.contains(filterKey),
                            validator: filterValidators(filterKey),
                            hint: _filterHintMap[filterKey]?.$2,
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: (filterSampleData(filterKey)?.entries ?? [])
                          .map((e) => _text(e.value,
                                  selected: e.key ==
                                      filterKeyCache[filterKey]?.convertedValue,
                                  onTap: () {
                                setState(() {
                                  final valueList = e.key.split('~');
                                  filterKeyCache[filterKey]?.ctrl1.text =
                                      valueList[0];
                                  filterKeyCache[filterKey]?.ctrl2.text =
                                      valueList[1];
                                });
                              }))
                          .toList(),
                    ),
                    const Gap(10),
                  ],
                ),
                secondChild: Container(
                  height: 0,
                  color: Colors.red,
                ),
                crossFadeState: selectedFilterKeys.contains(filterKey)
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200)),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController? controller,
      {bool isPercent = false, _FilterValidator? validator, String? hint}) {
    var boxConstraints = const BoxConstraints.tightFor(width: 30, height: 20);
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value?.isEmpty ?? true) return null;
        final n = num.tryParse(value ?? '');
        if (n == null) return 'Error';
        return validator?.call(n.toDouble());
      },
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))
      ],
      style: Styles.tsBody_14(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Styles.tsSub_14(context),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: isPercent
            ? null
            : Center(child: Text('\$', style: Styles.tsBody_14(context))),
        prefixIconConstraints: isPercent ? null : boxConstraints,
        suffixIcon: isPercent
            ? Center(child: Text('%', style: Styles.tsBody_14(context)))
            : null,
        suffixIconConstraints: isPercent ? boxConstraints : null,
        filled: true,
      ),
    );
  }

  Widget _text(String text, {VoidCallback? onTap, bool selected = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: selected ? Styles.cMain : Styles.cLine(context)),
        ),
        child: Text(
          text,
          style: Styles.tsBody_12(context)
              .copyWith(color: selected ? Styles.cMain : null),
        ),
      ),
    );
  }
}

typedef _FilterValidator = String? Function(double value);
mixin _Data {
  final filterKeys = <String, String?>{
    'price': null,
    'priceChangeH24': null,
    'priceChangeH1': null,
    'openInterest': null,
    'openInterestCh1': null,
    'openInterestCh4': null,
    'openInterestCh24': null,
    'longShortRatio': null,
    'longShortPerson': null,
    'longShortAccount': null,
    'longShortPosition': null,
    'fundingRate': null,
    'turnover24h': null,
    'liquidationH24': null,
    'liquidationH4': null,
    'liquidationH1': null,
    'marketCap': null,
    'circulatingSupply': null
  };
  final filterKeyCache = {
    'price': _CacheValue(),
    'priceChangeH24': _CacheValue(),
    'priceChangeH1': _CacheValue(),
    'openInterest': _CacheValue(),
    'openInterestCh1': _CacheValue(),
    'openInterestCh4': _CacheValue(),
    'openInterestCh24': _CacheValue(),
    'longShortRatio': _CacheValue(),
    'longShortPerson': _CacheValue(),
    'longShortAccount': _CacheValue(),
    'longShortPosition': _CacheValue(),
    'fundingRate': _CacheValue(),
    'turnover24h': _CacheValue(),
    'liquidationH24': _CacheValue(),
    'liquidationH4': _CacheValue(),
    'liquidationH1': _CacheValue(),
    'marketCap': _CacheValue(),
    'circulatingSupply': _CacheValue(),
  };
  final percentKeys = [
    'priceChangeH1',
    'priceChangeH24',
    'openInterestCh1',
    'openInterestCh4',
    'openInterestCh24',
    'longShortRatio',
    'longShortPerson',
    'longShortAccount',
    'longShortPosition',
    'fundingRate',
    'liquidationH24',
    'liquidationH4',
    'liquidationH1'
  ];

  _FilterValidator _range(int min, int max) => (value) {
        if (min > max) return S.current.errorInputRange;
        if (value < min) return S.current.errorInputLessThanX(min);
        if (value > max) return S.current.errorInputMoreThanX(max);
        return null;
      };

  _FilterValidator? filterValidators(String key) => switch (key) {
        'price' => _range(0, 1000000),
        'priceChangeH24' || 'priceChangeH1' => _range(-100, 10000),
        'openInterest' => _range(-100, 100000000000),
        'openInterestCh1' ||
        'openInterestCh4' ||
        'openInterestCh24' =>
          _range(0, 10000000000),
        'longShortRatio' ||
        'longShortAccount' ||
        'longShortPosition' =>
          _range(0, 100),
        'longShortPerson' => null,
        'fundingRate' => _range(-50, 50),
        'turnover24h' => _range(0, 100000000000),
        'liquidationH24' ||
        'liquidationH4' ||
        'liquidationH1' =>
          _range(0, 10000000000),
        'marketCap' => _range(0, 1000000000000),
        'circulatingSupply' => _range(0, 1000000000000),
        _ => null,
      };

  final _filterHintMap = {
    'price': ('0.01', '100000'),
    'priceChangeH24': ('-100.00', '100.00'),
    'priceChangeH1': ('-100.00', '100.00'),
    'openInterest': ('1000000', '10000000'),
    'openInterestCh1': ('-100', '100'),
    'openInterestCh4': ('-100', '100'),
    'openInterestCh24': ('-100', '100'),
    'longShortRatio': ('0.1', '0.5'),
    'longShortPerson': ('0.1', '0.5'),
    'longShortAccount': ('0.1', '0.5'),
    'longShortPosition': ('0.1', '0.5'),
    'fundingRate': ('-0.001', '0.001'),
    'turnover24h': ('100000000', '1000000000'),
    'liquidationH24': ('100000000', '1000000000'),
    'liquidationH4': ('100000000', '1000000000'),
    'liquidationH1': ('100000000', '1000000000'),
    'marketCap': ('100000000', '1000000000'),
    'circulatingSupply': ('100000', '1000000000'),
  };

  String _format(double value) =>
      AppUtil.getLargeFormatString(value, precision: 0);

  Map<String, String>? filterSampleData(String key) => switch (key) {
        'priceChangeH1' ||
        'priceChangeH24' ||
        'openInterestCh1' ||
        'openInterestCh4' ||
        'openInterestCh24' =>
          {'15~': '+15%', '10~50': '+10% - +50%'},
        'longShortRatio' => {
            '0.1~0.5': '0.1 - 0.5',
            '0.5~1': '0.5 - 1',
            '1~1.5': '1 - 1.5',
            '1.5~2': '1.5 - 2'
          },
        'price' => {
            '0~1': '\$0 - \$1',
            '1~10': '\$1 - \$10',
            '10~100': '\$10 - \$100',
            '100~1000': '\$100 - \$1000',
            '1000~10000': '\$1000 - \$10000',
            '10000~': '\$10000'
          },
        'openInterest' => {
            '~1000000': '< \$${_format(1000000)}',
            '1000000~10000000':
                '\$${_format(1000000)} - \$${_format(10000000)}',
            '10000000~1000000000':
                '\$${_format(10000000)} - \$${_format(1000000000)}',
            '1000000000~': '\$${_format(1000000000)}'
          },
        'longShortPerson' || 'longShortAccount' || 'longShortPosition' => {
            '0.1~0.5': '0.1 - 0.5',
            '0.5~1': '0.5 - 1',
            '1~1.5': '1 - 1.5',
            '1.5~2': '1.5 - 2',
          },
        'fundingRate' => {
            '-0.001~0.001': '-0.001% - 0.001%',
            '0.001~': '0.001%'
          },
        'turnover24h' => {
            '~100000000': '< \$${_format(100000000)}',
            '100000000~1000000000':
                '\$${_format(100000000)} - \$${_format(1000000000)}',
            '1000000000~5000000000':
                '\$${_format(1000000000)} - \$${_format(5000000000)}',
            '5000000000~10000000000':
                '\$${_format(5000000000)} - \$${_format(10000000000)}',
            '10000000000~': '\$${_format(10000000000)}'
          },
        'liquidationH24' => {
            '~100000': '< \$${_format(100000)}',
            '100000~500000': '\$${_format(100000)} - \$${_format(500000)}',
            '500000~1000000': '\$${_format(500000)} - \$${_format(1000000)}',
            '1000000~5000000': '\$${_format(1000000)} - \$${_format(5000000)}',
            '5000000~10000000':
                '\$${_format(5000000)} - \$${_format(10000000)}',
            '10000000~50000000':
                '\$${_format(10000000)} - \$${_format(50000000)}',
            '50000000~': '> \$${_format(50000000)}',
          },
        'liquidationH4' || 'liquidationH1' => {
            '~100000': '< \$${_format(100000)}',
            '100000~500000': '\$${_format(100000)} - \$${_format(500000)}',
            '500000~1000000': '\$${_format(500000)} - \$${_format(1000000)}',
            '1000000~5000000': '\$${_format(1000000)} - \$${_format(5000000)}',
          },
        'circulatingSupply' => {
            '~100000': '< \$${_format(100000)}',
            '100000~1000000': '\$${_format(100000)} - \$${_format(1000000)}',
            '1000000~10000000':
                '\$${_format(1000000)} - \$${_format(10000000)}',
            '10000000~100000000':
                '\$${_format(10000000)} - \$${_format(100000000)}',
            '100000000~1000000000':
                '\$${_format(100000000)} - \$${_format(1000000000)}',
          },
        'marketCap' => {
            '~100000000': '< \$${_format(100000000)}',
            '100000000~1000000000':
                '\$${_format(100000000)} - \$${_format(1000000000)}',
            '1000000000~10000000000':
                '\$${_format(1000000000)} - \$${_format(10000000000)}',
            '10000000000~100000000000':
                '\$${_format(10000000000)} - \$${_format(100000000000)}',
            '100000000000~': '> \$${_format(100000000000)}'
          },
        _ => null,
      };
}

class _CacheValue {
  // num? value1;
  // num? value2;
  final ctrl1 = TextEditingController();
  final ctrl2 = TextEditingController();

  String? get convertedValue {
    if (ctrl1.text.isEmpty && ctrl2.text.isEmpty) return null;
    return '${ctrl1.text}~${ctrl2.text}';
  }

  _CacheValue();
}
