import 'package:decimal/decimal.dart';

class FormatUtil {
  FormatUtil._();
  static const double wan = 10000;
  static const double yi = 100000000;
  static const String wanUnit = '万';
  static const String yiUnit = '亿';

  static String amountConversion(double amount) {
    String result = '$amount';
    double value = 0;
    double tempValue = 0;
    double remainder = 0;
    if ((amount > wan) && (amount < yi)) {
      tempValue = (amount ~/ wan).toDouble();
      remainder = (amount % wan);
      if (remainder < (wan ~/ 2)) {
        value = formatNumber(tempValue, 2);
      } else {
        value = formatNumber(tempValue, 2);
      }
      if (value == wan) {
        result = ((value / wan).toStringAsFixed(2) + yiUnit);
      } else {
        result = (value.toStringAsFixed(2) + wanUnit);
      }
    } else {
      if (amount > yi) {
        tempValue = amount / yi;
        remainder = (amount % yi);
        if (remainder < (yi ~/ 2)) {
          value = formatNumber(tempValue, 2);
        } else {
          value = formatNumber(tempValue, 2);
        }
        result = (value.toStringAsFixed(2) + yiUnit);
      } else {
        result = amount.toStringAsFixed(2);
      }
    }
    return result;
  }

  static double formatNumber(double number, int precision) {
    final bigDecimal = Decimal.parse('$number');
    return bigDecimal.round(scale: precision).toDouble();
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
