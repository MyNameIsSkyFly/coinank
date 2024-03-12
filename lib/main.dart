import 'dart:io';

import 'package:ank_app/config/application.dart';
import 'package:ank_app/res/app_theme.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/jpush_util.dart';
import 'package:ank_app/util/store_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

Future<void> main() async {
  /// 确保初始化完成
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 2000))
      .then((value) => FlutterNativeSplash.remove());

  /// getx初始化
  StoreBinding().dependencies();
  await Application.instance.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CoinAnk',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (StoreLogic.to.locale != null) {
          return StoreLogic.to.locale;
        }
        Locale local;
        if (locale?.scriptCode == 'Hant') {
          local =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
        } else if (locale?.scriptCode == 'Hans') {
          local =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
        } else if (locale?.languageCode == 'ja') {
          local = const Locale('ja');
        } else if (locale?.languageCode == 'ko') {
          local = const Locale('ko');
        } else {
          local = const Locale('en');
        }
        if (StoreLogic.to.locale == null) {
          StoreLogic.to.saveLocale(local);
        }
        return local;
      },
      defaultTransition: Transition.cupertino,
      locale: StoreLogic.to.locale,
      initialRoute: RouteConfig.main,
      getPages: RouteConfig.getPages,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: StoreLogic.to.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: child!,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    JPushUtil().initPlatformState();
    FGBGEvents.stream.listen((event) async {
      if (event == FGBGType.foreground) {
        bool isSupported = await FlutterAppBadger.isAppBadgeSupported();
        if (isSupported) {
          if (Platform.isAndroid) {
            FlutterAppBadger.removeBadge();
          } else {
            FlutterAppBadger.updateBadgeCount(-1);
          }
        }
      }
    });
  }
}
