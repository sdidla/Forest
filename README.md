# Forest

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

## Example

Added to [Hatch](https://github.com/sdidla/Hatch) and running `swift package forest HatchParser` produces

```
# totalModules:  7
digraph targetGraph {
	 graph [bgcolor=white,pad=2]
	 edge [dir=back,color=grey10,style=solid,penwidth=1]
	 node [style=filled, shape=box, fillcolor=white, color=grey10, fontname=helveticaNeue, fontcolor=grey10, penwidth=2]


	"SwiftSyntax" -> "_CSwiftSyntax"
	"SwiftSyntaxParser" -> "_InternalSwiftSyntaxParser"
	"SwiftSyntaxParser[P]" -> "SwiftSyntaxParser"
	"SwiftSyntax[P]" -> "SwiftSyntax"
	"HatchParser" -> "SwiftSyntax[P]"
	"SwiftSyntaxParser" -> "SwiftSyntax"
	"HatchParser" -> "SwiftSyntaxParser[P]"


	 "SwiftSyntaxParser[P]" [fillcolor=gray, fontcolor=black]
	 "SwiftSyntax[P]" [fillcolor=gray, fontcolor=black]
	 "HatchParser" [fillcolor=royalblue, fontcolor=grey100]
}
```


Pasted into http://viz-js.com produces:

![HatchParser](https://user-images.githubusercontent.com/16975114/175520831-e9fba921-43c0-4cc3-b29a-22d855626ac0.png)

# Acknowledgments

[Andreas Koslowski](https://github.com/akoslowski) for developing a tool called `Tangle`. The idea to build this tool as well as the `DOT` formattting options were directly copied.



