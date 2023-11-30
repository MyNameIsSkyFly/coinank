
class FormatUtil {
  FormatUtil._();

  static const double wan = 10000;
  static const double yi = 100000000;
  static const double trillion = 1000000000000;
  static const String wanUnit = '万';
  static const String yiUnit = '亿';
  static const String trillionUnit = '万亿';

  static String amountConversion(double number) {
    if (number >= 1000000000000) {
      return '${(number / 1000000000000).toStringAsFixed(2)}万亿';
    } else if (number >= 100000000) {
      return '${(number / 100000000).toStringAsFixed(2)}亿';
    } else if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(2)}万';
    } else {
      return number.toStringAsFixed(2);
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
