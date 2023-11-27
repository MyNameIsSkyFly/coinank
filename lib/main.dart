import 'package:ank_app/config/application.dart';
import 'package:ank_app/modules/login/login_view.dart';
import 'package:ank_app/res/app_theme.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/store.dart';
import 'package:ank_app/util/store_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

Future<void> main() async {
  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Coinank',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if(StoreLogic.to.locale != null){
          return StoreLogic.to.locale;
        }
        Locale local;
        if (locale?.scriptCode == 'Hant') {
          local =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
        } else if (locale?.languageCode == 'en') {
          local = const Locale('en');
        } else if (locale?.languageCode == 'ja') {
          local = const Locale('ja');
        } else if (locale?.languageCode == 'ko') {
          local = const Locale('ko');
        } else {
          local =
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
        }
        if(StoreLogic.to.locale == null){
          StoreLogic.to.saveLocale(locale);
        }
        return locale;
      },
      defaultTransition: Transition.cupertino,
      locale: StoreLogic.to.locale,
      initialRoute: RouteConfig.main,
      getPages: RouteConfig.getPages,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: StoreLogic.to.isDarkMode ??
              MediaQuery.of(context).platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
