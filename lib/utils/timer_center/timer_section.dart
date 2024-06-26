import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:daily_example/utils/timer_center/timer_item.dart';

class TimerSection {
  /// 相同频率的定时任务
  late final List<TimerItem> _timerItems = [];

  bool get isEmpty => _timerItems.isEmpty;

  /// 定时器
  Timer? _timer;

  /// 定时周期
  final Duration periodicDuration;

  /// 从定时中心移除本组
  final Function(TimerSection section) willDeleteSelf;

  final bool isSerious;

  TimerSection({
    required this.periodicDuration,
    required this.willDeleteSelf,
    required this.isSerious,
  });

  void addTimerItem(TimerItem item) {
    if (_timerItems.contains(item)) return;
    _timerItems.add(item);

    _startTimerIfNeeded();
  }

  void removeTimerItem(TimerItem item) {
    if (!_timerItems.contains(item)) return;
    _timerItems.remove(item);

    /// 检查销毁定时器
    _willDeleteSelfIfNeeded();
  }

  bool containsTimerItem(TimerItem item) {
    return _timerItems.contains(item);
  }

  /// 开启定时器
  void _startTimerIfNeeded() {
    if (_timer != null) return;
    _timer = Timer.periodic(periodicDuration, (timer) {
      List<TimerItem> tempList = [];
      tempList.addAll(_timerItems);

      for (var element in tempList) {
        if (!element.valid) {
          _timerItems.remove(element);
          continue;
        }
        element.reduceTiming();
      }

      /// 检查销毁定时器
      _willDeleteSelfIfNeeded();
    });
  }

  /// 将要销毁组对象
  void _willDeleteSelfIfNeeded() {
    if (!isEmpty) return;
    _disposeTimer();
    willDeleteSelf.call(this);
  }

  /// 销毁定时器
  void _disposeTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  String toString() {
    if (kDebugMode) {
      List<String> list = [];
      list.add("任务组($hashCode):");
      list.add("激活：${_timer?.isActive ?? false}, 数量：${_timerItems.length}");
      list.add("周期：${periodicDuration.toString()}，列表：");
      List<TimerItem> tempItems = List.from(_timerItems);
      for (var element in tempItems) {
        list.add(element.toString());
        list.add("");
      }
      return list.join("\n");
    }
    return super.toString();
  }
}
