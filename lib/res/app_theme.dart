import 'dart:io';

import 'package:ank_app/res/styles.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  static ThemeData get lightTheme => baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles.cMain,
          brightness: Brightness.light,
          onBackground: Colors.black,
          tertiary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
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
          bodyMedium: TextStyle(color: Styles.cTextBlack, height: 1.4),
          bodySmall: TextStyle(color: Color(0xff616E85), height: 1.4),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFFEFF2F5),
        ),
      );

  static ThemeData get darkTheme => baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles.cMain,
          brightness: Brightness.dark,
          onBackground: Colors.white,
          tertiary: Styles.cTextBlack,
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff171823),
            scrolledUnderElevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            )),
        iconTheme: const IconThemeData(color: Colors.white),
        cardColor: const Color(0xff1F202C),
        bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff1F202C)),
        shadowColor: Colors.black12,
        dividerTheme: const DividerThemeData(
            color: Color(0xff252733), space: 1, thickness: 1),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff171823),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white, height: 1.4),
          bodySmall: TextStyle(color: Color(0xffA1A7BB), height: 1.4),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color(0xFF323546),
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
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          modalBackgroundColor: Colors.transparent,
        ),
      );
}

class StockColors extends ThemeExtension<StockColors> {
  static const upGreen = StockColors(
    up: Color(0xff5CC389),
    down: Color(0xffD8494A),
  );
  static const upRed = StockColors(
    up: Color(0xffD8494A),
    down: Color(0xff5CC389),
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

///自定义颜色
class CustomColors extends ThemeExtension<CustomColors> {
  static const light = CustomColors(
    homeFilledColor: Color(0xff5CC389),
  );
  static const dark = CustomColors(
    homeFilledColor: Color(0xffD8494A),
  );

  const CustomColors({required this.homeFilledColor});

  final Color? homeFilledColor;

  @override
  CustomColors copyWith({
    Color? homeFilledColor,
  }) {
    return CustomColors(
      homeFilledColor: homeFilledColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      homeFilledColor: Color.lerp(homeFilledColor, other.homeFilledColor, t),
    );
  }

  @override
  String toString() => 'StatusColors(homeFilledColor: $homeFilledColor)';
}
