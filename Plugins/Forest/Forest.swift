import PackagePlugin
import Foundation

@main struct ForestPuglin: CommandPlugin {
    func performCommand(context: PluginContext, arguments: [String]) throws {

        guard let root = arguments.first else {
            Diagnostics.error("Usage: swift package forest [root-target-name]")
            return
        }

        let target = context.package.targets.first { $0.name == root }
            .map(TargetDependency.target)
        
        let product = context.package.products.first { $0.name == root }
            .map(TargetDependency.product)

        guard let module = target ?? product else {
            Diagnostics.error("Usage: Target/Product not found")
            return
        }
        
        let graph = Graph.make(module)
        print(graph.multiEdgeDOT)
    }
}
