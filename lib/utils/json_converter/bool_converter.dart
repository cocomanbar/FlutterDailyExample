
import 'package:daily_example/utils/json_converter/map.dart';
import 'package:json_annotation/json_annotation.dart';

/// Bool类型的非空转换器
class BoolJsonConverter extends JsonConverter<bool, dynamic> {
  const BoolJsonConverter();

  @override
  bool fromJson(dynamic json) {
    if (json != null) {
      return {"key": json}.boolValue("key") ?? false;
    }
    return false;
  }

  @override
  dynamic toJson(bool object) {
    return object;
  }
}

/// Bool类型的可空转换器
class BoolNullJsonConverter extends JsonConverter<bool?, dynamic> {
  const BoolNullJsonConverter();

  @override
  bool? fromJson(dynamic json) {
    if (json != null) {
      return {"key": json}.boolValue("key") ?? false;
    }
    return null;
  }

  @override
  dynamic toJson(bool? object) {
    return object;
  }
}
