//
//  ArgumentParser.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/24.
//

protocol ArgumentParserType: class {
    var remainder: [String] { get set }
    func getValue(forOption option: String) throws -> String
    func getFlag(_ flag: String) -> Bool
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

    func getFlag(_ flag: String) -> Bool {

        if let index = parser.remainder.index(of: flag) {
            shift(at: index)
            return true
        } else {
            return false
        }
    }

    var remainder: [String]

    /// - parameter arguments: ProcessInfo.processInfo.arguments
    init(arguments: [String]) {
        self.remainder = arguments
    }
}
