import 'package:ank_app/util/app_util.dart';
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
                AppUtil.changeLocale(const Locale('en'));
                print(1);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('中文简体切换'),
              onTap: () async {
                AppUtil.changeLocale(const Locale.fromSubtags(
                    languageCode: 'zh', scriptCode: 'Hans'));
                print(1);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('中文繁体切换'),
              onTap: () async {
                AppUtil.changeLocale(const Locale.fromSubtags(
                    languageCode: 'zh', scriptCode: 'Hant'));
                print(1);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('日文切换'),
              onTap: () async {
                AppUtil.changeLocale(
                    const Locale.fromSubtags(languageCode: 'ja'));
                print(1);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('韩文切换'),
              onTap: () async {
                AppUtil.changeLocale(
                    const Locale.fromSubtags(languageCode: 'ko'));
                print(1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
