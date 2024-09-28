import 'package:daily_example/utils/json_converter/bool_converter.dart';
import 'package:json_annotation/json_annotation.dart';

/// 项目所有模型的`json_annotation`注释基类
/// 默认规范是所有参与转换的属性声明为可空
/// 如果声明为非空，在对应的属性上单独声明
/// 
class ExJsonSerializable extends JsonSerializable {
  const ExJsonSerializable({
    bool? genericArgumentFactories,
    bool includeIfNull = false,
    bool createFactory = true,
    bool createToJson = false,
  }) : super(
          genericArgumentFactories: genericArgumentFactories,
          includeIfNull: includeIfNull,
          createToJson: createToJson,
          createFactory: createFactory,
          converters: const [
            BoolNullJsonConverter(),
            
          ],
        );
}
