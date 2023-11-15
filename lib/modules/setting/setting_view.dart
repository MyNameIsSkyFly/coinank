import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/app_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_logic.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);

  final logic = Get.put(SettingLogic());
  final state = Get.find<SettingLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTitleBar(title: '设置'),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              child: Text(
                '暗主题',
              ),
              onTap: () {
                AppUtil.changeTheme(true);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text(
                '亮主题',
              ),
              onTap: () {
                AppUtil.changeTheme(false);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text('系统主题'),
              onTap: () {
                AppUtil.changeTheme(null);
              },
            ),
            const SizedBox(height: 20),
            InkWell(
              child: Text(
                '切换上涨颜色',
              ),
              onTap: () {
                AppUtil.toggleUpColor();
              },
            ),
            Text(
              '上涨颜色',
              style: TextStyle(color: Styles.cUp(context)),
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
