import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';

class YamlConverter {
  static String mapToYaml(Map<String, dynamic> data) {
    var yamlString = '';
    try {
      final yamlMap = YamlMap.wrap(data);
      yamlString = prettyYamlString(yamlMap);
    } catch (e) {
      debugPrint('YamlConverter::mapToYaml Error converting map to YAML: $e');
    }
    return yamlString;
  }

  static Map<String, dynamic> yamlToMap(String yamlString) {
    try {
      final yamlDoc = loadYaml(yamlString);
      if (yamlDoc is YamlMap) {
        return _parseYamlMap(yamlDoc);
      } else {
        debugPrint(
            'YamlConverter::yamlToMap Invalid YAML format. Expected a YAML map.');
      }
    } catch (e) {
      debugPrint('YamlConverter::yamlToMap Error converting YAML to map: $e');
      debugPrintStack();
    }
    return {};
  }

  static String prettyYamlString(YamlMap yamlMap) {
    final buffer = StringBuffer();
    buffer.writeln('# Generated by YamlConverter');
    _writeYamlMap(buffer, yamlMap, 0);
    return buffer.toString();
  }

  static void _writeYamlMap(StringBuffer buffer, YamlMap yamlMap, int depth) {
    final indent = ' ' * (depth * 2);
    for (var key in yamlMap.keys) {
      final value = yamlMap[key];
      if (value is YamlMap) {
        buffer.writeln('$indent$key:');
        _writeYamlMap(buffer, value, depth + 1);
      } else {
        buffer.writeln('$indent$key: $value');
      }
    }
  }

  static Map<String, dynamic> _parseYamlMap(YamlMap yamlMap) {
    final Map<String, dynamic> resultMap = {};
    for (var key in yamlMap.keys) {
      final value = yamlMap[key];
      if (value is YamlMap) {
        resultMap[key] = _parseYamlMap(value);
      } else {
        resultMap[key.toString()] = value;
      }
    }
    return resultMap;
  }
}
