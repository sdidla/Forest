# forest

Generate dependency graphs of targets in your package

## Usage

1. Add this package to your package dependencies

```swift
    .package(url: "https://github.com/sdidla/Forest", .branchItem("main"))
```

2. Run from the terminal

```zsh
    swift package forest [root-target-name]
```

Options:

- `--exclude-external-targets`: Targets that are are
- `--output-json`: Outputs JSON instead of DOT format



