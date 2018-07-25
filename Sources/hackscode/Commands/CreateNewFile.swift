//
//  CreateNewFile.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/22.
//

import CoreCLI
import Foundation
import xcodeproj

struct CreateNewFile: CommandType {

    let argument: Argument

    struct Argument: AutoArgumentsDecodable {
        let toTarget: String
        let filepath: String
        let underGroup: String

        static var shortHandOptions: [PartialKeyPath<Argument>: Character] {
            return [\Argument.toTarget: "t", \Argument.filepath: "f", \Argument.underGroup: "g"]
        }
    }

    // MARK: CommandType

    func run() throws {
        throw CommandError("Not implemented yet.")
    }
}

