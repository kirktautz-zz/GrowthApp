// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "mongoProject",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger", majorVersion: 1, minor: 7),
        .Package(url: "https://github.com/IBM-Swift/BlueCryptor", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/OpenKitten/MongoKitten", majorVersion: 4, minor: 0)
    ]
)
