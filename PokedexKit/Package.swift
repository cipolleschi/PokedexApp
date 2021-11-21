// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let packageName = "PokedexKit"

enum Targets: CaseIterable {
    case pokedexPkg
    case pokemonList
    case pokemonDetails
    case root
    
    var name: String {
        switch self {
        case .pokedexPkg: return "PokedexPkg"
        case .pokemonDetails: return "PokemonDetails"
        case .pokemonList: return "PokemonList"
        case .root: return "Root"
        }
    }
    
    static var allButRoot: [Targets] {
        return Self.allCases.filter { $0 != .root }
    }
}


let package = Package(
    name: packageName,
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: packageName,
            targets: Targets.allCases.map(\.name)),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: Targets.root.name,
            dependencies: Targets.allButRoot.map { .targetItem(name: $0.name, condition: nil) }
        ),
        .target(
            name: Targets.pokedexPkg.name,
            dependencies: []
        ),
        .target(
            name: Targets.pokemonList.name,
            dependencies: []
        ),
        .target(
            name: Targets.pokemonDetails.name,
            dependencies: []
        )
    ]
)
