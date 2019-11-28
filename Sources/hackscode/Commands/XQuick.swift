import CoreCLI
import Foundation
import ShellOut

struct Xquick: CommandType {

    let argument: Argument

    struct Argument: AutoArgumentsDecodable {

        // sourcery: shift
        let filename: String
        let revert: Bool
        static var shortHandFlags: [KeyPath<Argument, Bool>: Character] {
            return [\Argument.revert: "r"]
        }
    }

    // MARK: CommandType

    func run() throws {
        let filename = argument.filename
        try shellOut(to: pathForShellScript(named: "xquick.sh"),
                                  arguments: argument.revert ? [filename, "r"] : [filename])
        exit(0)
    }
}

