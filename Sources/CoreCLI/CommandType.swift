//
//  CommandType.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/24.
//

public protocol TopLevelCommandType {
    static var version: String { get }
}

public protocol CommandType {
    static var name: String { get }
    var shorthandName: String? { get }
    func run() throws

    // TODO: init(parser: ArgumentParser, printer: PrinterType = Printer(), commandRunner: CommandRunnerType = CommandRunner) throws {
    init(arguments: [String]) throws
}

extension CommandType {
    public var shorthandName: String? { return nil }
}

public struct CommandError: Error, CustomStringConvertible {
    private let message: CustomStringConvertible
    public init(_ message: CustomStringConvertible) {
        self.message = message
    }

    public var description: String {
        return "\(message)"
    }
}
