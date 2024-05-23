import 'package:ank_app/res/styles.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static ThemeData get lightTheme => baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles.cMain,
          onSurface: Colors.black,
          tertiary: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          refreshBackgroundColor: Colors.white,
          color: Styles.cMain,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Styles.cTextBlack,
            fontSize: 18,
            fontWeight: Styles.fontMedium,
            fontFamily: 'PingFang SC',
          ),
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            statusBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
        iconTheme: const IconThemeData(color: Styles.cTextBlack),
        cardColor: const Color(0xffF8FAFD),
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
        shadowColor: Colors.black12,
        dividerTheme: const DividerThemeData(
            color: Color(0xffEFF2F5), space: 1, thickness: 1),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Styles.cTextBlack, height: 1.4, fontFamily: 'PingFang SC'),
          bodyMedium: TextStyle(
              color: Styles.cTextBlack, height: 1.4, fontFamily: 'PingFang SC'),
          bodySmall: TextStyle(
              color: Color(0xff616E85), height: 1.4, fontFamily: 'PingFang SC'),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFFEFF2F5),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEFF2F5))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Styles.cMain)),
        ),
      );

  static ThemeData get darkTheme => baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles.cMain,
          brightness: Brightness.dark,
          onSurface: Colors.white,
          tertiary: Styles.cTextBlack,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          refreshBackgroundColor: Color(0xffA1A7BB),
          color: Styles.cMain,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff171823),
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Color(0xffEFF2F5),
              fontSize: 18,
              fontWeight: Styles.fontMedium,
              fontFamily: 'PingFang SC',
            ),
            scrolledUnderElevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            )),
        iconTheme: const IconThemeData(color: Color(0xffEFF2F5)),
        cardColor: const Color(0xff1F202C),
        bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff1F202C)),
        shadowColor: Colors.black12,
        dividerTheme: const DividerThemeData(
            color: Color(0xff252733), space: 1, thickness: 1),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff171823),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
              color: Color(0xffEFF2F5), height: 1.4, fontFamily: 'PingFang SC'),
          bodyMedium: TextStyle(
              color: Color(0xffEFF2F5), height: 1.4, fontFamily: 'PingFang SC'),
          bodySmall: TextStyle(
              color: Color(0xffA1A7BB), height: 1.4, fontFamily: 'PingFang SC'),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFF323546),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF252733))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Styles.cMain)),
        ),
      );

  static ThemeData get baseTheme => ThemeData(
        useMaterial3: true,
        fontFamily: 'PingFang SC',
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        extensions: StoreLogic.to.isUpGreen
            ? [StockColors.upGreen]
            : [StockColors.upRed],
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                foregroundColor: Colors.white,
                backgroundColor: Styles.cMain,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          modalBackgroundColor: Colors.transparent,
        ),
      );
}

class StockColors extends ThemeExtension<StockColors> {
  static const upGreen = StockColors(
    up: Color(0xff1DCA88),
    down: Color(0xffEF424A),
  );
  static const upRed = StockColors(
    up: Color(0xffEF424A),
    down: Color(0xff1DCA88),
  );

  const StockColors({required this.up, required this.down});

  final Color? up;
  final Color? down;

  @override
  StockColors copyWith({
    Color? up,
    Color? down,
  }) {
    return StockColors(
      up: up,
      down: down,
    );
  }

  @override
  StockColors lerp(ThemeExtension<StockColors>? other, double t) {
    if (other is! StockColors) return this;
    return StockColors(
      up: Color.lerp(up, other.up, t),
      down: Color.lerp(down, other.down, t),
    );
  }

  @override
  String toString() => 'StatusColors(up: $up, down: $down)';
}
