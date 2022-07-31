import Foundation
import PackagePlugin

extension Graph {
    static func make(_ module: TargetDependency) -> Graph {
        Graph(
            nodes: Set(collectNodes(root: module)),
            multiEdges: collectEdges(root: module)
        )
    }

    static func collectNodes(root: TargetDependency) -> [Node] {
        [Node(name: root.name)] +
        root.dependencies.flatMap(collectNodes)
    }
    
    static func collectEdges(root: TargetDependency) -> [Edge] {
        root.dependencies.map { Edge(source: root.name, target: $0.name) } +
        root.dependencies.flatMap(collectEdges)
    }
}

extension TargetDependency {
    var name: String {
        switch self {
        case .target(let target):
            return target.name
        case .product(let product):
            return product.name + "{P}"
        default:
            fatalError("unknown target type")
        }
    }
    
    var dependencies: [TargetDependency] {
        switch self {
        case .target(let target):
            return target.dependencies
        case .product(let product):
            return product.targets.map(TargetDependency.target)
        default:
            return []
        }
    }
}
