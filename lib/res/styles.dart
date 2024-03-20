
import 'package:flutter/material.dart';

import 'app_theme.dart';

class Styles {
  Styles._();

  static const cMain = Color(0xFF4363F2);
  static const cTextBlack = Color(0xFF0E1420);
  static const cYellow = Color(0xFFFEB76E);

  static Color cUp(BuildContext context) =>
      Theme.of(context).extension<StockColors>()!.up!;

  static Color cDown(BuildContext context) =>
      Theme.of(context).extension<StockColors>()!.down!;

  static Color cBody(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.color!;

  static Color cSub(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.color!;

  static Color cLine(BuildContext context) =>
      Theme.of(context).dividerTheme.color!;

  static Color cScaffoldBackground(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static const fontMedium = FontWeight.w600;

  // Platform.isAndroid ? FontWeight.w600 : FontWeight.w500;

//====================正文======================
  static TextStyle tsBody_10(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 10);

  static TextStyle tsBody_11(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 11);

  static TextStyle tsBody_12(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12);

  static TextStyle tsBody_12m(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 12, fontWeight: fontMedium);

  static TextStyle tsBody_14(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14);

  static TextStyle tsBody_14m(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 14, fontWeight: fontMedium);

  static TextStyle tsBody_15(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15);

  static TextStyle tsBody_16(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16);

  static TextStyle tsBody_16m(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 16, fontWeight: fontMedium);

  static TextStyle tsBody_18(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18);

  static TextStyle tsBody_18m(BuildContext context) => Theme.of(context)
      .textTheme
      .bodyMedium!
      .copyWith(fontSize: 18, fontWeight: fontMedium);

  static TextStyle tsBody_20(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20);

  static TextStyle tsBody_22(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 22);

  static TextStyle tsBody_24(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 24);

  static TextStyle tsBody_26(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 26);

  static TextStyle tsBody_28(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 28);

  static TextStyle tsBody_30(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 30);

//====================次要======================
  static TextStyle tsSub_10(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10);

  static TextStyle tsSub_11(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11);

  static TextStyle tsSub_12(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12);

  static TextStyle tsSub_12m(BuildContext context) => Theme.of(context)
      .textTheme
      .bodySmall!
      .copyWith(fontSize: 12, fontWeight: fontMedium);

  static TextStyle tsSub_14(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14);

  static TextStyle tsSub_14m(BuildContext context) => Theme.of(context)
      .textTheme
      .bodySmall!
      .copyWith(fontSize: 14, fontWeight: fontMedium);

  static TextStyle tsSub_15(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15);

  static TextStyle tsSub_16(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16);

  static TextStyle tsSub_18(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18);

  static TextStyle tsSub_20(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 20);

  static TextStyle tsSub_22(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 22);

  static TextStyle tsSub_24(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 24);

  static TextStyle tsSub_26(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 26);

  static TextStyle tsSub_28(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 28);

  static TextStyle tsSub_30(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 30);

//====================主色======================
  static const tsMain_12 = TextStyle(fontSize: 12, color: cMain, height: 1.4);
  static const tsMain_14 = TextStyle(fontSize: 14, color: cMain, height: 1.4);
  static const tsMain_14m = TextStyle(
      fontSize: 14, color: cMain, fontWeight: fontMedium, height: 1.4);
  static const tsMain_15 = TextStyle(fontSize: 15, color: cMain, height: 1.4);
  static const tsMain_16 = TextStyle(fontSize: 16, color: cMain, height: 1.4);
  static const tsMain_18 = TextStyle(fontSize: 18, color: cMain, height: 1.4);
  static const tsMain_20 = TextStyle(fontSize: 20, color: cMain, height: 1.4);
  static const tsMain_22 = TextStyle(fontSize: 22, color: cMain, height: 1.4);
  static const tsMain_24 = TextStyle(fontSize: 24, color: cMain, height: 1.4);
}

extension ExTextStyle on TextStyle {
  TextStyle get medium {
    return copyWith(fontWeight: Styles.fontMedium);
  }

  TextStyle get semibold {
    return copyWith(fontWeight: FontWeight.w600);
  }
}
