import 'dart:async';

import 'package:ank_app/entity/event/event_filter_changed.dart';
import 'package:ank_app/modules/market/spot/customize/reorder_spot_view.dart';
import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../customize/reorder_view.dart';
import '../filter/contract_coin_filter_view.dart';

class CustomizeFilterHeaderView extends StatefulWidget {
  const CustomizeFilterHeaderView(
      {super.key,
      this.onFinishFilter,
      this.isSpot = false,
      this.isCategory = false});

  final bool isSpot;
  final bool isCategory;
  final VoidCallback? onFinishFilter;

  @override
  State<CustomizeFilterHeaderView> createState() =>
      _CustomizeFilterHeaderViewState();
}

class _CustomizeFilterHeaderViewState extends State<CustomizeFilterHeaderView> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = AppConst.eventBus.on<EventFilterChanged>().listen((event) {
      if (event.isSpot != widget.isSpot ||
          event.isCategory != widget.isCategory) return;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Color? get _filterColor {
    if (widget.isSpot) {
      if (widget.isCategory) {
        if (StoreLogic().spotCoinFilterCategory == null) {
          return null;
        } else {
          return Styles.cMain;
        }
      } else {
        if (StoreLogic().spotCoinFilter == null) {
          return null;
        } else {
          return Styles.cMain;
        }
      }
    } else {
      if (widget.isCategory) {
        if (StoreLogic().contractCoinFilterCategory == null) {
          return null;
        } else {
          return Styles.cMain;
        }
      } else {
        if (StoreLogic().contractCoinFilter == null) {
          return null;
        } else {
          return Styles.cMain;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Styles.cLine(context)))),
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Get.toNamed(
                  widget.isSpot
                      ? ReorderSpotPage.routeName
                      : ReorderPage.routeName,
                  arguments: {'isCategory': widget.isCategory}),
              child: Row(
                children: [
                  Image.asset(
                    Assets.commonIcPuzzlePiece,
                    width: 12,
                    height: 12,
                    color: Styles.cBody(context),
                  ),
                  const Gap(4),
                  Expanded(
                    child: Text(
                      S.of(context).customizeList,
                      style: Styles.tsBody_12(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  ContractCoinFilterPage(
                      isSpot: widget.isSpot, isCategory: widget.isCategory),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  ignoreSafeArea: false,
                ).then((value) {
                  if (value == true) widget.onFinishFilter?.call();
                  AppConst.eventBus.fire(EventFilterChanged(
                      isCategory: widget.isCategory, isSpot: widget.isSpot));
                });
              },
              child: ImageIcon(
                const AssetImage(Assets.commonIcFilter),
                size: 20,
                color: _filterColor,
              ))
        ],
      ),
    );
  }
}
