import 'package:replace_files/utils.dart';

class NoConfigFoundException implements Exception {
  const NoConfigFoundException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class EmptyConfigException implements Exception {
  const EmptyConfigException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class InvalidConfigException implements Exception {
  const InvalidConfigException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class SourceDirectoryNotFoundException implements Exception {
  const SourceDirectoryNotFoundException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}

class DestinationDirectoryNotFoundException implements Exception {
  const DestinationDirectoryNotFoundException([this.message]);
  final String? message;

  @override
  String toString() {
    return generateError(this, message);
  }
}
