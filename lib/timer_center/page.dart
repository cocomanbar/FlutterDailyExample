import 'dart:async';

import 'package:daily_example/utils/timer_center/timer_center.dart';
import 'package:daily_example/utils/timer_center/timer_item.dart';
import 'package:flutter/material.dart';

class TimerCenterPage extends StatefulWidget {
  const TimerCenterPage({super.key});

  @override
  State<TimerCenterPage> createState() => _TimerCenterPageState();
}

class _TimerCenterPageState extends State<TimerCenterPage> {
  late List<TimerItem> listItems = [];

  late Timer timer;

  late int count = 1;
  late int sectionCount = 2;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    for (var element in listItems) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> debugInformations = TimerCenter.shared.debugInformations();

    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: active,
            child: const Text("激活"),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: inActive,
            child: const Text("暂停"),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: reduce,
            child: const Text("减少"),
          ),
          const SizedBox(width: 30),
          GestureDetector(
            onTap: increase,
            child: const Text("增加"),
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          String debugText = debugInformations[index];
          bool isItem = debugText.contains("   ");
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              debugText,
              style: TextStyle(
                fontSize: isItem ? 12 : 16,
                color: isItem ? Colors.grey : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
        itemCount: debugInformations.length,
      ),
    );
  }

  void increase() {
    if (sectionCount == 0) {
      count += 1;
      sectionCount = 2;
    }
    sectionCount -= 1;

    TimerItem item = TimerItem(
      taget: this,
      periodicDuration: Duration(seconds: count),
      totalDuration: const Duration(seconds: 15),
      timeChange: (duration) {
        debugPrint("来了 $duration");
      },
    );
    TimerCenter.shared.addTimerTask(item);
    listItems.add(item);
  }

  void reduce() {
    if (listItems.isEmpty) return;
    TimerItem item = listItems.first;
    listItems.remove(item);
    // 方式1
    //TimerCenter.shared.removeTimerTask(item);
    // 方式2（推荐）
    item.dispose();
  }

  void inActive() {
    if (listItems.isEmpty) return;
    TimerItem item = listItems.first;
    item.becomeInActive();
  }

  void active() {
    if (listItems.isEmpty) return;
    TimerItem item = listItems.first;
    item.becomeActive();
  }
}
