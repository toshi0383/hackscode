// Generated using Sourcery 0.13.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated by using CoreCLI version 0.1.x

import CoreCLI

// - MARK: CreateNewFile.Argument

extension CreateNewFile.Argument {
    private typealias Base = CreateNewFile.Argument

    private static var autoMappedOptions: [PartialKeyPath<Base>: String] {
        return [
            \Base.toTarget: "--to-target",
            \Base.filepath: "--filepath",
            \Base.underGroup: "--under-group",
        ]
    }

    private static var autoMappedFlags: [KeyPath<Base, Bool>: String] {
        return [
:        ]
    }

    init(parser: ArgumentParserType) throws {

        func getOptionValue(keyPath: PartialKeyPath<Base>) throws -> String {
            if let short = Base.shortHandOptions[keyPath],
                let value = try? parser.getValue(forOption: "-\(short)") {
                return value
            }
            let long = Base.autoMappedOptions[keyPath]!
            return try parser.getValue(forOption: long)
        }

        func getFlag(keyPath: KeyPath<Base, Bool>) -> Bool {
            if let short = Base.shortHandFlags[keyPath] {
                let value = parser.getFlag("-\(short)")
                if value {
                    return true
                }
            }
            let long = Base.autoMappedFlags[keyPath]!
            return parser.getFlag(long)
        }

        func getCommandType() -> CommandType.Type? {
            while let arg = parser.shift() {
                if let subCommand = Base.shortHandCommands[arg] {
                    return subCommand
                }
                if let subCommand = Base.subCommands.first(where: { $0.name == arg }) {
                    return subCommand
                }
            }
            return nil
        }

        self.toTarget = try getOptionValue(keyPath: \Base.toTarget)
        self.filepath = try getOptionValue(keyPath: \Base.filepath)
        self.underGroup = try getOptionValue(keyPath: \Base.underGroup)
    }
}

// - MARK: Hackscode.Arguments

extension Hackscode.Arguments {
    private typealias Base = Hackscode.Arguments

    private static var autoMappedOptions: [PartialKeyPath<Base>: String] {
        return [
:        ]
    }

    private static var autoMappedFlags: [KeyPath<Base, Bool>: String] {
        return [
            \Base.version: "--version",
            \Base.help: "--help",
        ]
    }

    init(parser: ArgumentParserType) throws {

        func getOptionValue(keyPath: PartialKeyPath<Base>) throws -> String {
            if let short = Base.shortHandOptions[keyPath],
                let value = try? parser.getValue(forOption: "-\(short)") {
                return value
            }
            let long = Base.autoMappedOptions[keyPath]!
            return try parser.getValue(forOption: long)
        }

        func getFlag(keyPath: KeyPath<Base, Bool>) -> Bool {
            if let short = Base.shortHandFlags[keyPath] {
                let value = parser.getFlag("-\(short)")
                if value {
                    return true
                }
            }
            let long = Base.autoMappedFlags[keyPath]!
            return parser.getFlag(long)
        }

        func getCommandType() -> CommandType.Type? {
            while let arg = parser.shift() {
                if let subCommand = Base.shortHandCommands[arg] {
                    return subCommand
                }
                if let subCommand = Base.subCommands.first(where: { $0.name == arg }) {
                    return subCommand
                }
            }
            return nil
        }

        self.version = getFlag(keyPath: \Base.version)
        self.help = getFlag(keyPath: \Base.help)
        if let type = getCommandType() {
            self.subCommand = try type.init(arguments: parser.shiftAll())
        } else {
            self.subCommand = nil
        }
    }
}

// - MARK: RemoveBuildFiles.Argument

extension RemoveBuildFiles.Argument {
    private typealias Base = RemoveBuildFiles.Argument

    private static var autoMappedOptions: [PartialKeyPath<Base>: String] {
        return [
            \Base.fromTarget: "--from-target",
            \Base.matching: "--matching",
            \Base.excluding: "--excluding",
        ]
    }

    private static var autoMappedFlags: [KeyPath<Base, Bool>: String] {
        return [
            \Base.verbose: "--verbose",
        ]
    }

    init(parser: ArgumentParserType) throws {

        func getOptionValue(keyPath: PartialKeyPath<Base>) throws -> String {
            if let short = Base.shortHandOptions[keyPath],
                let value = try? parser.getValue(forOption: "-\(short)") {
                return value
            }
            let long = Base.autoMappedOptions[keyPath]!
            return try parser.getValue(forOption: long)
        }

        func getFlag(keyPath: KeyPath<Base, Bool>) -> Bool {
            if let short = Base.shortHandFlags[keyPath] {
                let value = parser.getFlag("-\(short)")
                if value {
                    return true
                }
            }
            let long = Base.autoMappedFlags[keyPath]!
            return parser.getFlag(long)
        }

        func getCommandType() -> CommandType.Type? {
            while let arg = parser.shift() {
                if let subCommand = Base.shortHandCommands[arg] {
                    return subCommand
                }
                if let subCommand = Base.subCommands.first(where: { $0.name == arg }) {
                    return subCommand
                }
            }
            return nil
        }

        self.fromTarget = try getOptionValue(keyPath: \Base.fromTarget)
        self.matching = try getOptionValue(keyPath: \Base.matching)
        self.excluding = try? getOptionValue(keyPath: \Base.excluding)
        self.verbose = getFlag(keyPath: \Base.verbose)
    }
}

// - MARK: CreateNewFile

extension CreateNewFile {
    private typealias Base = CreateNewFile

    init(arguments: [String]) throws {
        let parser = ArgumentParser(arguments: arguments)
        self.argument = try CreateNewFile.Argument(parser: parser)
    }

    static var name: String {
        return "create-new-file"
    }
}

// - MARK: Hackscode

extension Hackscode {
    private typealias Base = Hackscode

    init(arguments: [String]) throws {
        let parser = ArgumentParser(arguments: arguments)
        self.arguments = try Hackscode.Arguments(parser: parser)
    }

    static var name: String {
        return "hackscode"
    }
}

// - MARK: RemoveBuildFiles

extension RemoveBuildFiles {
    private typealias Base = RemoveBuildFiles

    init(arguments: [String]) throws {
        let parser = ArgumentParser(arguments: arguments)
        self.argument = try RemoveBuildFiles.Argument(parser: parser)
    }

    static var name: String {
        return "remove-build-files"
    }
}

