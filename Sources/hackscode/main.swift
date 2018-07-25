import CoreCLI
import Foundation

// You don't have to write anything but version.

struct Hackscode: CommandType {
    init(arguments: [String]) throws { fatalError() }
    init(arguments: Arguments) throws {
        self.arguments = arguments
    }

    static let name: String = "hackscode"

    private let version = "0.1.2"

    let arguments: Arguments

    // sourcery: AutoArgumentsDecodable
    struct Arguments: AutoArgumentsDecodable {
        let version: Bool
        let help: Bool
        let subCommand: CommandType?

        static var shortHandCommands: [String: CommandType.Type] {
            return ["remove": RemoveBuildFileCommand.self]
        }
    }

    static let subCommands: [CommandType.Type] = [RemoveBuildFileCommand.self, CreateAndAddNewFileCommand.self]

    func run() throws {
        if arguments.version {
            print(version)
            exit(0)
        }

        if arguments.help {
            print("Help me!")
            exit(0)
        }

        guard let subCommand = arguments.subCommand else {
            print("Usage!")
            exit(1)
        }

        do {
            try subCommand.run()
        } catch {
            print(error)
            exit(1)
        }
    }
}

let arguments = ProcessInfo.processInfo.arguments
let parser = ArgumentParser(arguments: arguments)

do {
    let arguments = try Hackscode.Arguments(parser: parser, subCommands: Hackscode.subCommands)
    try Hackscode(arguments: arguments).run()
} catch {
    print(error)
    exit(1)
}
