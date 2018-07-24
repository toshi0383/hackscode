//
//  CommandType.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/24.
//

protocol CommandType {
    func run() throws
    static var shortHandOptions: [PartialKeyPath<Self>: Character] { get }
    static var shortHandFlags: [KeyPath<Self, Bool>: Character] { get }
}

extension CommandType {
    static var shortHandOptions: [PartialKeyPath<Self>: Character] { return [:] }
    static var shortHandFlags: [KeyPath<Self, Bool>: Character] { return [:] }
}

struct CommandError: Error, CustomStringConvertible {
    private let message: CustomStringConvertible
    init(_ message: CustomStringConvertible) {
        self.message = message
    }

    var description: String {
        return "\(message)"
    }
}
