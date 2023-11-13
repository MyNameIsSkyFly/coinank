import 'package:ank_app/config/application.dart';
import 'package:ank_app/generated/l10n.dart';
import 'package:ank_app/res/export.dart';
import 'package:ank_app/util/store.dart';
import 'package:ank_app/util/store_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

Future<void> main() async {
  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  /// getx初始化
  StoreBinding().dependencies();
  await Application.instance.init();
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
    return GetBuilder<StoreLogic>(
        id: 'locale',
        builder: (_) {
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
              if (supportedLocales.contains(locale) == true) {
                return locale;
              } else {
                return const Locale('en');
              }
            },
            locale: StoreLogic.to.locale,
            initialRoute: RouteConfig.main,
            getPages: RouteConfig.getPages,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              scaffoldBackgroundColor: Colors.white,
              bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.transparent),
            ),
            builder: EasyLoading.init(
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: child!,
                );
              },
            ),
          );
        });
  }
}
