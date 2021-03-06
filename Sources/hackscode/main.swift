import CoreCLI
import Foundation

struct Hackscode: CommandType {
    let arguments: Arguments

    private let version = "0.5.1"

    struct Arguments: AutoArgumentsDecodable {
        let version: Bool
        let help: Bool
        let subCommand: CommandType?
        static let subCommands: [CommandType.Type] = [RemoveBuildFiles.self,
                                                      DumpBuildFiles.self,
                                                      CreateNewFile.self,
                                                      Xquick.self]

        static var shortHandCommands: [String: CommandType.Type] {
            return ["remove": RemoveBuildFiles.self, "dump": DumpBuildFiles.self]
        }
    }

    init() throws {
        let parser = ArgumentParser(arguments: ProcessInfo.processInfo.arguments)
        self.arguments = try Arguments(parser: parser)
    }

    // MARK: CommandType

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
            print("\(type(of: subCommand).name): \(error)")
            exit(1)
        }
    }
}

do {
    try Hackscode().run()
} catch {
    print(error)
    exit(1)
}
