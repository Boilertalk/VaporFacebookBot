import PackageDescription

let package = Package(
    name: "VaporFacebookBot",
    targets: [
        Target(name: "VaporFacebookBot")
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ],
    exclude: []
)
