import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerItem<T> {
  /// 任务是否激活，激活就会随着定时器改变剩余定时时间
  bool get active => _active;
  bool _active = true;

  /// 任务是否有效，无效代表可以清除
  bool get valid => taget != null;

  /// 绑定在实例上，跟随实例的生命周期
  T? taget;

  /// 定时周期
  final Duration periodicDuration;

  /// 总时长
  Duration totalDuration;

  /// 剩余总时长回调
  final Function(Duration duration) timeChange;

  /// 自动加入队列
  bool _autoActive = true;

  /// 新开组
  /// 当组周期越大的时候，后加入的任务定时就会有很较大的误差
  /// 解决途径是新开不共享，建议定时周期大于等于2s开启且需要严格定时的任务
  bool _isSerious = false;
  bool get isSerious => _isSerious;

  TimerItem({
    required this.taget,
    required this.periodicDuration,
    required this.totalDuration,
    required this.timeChange,
    bool autoActive = true,
    bool isSerious = false,
  }) {
    _active = autoActive;
    _autoActive = autoActive;
    _isSerious = isSerious;

    _autoActiveOnceCall();

    assert(!(totalDuration.isNegative || totalDuration == Duration.zero), "❌");
    assert(!(periodicDuration.isNegative || periodicDuration == Duration.zero),
        "❌");
  }

  void _autoActiveOnceCall() {
    if (_autoActive) {
      timeChange.call(totalDuration);
    }
  }

  /// 通过定时器中心触发减少时间
  Future<void> reduceTiming() async {
    if (!active || !valid) return;

    totalDuration -= periodicDuration;
    if (totalDuration.isNegative) {
      totalDuration = Duration.zero;
    }
    timeChange.call(totalDuration);

    if (totalDuration == Duration.zero) {
      becomeInActive();
    }
  }

  /// 激活，如果时间还剩余，随着定时器在改变剩余时间
  /// [duration] 重置总时长
  void becomeActive({Duration? duration}) {
    if (duration != null) {
      assert(!(duration.isNegative || duration == Duration.zero), "❌");
      totalDuration = duration;
      _autoActiveOnceCall();
    }
    _active = true;
  }

  /// 取消激活，如果时间还剩余，不会随着定时器在改变剩余时间
  void becomeInActive() {
    _active = false;
  }

  /// 实例销毁时执行
  void dispose() {
    taget = null;
    _active = false;
  }

  @override
  String toString() {
    if (kDebugMode) {
      List<String> list = [];
      list.add("    任务(hash=$hashCode):");
      list.add("    有效：$valid");
      list.add("    激活：$active");
      list.add("    周期：${periodicDuration.toString()}");
      list.add("    时长：${totalDuration.toString()}");
      return list.join("\n");
    }
    return super.toString();
  }
}
