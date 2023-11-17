import 'package:flutter/services.dart';

class RegexExpression {
  /// 第一个输入字符不能为空格
  static const String regexFirstNotNull = r'^(\S){1}';

  ///除空格外是否还有其他字符
  static const String regexNotOnlyNull = r'([^\s])';

  ///只允许输入英文或数字
  static const String regexOnlyNumOrLetters = r'(^[A-Za-z0-9]+$)';

  ///大小写英文、数字、特殊符号
  static const String regexPassword = r'(^[A-Za-z0-9!@#$%^&*()-_=+,.:;?/~]+$)';

  ///大小写英文和数字和特殊符号
  static const String regexPwd =
      r'(?=.*[A-Z])(?=.*\d)(?=.*[~`!@#$%^&*()_\-+={}[\]|;:,<>.?/])[A-Za-z\d~`!@#$%^&*()_\-+={}[\]|;:,<>.?/]{6,24}';

  ///只允许输入数字
  static const String regexOnlyNum = r'(^[0-9]+$)';
  static const String regexOnlyMinSixNum = r'(^[0-9]{6,})';

  ///只允许输入26字母
  static const String regexOnlyLetter = r'(^[A-Za-z]+$)';

  ///只允许输入数字和.
  static const String regexOnlyPrice = r'(^[0-9.]+$)';
}

class RegexFormatter extends TextInputFormatter {
  RegexFormatter({required this.regex});

  final String regex;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return TextEditingValue.empty;
    }

    if (!RegExp(regex).hasMatch(newValue.text)) {
      return oldValue;
    }
    return newValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// 判断当前输入框是否存在未完成的字符串
    if (newValue.isComposingRangeValid) return newValue;

    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
