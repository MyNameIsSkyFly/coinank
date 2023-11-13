import 'package:ank_app/util/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/export.dart';
import 'setting_logic.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final logic = Get.put(SettingLogic());
  final state = Get.find<SettingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Text('黑白主题切换'),
              onTap: () {},
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('英文切换'),
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(SP.keyLocale, 'en');
                StoreLogic.to.setLocale('en');
                print(1);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('中文切换'),
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString(SP.keyLocale, 'zh');
                StoreLogic.to.setLocale('zh');
                print(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
