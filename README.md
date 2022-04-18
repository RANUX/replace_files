# Replace files from src to dst dir recursively

## 📖 Guide
#### Create a new config file with yaml format.
```yaml
replace_files:
  src: "example/src/"
  dest: "example/dst/"
```

#### Run `replace_files` from command line.
```bash
$ dart bin/main.dart -f example/sample_conf.yaml
```

#### Run in flutter project
Add replace_files to pubspec.yaml:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  ...
  replace_files:
    git:
      url: https://github.com/RANUX/replace_files.git
      ref: main
```
Run command:
```bash
flutter pub get
flutter pub run replace_files:main -f example/sample_conf.yaml
```

### How to build exe file
```bash
mkdir build
dart compile exe bin/main.dart -o build/replace_files
```

