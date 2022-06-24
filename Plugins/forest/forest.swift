import PackagePlugin
import Foundation

// poor man's CLI options (--exclude-external-targets)
var excludeExternal = false

@main struct ForestPuglin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {

        excludeExternal = arguments.contains("--exclude-external-targets")
        let outputsJSON = arguments.contains("--output-json")

        guard let root = arguments.first else {
            Diagnostics.error("Usage: swift package forest [root-target-name]")
            return
        }

        guard let node = context.package.targets.map(Node.init).find(root) else {
            Diagnostics.error("Target named '\(root)' not found")
            return
        }

        outputsJSON ? try node.printJSON() : node.printDOT(rootName: root)
    }
}

// MARK: - Node

struct Node: Hashable, Codable {
    enum Kind: Hashable, Codable {
        case product
        case target
    }

    let name: String
    let kind: Kind
    let dependencies: Set<Node>
}

// MARK: - Package Parsing

extension Node {
    init(_ product: Product) {
        self.init(
            name: product.name + "[P]",
            kind: .product,
            dependencies: excludeExternal ? [] : Set(product.targets.compactMap(Node.init))
        )
    }

    init(_ target: Target) {
        self.init(
            name: target.name,
            kind: .target,
            dependencies: Set(target.dependencies.compactMap(Node.init))
        )
    }

    init?(_ dependency: TargetDependency) {
        switch dependency {
        case .target(let target):
            self.init(target)
        case .product(let product):
            self.init(product)
        @unknown default:
            Diagnostics.warning("Unknow target type: \(dependency)")
            return nil
        }
    }
}

// MARK: - Dot Conversion

extension Node {

    func printJSON() throws {
        let data = try JSONEncoder().encode(self)
        if let string = String(data: data, encoding: .utf8) {
            print(string)
        } else {
            throw NSError(domain: "utf8", code: -1)
        }
    }

    func printDOT(rootName: String)  {
        print("# totalModules: ", flat.count)

        print("digraph targetGraph {")

        print("\t", "graph [bgcolor=white,pad=2]")
        print("\t", "edge [dir=back,color=grey10,style=solid,penwidth=1]")
        print("\t", "node [style=filled, shape=box, fillcolor=white, color=grey10, fontname=helveticaNeue, fontcolor=grey10, penwidth=2]")

        print("\n")
        print(dot)
        print("\n")

        products.map { $0.name }.forEach {
            print("\t", "\"\($0)\" [fillcolor=gray, fontcolor=black]")
        }

        print("\t", "\"\(rootName)\" [fillcolor=royalblue, fontcolor=grey100]")
        print("}")
    }

    var dot: String {
        Set(dotLines).map { "\t" + $0 }.joined(separator: "\n")
    }

    private var dotLines: [String] {
        dotDependencyLines + dependencies.flatMap(\.dotLines)
    }

    private var dotDependencyLines: [String] {
        dependencies.map {
            "\(dotName) -> \($0.dotName)"
        }
    }

    private var dotName: String {
        "\"" + name + "\""
    }
}

// MARK: - Find Node

extension Set where Element == Node {
    func find(_ name: String) -> Node? {
        Array(self).find(name)
    }
}

extension Array where Element == Node {
    func find(_ name: String) -> Node? {
        compactMap { node -> Node? in
            if node.name == name {
                return node
            } else if let node = node.dependencies.find(name) {
                return node
            } else {
                return nil
            }
        }
        .first
    }
}

extension Node {
    var products: Set<Node> {
        flat.filter { $0.kind == .product }
    }

    var flat: Set<Node> {
        Set([self] + dependencies.flatMap(\.flat))
    }
}
