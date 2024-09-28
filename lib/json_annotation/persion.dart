import 'package:daily_example/utils/json_converter/json_serializable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/json_converter/bool_converter.dart';

part 'persion.g.dart';

@ExJsonSerializable()
class Person {

  // 默认声明为可空，在ExJsonSerializable里默认支持
  @JsonKey(name: "is_empty1")
  bool? isEmpty1;

  // 如果需要声明为非空，需要单独声明非空转换器BoolJsonConverter覆盖配置
  @BoolJsonConverter()
  @JsonKey(name: "is_empty2", defaultValue: false)
  bool isEmpty2 = false;

  Person();

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}
