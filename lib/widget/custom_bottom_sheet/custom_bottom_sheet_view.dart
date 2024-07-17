import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSelector<T> extends StatefulWidget {
  const CustomSelector(
      {super.key,
      required this.title,
      required this.dataList,
      this.convertor,
      this.current});

  final String title;
  final List<T> dataList;
  final String Function(T value)? convertor;
  final T? current;

  @override
  State<CustomSelector> createState() => _CustomSelectorState<T>();
}

class _CustomSelectorState<T> extends State<CustomSelector<T>> {
  void tapCell(int index) {
    Get.back<T>(result: widget.dataList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight:
              AppConst.height - kToolbarHeight - AppConst.statusBarHeight),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              maxHeight: 62,
              minHeight: 62,
              child: Container(
                color: Theme.of(context).appBarTheme.backgroundColor,
                child: Row(
                  children: [
                    Text(
                      widget.title,
                      style: Styles.tsBody_16(context),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: Get.back,
                      icon: Text(
                        S.current.s_cancel,
                        style: Styles.tsSub_16(context),
                      ),
                      constraints: const BoxConstraints.tightFor(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((cnt, index) {
              return InkWell(
                onTap: () => tapCell(index),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                          widget.convertor?.call(widget.dataList[index]) ??
                              '${widget.dataList[index]}',
                          style: Styles.tsBody_14m(context)),
                      const Spacer(),
                      Offstage(
                        offstage: widget.dataList[index] != widget.current,
                        child: const Icon(
                          Icons.check_sharp,
                          size: 20,
                          color: Styles.cMain,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }, childCount: widget.dataList.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 15 + AppConst.bottomBarHeight),
          )
        ],
      ),
    );
  }
}
