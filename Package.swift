import PackageDescription

let package = Package(
    name: "BoilertalkFacebook",
    targets: [
        Target(name: "BoilertalkFacebook")
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ],
    exclude: []
)
