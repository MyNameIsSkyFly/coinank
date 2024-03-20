class EventCoinMarked {
  final bool isSpot;
  final List<String?> baseCoin;
  final bool? follow;

  EventCoinMarked(
      {this.isSpot = false, required this.baseCoin, required this.follow});
}
