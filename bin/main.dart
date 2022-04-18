import 'dart:io';

import 'package:replace_files/custom_exceptions.dart';
import 'package:replace_files/main.dart';

void handleException(e) {
  if (e is NoConfigFoundException) {
    print('No config file found. Please run with --help for more information.');
  }
  if (e is SourceDirectoryNotFoundException) {
    print(
        'Source directory not found. Please run with --help for more information.');
  }
  if (e is DestinationDirectoryNotFoundException) {
    print(
        'Destination directory not found. Please run with --help for more information.');
  } else {
    stderr.writeln(e);
    stderr.writeln(e.stackTrace);
  }
}

void main(List<String> arguments) {
  parseArguments(arguments).catchError((e) {
    handleException(e);
    exit(1);
  });
}
