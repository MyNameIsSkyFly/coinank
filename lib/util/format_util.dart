class FormatUtil {
  FormatUtil._();

  static const double wan = 10000;
  static const double yi = 100000000;
  static const double trillion = 1000000000000;
  static const String wanUnit = '万';
  static const String yiUnit = '亿';
  static const String trillionUnit = '万亿';

  static String amountConversion(double number, {int precision = 1}) {
    final isNegative = number < 0;
    final numberAbs = number.abs();
    late String result;
    if (numberAbs >= 1000000000000) {
      result = '${(numberAbs / 1000000000000).toStringAsFixed(precision)}万亿';
    } else if (numberAbs >= 100000000) {
      result = '${(numberAbs / 100000000).toStringAsFixed(precision)}亿';
    } else if (numberAbs >= 10000) {
      result = '${(numberAbs / 10000).toStringAsFixed(precision)}万';
    } else {
      result = numberAbs.toStringAsFixed(precision);
    }

    if (isNegative) {
      return '-$result';
    } else {
      return result;
    }
  }

  static void test() {
    amountConversion(120);
    amountConversion(18166.35);
    amountConversion(118866.35);
    amountConversion(1222188.35);
    amountConversion(123450000.35);
    amountConversion(12345629887783.5);
  }
}
