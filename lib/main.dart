import 'dart:io';

import 'package:ank_app/config/application.dart';
import 'package:ank_app/res/app_theme.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/jpush_util.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'entity/event/fgbg_type.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  /// 确保初始化完成
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(milliseconds: 2000))
      .then((value) => FlutterNativeSplash.remove());

  await Application.instance.init();
  Application.setSystemUiMode();
  runApp(const MyApp());
  // await Sentry.init(
  //   (options) {
  //     options.dsn =
  //         'https://a377a4731f7e4eb6b78d49fb018e1bd7@o4506811978874880.ingest.sentry.io/4506811983331328';
  //   },
  //   appRunner: () => runApp(const MyApp()), // Init your App.
  // );
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
      navigatorObservers: [AppConst.routeObserver],
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
        } else if (locale?.languageCode == 'zh') {
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
    AppConst.eventBus.on<FGBGType>().listen((event) async {
      if (event == FGBGType.foreground) {
        final isSupported = Platform.isAndroid || Platform.isIOS;
        if (isSupported) {
          if (Platform.isAndroid) {
            AppBadgePlus.updateBadge(0);
          } else {
            AppBadgePlus.updateBadge(0);
          }
        }
      }
    });
  }
}
