class ThemeChangeEvent {
  final ThemeChangeType type;

  ThemeChangeEvent({required this.type});
}

enum ThemeChangeType {
  dark,
  upColor,
  locale,
}
