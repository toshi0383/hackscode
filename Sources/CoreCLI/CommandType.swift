//
//  CommandType.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/24.
//

public protocol CommandType {
    func run() throws
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
