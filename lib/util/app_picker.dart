import 'package:ank_app/res/export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///单列选择器，传字符串列表，
///
///```dart
///var result = await showAppSingleListPicker(context, ['one','two','three']);
///```
Future<String?> showAppStringPicker(
  BuildContext context, {
  required List<String?> data,
  String? title,
  String? initialValue,
}) async {
  final nodes =
      data.map((e) => AppPickerNode<String>(e, customData: e)).toList();
  final result = await showCupertinoModalPopup<AppPickerNode?>(
      context: context,
      builder: (context) => AppPicker(
            nodes: nodes,
            initialValue: initialValue,
            title: title,
          ));
  return result?.data;
}

Future<T?> showAppPicker<T>(
  BuildContext context, {
  required List<AppPickerNode<T>> data,
  String? title,
  String? initialValue,
}) async {
  final result = await showCupertinoModalPopup<AppPickerNode<T>?>(
      context: context,
      builder: (context) => AppPicker(
            nodes: data,
            initialValue: initialValue,
            title: title,
          ));
  return result?.customData;
}

class AppPicker<T> extends StatelessWidget {
  const AppPicker({
    super.key,
    required this.nodes,
    this.initialValue,
    this.title,
  });

  final List<AppPickerNode<T>> nodes;
  final String? initialValue;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Gap(MediaQuery.of(context).viewPadding.top + kToolbarHeight),
      Flexible(
        child: Container(
          decoration: BoxDecoration(
            color: Styles.cScaffoldBackground(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    title ?? '',
                    style: Styles.tsBody_16(context),
                  )),
                  GestureDetector(
                      onTap: Get.back,
                      child: Text(S.of(context).s_cancel,
                          style: Styles.tsSub_16(context)))
                ],
              ),
            ),
            Flexible(
              child: Builder(builder: (context) {
                return ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewPadding.bottom),
                  shrinkWrap: true,
                  itemCount: nodes.length,
                  itemBuilder: (context, index) {
                    final item = nodes[index];
                    return ListTile(
                      title: Text(item.data ?? ''),
                      trailing: initialValue == item.data
                          ? const Icon(Icons.check, color: Styles.cMain)
                          : null,
                      onTap: () => Get.back(result: item),
                    );
                  },
                );
              }),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class AppPickerNode<T> {
  /// picker中显示的字符
  String? data;

  /// 返回数据时可能需要用到的其他数据
  T? customData;

  AppPickerNode(this.data, {this.customData});
}
