// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "forest",
    products: [.plugin(name: "forest", targets: ["forest"])],
    targets: [
        .plugin(
            name: "forest",
            capability: .command(
                intent: .custom(
                    verb: "forest",
                    description: "generates target-wise dependency graph"
                )
            )
        )
    ]
)
