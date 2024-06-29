import 'package:daily_example/table_view/page.dart';
import 'package:daily_example/timer_center/page.dart';
import 'package:flutter/material.dart';

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
  static const timerPage = 'timer_page';
  static const tablePage = 'table_page';

  static Map<String, WidgetBuilder> get routes {
    return {
      Path.timerPage: (context) => const TimerCenterPage(),
      Path.tablePage: (context) => const TableViewDemo(),
    };
  }
}
