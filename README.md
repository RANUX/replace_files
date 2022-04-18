# Replace files from src to dst dir recursively

## 📖 Guide
#### 1. Create a new config file with yaml format.
```yaml
replace_files:
  src: "example/src/"
  dest: "example/dst/"
```

#### 2. Run `replace_files` command.
```bash
$ dart bin/main.dart -f example/sample_conf.yaml
```

### How to build exe file
```bash
mkdir build
dart compile exe bin/main.dart -o build/replace_files
```

