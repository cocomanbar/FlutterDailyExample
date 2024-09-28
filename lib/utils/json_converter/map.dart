extension ExMap<K, V> on Map<K, V> {
  /// 如果 value 存在且为 num 或可转换为 num，则返回 num 值；否则返回 null。
  num? numValue(K key) {
    final value = this[key];
    if (value != null) {
      if (value is num) {
        return value;
      } else if (value is String) {
        return num.tryParse(value);
      }
    }
    return null;
  }

  /// 获取 key 对应的整型值。
  ///
  /// [nullForZero] 为 true 时，如果 value 为 0，则返回 null。
  int? intValue(
    K key, {
    bool? nullForZero,
  }) {
    final value = numValue(key)?.toInt();
    if (value == null) return null;
    if (value == 0 && nullForZero == true) return null;
    return value;
  }

  /// 获取 key 对应的双精度浮点数值。
  ///
  /// [nullForZero] 为 true 时，如果 value 为 0.0，则返回 null。
  double? doubleValue(
    K key, {
    bool? nullForZero,
  }) {
    final value = numValue(key)?.toDouble();
    if (value == null) return null;
    if (value == 0.0 && nullForZero == true) return null;
    return value;
  }

  /// 获取 key 对应的字符串值。
  ///
  /// [nullForEmpty] 为 true 时，如果 value 为空字符串，则返回 null。
  String? stringValue(
    K key, {
    bool? nullForEmpty,
  }) {
    final value = this[key];
    if (value != null) {
      if (value is String) {
        if (nullForEmpty ?? false) {
          return value.isEmpty ? null : value;
        }
        return value;
      } else if (value is num) {
        return value.toString();
      }
    }
    return null;
  }

  /// 获取 key 对应的bool值。
  bool? boolValue(K key) {
    final value = this[key];
    if (value != null) {
      if (value is bool) {
        return value;
      } else if (value is num) {
        return value != 0;
      } else if (value is String) {
        return (int.tryParse(value) ?? 0) != 0;
      }
    }
    return null;
  }

  /// 获取 key 对应的Map值。
  Map? mapValue(K key) {
    final value = this[key];
    if (value is Map) {
      return value;
    }
    return null;
  }
}
