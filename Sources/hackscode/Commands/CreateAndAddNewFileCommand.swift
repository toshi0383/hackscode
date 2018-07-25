//
//  CreateAndAddNewFileCommand.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/22.
//

import CoreCLI
import Foundation
import xcodeproj

// sourcery: CommandType
struct CreateNewFile: CommandType {

    let argument: Argument

    init(arguments: [String]) throws {
        let parser = ArgumentParser(arguments: arguments)
        self.argument = try Argument(parser: parser)
    }

    // sourcery: AutoArgumentsDecodable
    struct Argument: AutoArgumentsDecodable {
        let toTarget: String
        let filepath: String
        let underGroup: String

        static var shortHandOptions: [PartialKeyPath<Argument>: Character] {
            return [\Argument.toTarget: "t", \Argument.filepath: "f", \Argument.underGroup: "g"]
        }
    }

    func run() throws {
        throw CommandError("Not implemented yet.")
    }
}

