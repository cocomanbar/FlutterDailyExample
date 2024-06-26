class Item {
  final String title;
  final String detailText;
  final String path;

  Item({
    required this.title,
    required this.detailText,
    required this.path,
  });
}

abstract class Path {
  static const timerPage = 'timer_center';
}
