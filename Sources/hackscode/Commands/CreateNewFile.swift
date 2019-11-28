import CoreCLI
import Foundation
import XcodeProj

struct CreateNewFile: CommandType {

    let argument: Argument

    struct Argument: AutoArgumentsDecodable {
        let toTarget: String
        let filepath: String
        let projectRoot: String?

        // infer group from filepath by default
        let underGroup: String?

        static var shortHandOptions: [PartialKeyPath<Argument>: Character] {
            return [\Argument.toTarget: "t", \Argument.filepath: "f", \Argument.underGroup: "g"]
        }
    }

    // MARK: CommandType

    func run() throws {
        let filepath = argument.filepath
        let fm = FileManager.default

        // Error out if the file already exists.
        if fm.fileExists(atPath: filepath) {
            throw CommandError("file already exists: \(filepath)")
        }

        // Create new file
        if !fm.createFile(atPath: filepath, contents: nil, attributes: nil) {
            throw CommandError("Creating file returned with error status.")
        }

        // add FileReference and BuildFile if needed.
        let groupPath: String = {
            if let underGroup = argument.underGroup {
                // look for existing group
                // error out if not found
                return underGroup
            } else {
                // infer group from filepath
                return filepath.split(separator: "/").dropLast().joined(separator: "/")
            }
        }()

        let xcodeprojPath = try getXcodeprojPath(projectRoot: argument.projectRoot)

        try! editPbxproj(xcodeprojPath: xcodeprojPath) { pbxproj in
        }
    }
}

