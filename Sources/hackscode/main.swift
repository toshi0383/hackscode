import CoreCLI
import Foundation

struct Hackscode: CommandType {
    init(arguments: [String]) throws {
        let parser = ArgumentParser(arguments: arguments)
        self.arguments = try Arguments(parser: parser)
    }

    static let name: String = "hackscode"
    let arguments: Arguments

    private let version = "0.1.2"

    // sourcery: AutoArgumentsDecodable
    struct Arguments: AutoArgumentsDecodable {
        let version: Bool
        let help: Bool
        let subCommand: CommandType?
        static let subCommands: [CommandType.Type] = [RemoveBuildFiles.self,
                                                      CreateNewFile.self]

        static var shortHandCommands: [String: CommandType.Type] {
            return ["remove": RemoveBuildFiles.self]
        }
    }

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

do {
    try Hackscode(arguments: ProcessInfo.processInfo.arguments).run()
} catch {
    print(error)
    exit(1)
}
