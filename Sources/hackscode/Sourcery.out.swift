//
//  Sourcery.out.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/22.
//

// - MARK: ArgumentParser

protocol ArgumentParserType: class {
    var remainder: [String] { get set }
    func getValue(forOption option: String) throws -> String
}

extension ArgumentParserType {

    @discardableResult
    func shift() -> String? {
        if remainder.isEmpty {
            return nil
        }
        return remainder.removeFirst()
    }

    @discardableResult
    func shift(at index: Int) -> String? {
        if remainder.isEmpty {
            return nil
        }

        if index < remainder.count {
            return remainder.remove(at: index)
        } else {
            return nil
        }
    }

    @discardableResult
    func shiftAll() -> [String] {
        let r = remainder
        remainder = []
        return r
    }

}

/// Default ArgumentParser
final class ArgumentParser: ArgumentParserType {

    func getValue(forOption option: String) throws -> String {

        guard let index = parser.remainder.index(of: option) else {
            throw CommandError("missing option \(option)")
        }
        if index + 1 >= parser.remainder.count {
            throw CommandError("missing value for option \(option)")
        }
        shift(at: index)
        return shift(at: index)!
    }

    var remainder: [String]

    /// - parameter arguments: ProcessInfo.processInfo.arguments
    init(arguments: [String]) {
        self.remainder = arguments
    }
}

// - MARK: Initializers

extension RemoveBuildFileCommand.Option {
    init(parser: ArgumentParser) throws {
        self.fromTarget = try parser.getValue(forOption: "--from-target")
        self.excluding = try parser.getValue(forOption: "--excluding")
        self.matching = try parser.getValue(forOption: "--matching")
    }
}
