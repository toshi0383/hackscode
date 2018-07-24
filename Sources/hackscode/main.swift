import CoreCLI
import Foundation

let version = "0.1.2"

let arguments = ProcessInfo.processInfo.arguments

if arguments.last == "--version" {
    print(version)
    exit(0)
}

enum Command: String {
    case removeBuildFile = "remove-build-files"
    case createAndAddNewFile = "create-new-file"
    static var all: [Command] {
        return [.removeBuildFile, .createAndAddNewFile]
    }
}

guard let command = arguments.lazy.compactMap(Command.init).first else {
    print(
        """
        Missing command. Specify one of those.
            \(Command.all.map { $0.rawValue }.joined(separator: "\n    "))
        """
    )
    exit(1)
}

let parser = ArgumentParser(arguments: arguments)

do {
    switch command {
    case .removeBuildFile:
        try RemoveBuildFileCommand(parser: parser).run()
    case .createAndAddNewFile:
//        try CreateAndAddNewFileCommand.run(parser: parser)
        break
    }
} catch {
    print(error)
    exit(1)
}
