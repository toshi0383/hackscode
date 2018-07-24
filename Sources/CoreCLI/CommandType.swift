//
//  CommandType.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/24.
//

public protocol CommandType {
    func run() throws
    static var shortHandOptions: [PartialKeyPath<Self>: Character] { get }
    static var shortHandFlags: [KeyPath<Self, Bool>: Character] { get }
}

extension CommandType {
    public static var shortHandOptions: [PartialKeyPath<Self>: Character] { return [:] }
    public static var shortHandFlags: [KeyPath<Self, Bool>: Character] { return [:] }
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
