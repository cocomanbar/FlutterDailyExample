import 'package:daily_example/utils/timer_center/timer_item.dart';
import 'package:daily_example/utils/timer_center/timer_section.dart';
import 'package:flutter/foundation.dart';

/// 定时器中心
/// 旨在生成可复用频率相同的定时器，通过添加定时任务共享定时器，减少定时开销
class TimerCenter {
  /// 单例模式
  static final shared = TimerCenter._();
  TimerCenter._();

  /// 定时队列
  late final List<TimerSection> _timerSection = [];

  bool get isEmpty => _timerSection.isEmpty;

  /// 添加定时任务
  void addTimerTask(TimerItem item) {
    TimerSection? section = _lookForPeriodicSection(item);

    /// 存在相同频率的定时任务组，加入
    if (section != null) {
      section.addTimerItem(item);
      return;
    }

    /// 创建新的定时组
    section = TimerSection(
      isSerious: item.isSerious,
      periodicDuration: item.periodicDuration,
      willDeleteSelf: (section) {
        if (section.isEmpty) {
          _timerSection.remove(section);
        }
      },
    );
    _timerSection.add(section);
    section.addTimerItem(item);
  }

  /// 移除定时任务
  /// 有两种方式结束定时任务：
  /// 1.手动移除;
  /// 2.将创建定时任务重置为无效
  void removeTimerTask(TimerItem item) {
    TimerSection? section = _lookForPeriodicSection(item);

    /// 存在相同频率的定时任务组
    if (section != null) {
      section.removeTimerItem(item);
    }
  }

  /// 查询是否被加入
  bool containsTimerItem(TimerItem item) {
    TimerSection? section = _lookForPeriodicSection(item);
    return section != null;
  }

  /// 寻找所在的同频分组
  TimerSection? _lookForPeriodicSection(TimerItem item) {
    TimerSection? section;
    for (var element in _timerSection) {
      if (element.periodicDuration == item.periodicDuration) {
        if (item.isSerious) {
          if (element.containsTimerItem(item)) {
            section = element;
            break;
          }
        } else {
          section = element;
          break;
        }
      }
    }
    return section;
  }

  /// debug information
  List<String> debugInformations() {
    List<String> list = [];
    if (!kDebugMode) return list;

    List<TimerSection> tempList = [];
    tempList.addAll(_timerSection);

    for (var element in tempList) {
      list.addAll(element.toString().split("\n"));
      list.add("");
    }
    return list;
  }
}
