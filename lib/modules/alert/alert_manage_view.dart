import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'alert_configs_view.dart';
import 'alert_manage_logic.dart';

class AlertManagePage extends StatefulWidget {
  const AlertManagePage({super.key});

  static const String routeName = '/alertManage';

  @override
  State<AlertManagePage> createState() => _AlertManagePageState();
}

class _AlertManagePageState extends State<AlertManagePage> {
  final logic = Get.put(AlertManageLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).alert),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: logic.alertConfigs.length,
          itemBuilder: (context, index) {
            final item = logic.alertConfigs[index];
            return GestureDetector(
              onTap: () => Get.to(() => AlertConfigsView(type: item.type),
                  curve: Easing.linear),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                margin: const EdgeInsets.symmetric(horizontal: 15)
                    .copyWith(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).cardColor,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x19000000),
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      )
                    ]),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(logic.getTitle(item.type),
                            style: Styles.tsBody_14(context))),
                    const Icon(Icons.chevron_right, size: 18)
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
