import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:replace_files/custom_exceptions.dart';
import 'package:yaml/yaml.dart';

const String helpFlag = 'help';
const String fileOption = 'file';

Future<void> parseArguments(List<String> arguments) async {
  final ArgParser parser = ArgParser(allowTrailingOptions: true);
  parser.addFlag(helpFlag, abbr: 'h', help: 'Usage help', negatable: false);
  parser.addOption(fileOption, abbr: 'f', help: 'Config file to read');

  final ArgResults argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    stdout.writeln('Replace files ');
    stdout.writeln(parser.usage);
    exit(0);
  }

  // Load the config file
  final Map<String, dynamic>? yamlConfig =
      loadConfigFileFromArgResults(argResults, verbose: true);

  if (yamlConfig == null) {
    throw const NoConfigFoundException();
  }

  replaceFiles(yamlConfig);
}

void replaceFiles(Map<String, dynamic> yamlConfig) {
  if (yamlConfig.isEmpty) {
    throw const EmptyConfigException();
  }
  if (yamlConfig.keys.contains('src') && yamlConfig.keys.contains('dest')) {
    replaceFilesFromConfig(yamlConfig);
  } else {
    throw const InvalidConfigException();
  }
}

void replaceFilesFromConfig(Map<String, dynamic> yamlConfig) {
  final String src = yamlConfig['src'];
  final String dest = yamlConfig['dest'];

  final Directory srcDir = Directory(src);
  final Directory destDir = Directory(dest);

  if (!srcDir.existsSync()) {
    throw const SourceDirectoryNotFoundException();
  }
  if (!destDir.existsSync()) {
    throw const DestinationDirectoryNotFoundException();
  }

  final List<FileSystemEntity> srcFiles = srcDir.listSync(recursive: true);

  for (final FileSystemEntity srcFile in srcFiles) {
    final String srcFilePath = srcFile.path;
    final String destFilePath =
        destDir.path + srcFilePath.substring(srcDir.path.length);

    if (srcFile is File) {
      final File destFile = File(destFilePath);
      final Uint8List srcFileContents = srcFile.readAsBytesSync();
      if (destFile.existsSync()) {
        final Uint8List destFileContents = destFile.readAsBytesSync();
        destFile.writeAsBytesSync(srcFileContents);
      } else {
        destFile.createSync();
        destFile.writeAsBytesSync(srcFileContents);
      }
    }
  }
}

Map<String, dynamic>? loadConfigFileFromArgResults(ArgResults argResults,
    {bool verbose = false}) {
  final String? configFile = argResults[fileOption];
  final String? fileOptionResult = argResults[fileOption];

  // if icon is given, try to load icon
  if (configFile != null) {
    try {
      return loadConfigFile(configFile, fileOptionResult);
    } catch (e) {
      if (verbose) {
        stderr.writeln(e);
      }
      return null;
    }
  }

  return null;
}

Map<String, dynamic> loadConfigFile(String path, String? fileOptionResult) {
  final File file = File(path);
  final String yamlString = file.readAsStringSync();
  // ignore: always_specify_types
  final Map yamlMap = loadYaml(yamlString);

  if (!(yamlMap['replace_files'] is Map)) {
    stderr.writeln(NoConfigFoundException('Check that your config file '
        ' has a `replace_files` section'));
    exit(1);
  }

  // yamlMap has the type YamlMap, which has several unwanted sideeffects
  final Map<String, dynamic> config = <String, dynamic>{};
  for (MapEntry<dynamic, dynamic> entry in yamlMap['replace_files'].entries) {
    config[entry.key] = entry.value;
  }

  return config;
}
