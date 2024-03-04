import 'package:ank_app/res/export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_customize_logic.dart';

class EditCustomizePage extends StatefulWidget {
  const EditCustomizePage({super.key});

  static const routeName = '/contractCoinEditCustomize';

  @override
  State<EditCustomizePage> createState() => _EditCustomizePageState();
}

class _EditCustomizePageState extends State<EditCustomizePage> {
  final logic = Get.put(EditCustomizeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).edit),
      ),
      body: ListView(
        children: [
          Text('价格变化'),
        ],
      ),
    );
  }
}
