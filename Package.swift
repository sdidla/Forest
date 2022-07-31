// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Forest",
    products: [.plugin(name: "Forest", targets: ["Forest"])],
    targets: [
        .plugin(
            name: "Forest",
            capability: .command(
                intent: .custom(
                    verb: "forest",
                    description: "generates target-wise dependency graph"
                )
            )
        )
    ]
)
