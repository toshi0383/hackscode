//
//  Sourcery.out.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/22.
//

// - MARK: Initializers

extension RemoveBuildFileCommand.Argument {
    private typealias Base = RemoveBuildFileCommand.Argument

    private static var autoMappedOptions: [PartialKeyPath<Base>: String] {
        return [
            \Base.fromTarget: "--from-target",
            \Base.excluding: "--excluding",
            \Base.matching: "--matching"
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

        self.fromTarget = try getOptionValue(keyPath: \Base.fromTarget)
        self.matching = try getOptionValue(keyPath: \Base.matching)
        self.excluding = try? getOptionValue(keyPath: \Base.excluding)
        self.verbose = parser.getFlag("--verbose")
    }
}
