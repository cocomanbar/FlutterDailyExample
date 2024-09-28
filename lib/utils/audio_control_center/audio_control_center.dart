import 'package:flutter/material.dart';

/// 音频播放控制中心
/// 负责管理和控制app内部当前的播放源
/// 内部有一个队列负责存放历史的播放需求列表，一个当前的播放源以及前一个历史播放源（如果还未被移除的话）
///
/// 通过混入 [AudioSourceMixin] 实现
/// 如何通知暂停其他播放源，被其他播放源要求暂停，以及可能自身要求允许被恢复播放的逻辑
class AudioControlCenter {
  AudioSourceMixin? _currentSource;
  final List<AudioSourceMixin> _audioSources = [];

  /// 单例模式
  static final shared = AudioControlCenter._();
  AudioControlCenter._();

  /// 添加播放控制源
  /// [sourceMixin] 新的播放源
  /// [setCur] 是否重置到当前播放源等级，重置代表暂停之前的播放源，默认false
  void addAudioSource(AudioSourceMixin sourceMixin, {bool setCur = false}) {
    if (_audioSources.contains(sourceMixin)) {
      return;
    }
    _audioSources.add(sourceMixin);

    if (setCur) {
      _currentSource?.audioControlCenterToPauseSelf();
      _currentSource = sourceMixin;
    }
  }

  /// 移除播放控制源
  /// [sourceMixin] 被移除的播放源
  void removeAudioSource(AudioSourceMixin sourceMixin) {
    if (_audioSources.contains(sourceMixin)) {
      _audioSources.remove(sourceMixin);
    }

    if (_currentSource == sourceMixin) {
      _currentSource = null;
    }

    // 检查队列是否有满足的播放源
    if (_currentSource == null && _audioSources.isNotEmpty) {
      List<AudioSourceMixin> reversedAudioSources =
          _audioSources.reversed.toList();
      for (var element in reversedAudioSources) {
        if (element.allowAudioCenterResume) {
          _currentSource = element;
          break;
        }
      }
      _currentSource?.audioControlCenterToResumeSelf();
    }
  }

  /// 暂停当前播放源播放
  void pause() {
    _currentSource?.audioControlCenterToPauseSelf();
  }

  /// 恢复当前播放源播放
  void resume() {
    _currentSource?.audioControlCenterToResumeSelf();
  }
}

mixin AudioSourceMixin on State {
  // 是否允许被广播中心通知继续播放，默认false
  bool get allowAudioCenterResume => false;

  @override
  void initState() {
    super.initState();
    AudioControlCenter.shared.addAudioSource(this);
  }

  @override
  void dispose() {
    AudioControlCenter.shared.removeAudioSource(this);
    super.dispose();
  }

  // 当前播放源通知广播中心暂停其他的播放源
  void audioControlCenterToPauseOther() {
    // 接受到当前宿主通知时
    AudioSourceMixin? currentSource = AudioControlCenter.shared._currentSource;
    if (currentSource != null && currentSource == this) {
      return;
    }
    currentSource?.audioControlCenterToPauseSelf();
    AudioControlCenter.shared._currentSource = this;
  }

  // 被广播中心通知打断播放，在这里实现当前宿主的暂停播放逻辑
  @mustCallSuper
  void audioControlCenterToPauseSelf() {}

  // 被广播中心通知恢复播放，在这里实现当前宿主的恢复播放逻辑
  @mustCallSuper
  void audioControlCenterToResumeSelf() {}
}
