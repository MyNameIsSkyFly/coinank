import 'package:ank_app/res/styles.dart';
import 'package:ank_app/util/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppThemes {
  static ThemeData get lightTheme => baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles.cMain,
          brightness: Brightness.light,
          onBackground: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        )),
        cardColor: const Color(0xffF8FAFD),
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
        shadowColor: Colors.black12,
        dividerTheme: const DividerThemeData(
            color: Color(0xffEFF2F5), space: 1, thickness: 1),
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Styles.cTextBlack),
          bodySmall: TextStyle(color: Color(0xff616E85)),
        ),
      );

  static ThemeData get darkTheme => baseTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Styles.cMain,
          brightness: Brightness.dark,
          onBackground: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        )),
        cardColor: const Color(0xff1F202C),
        bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff1F202C)),
        shadowColor: Colors.black12,
        dividerTheme: const DividerThemeData(
            color: Color(0xff252733), space: 1, thickness: 1),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff171823),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Color(0xffA1A7BB)),
        ),
      );

  static ThemeData get baseTheme => ThemeData(
        useMaterial3: true,
        extensions: StoreLogic.to.isUpGreen
            ? [StockColors.upGreen]
            : [StockColors.upRed],
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
    Color? success,
    Color? info,
  }) {
    return StockColors(
      up: success ?? up,
      down: info ?? down,
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
