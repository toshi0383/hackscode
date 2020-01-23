import CoreCLI
import Foundation
import XcodeProj

struct DumpBuildFiles: CommandType {

    let argument: Argument

    struct Argument: AutoArgumentsDecodable {
        let targets: String?
        let projectRoot: String?

        static var shortHandOptions: [PartialKeyPath<Argument>: Character] {
            return [\Argument.targets: "t", \Argument.projectRoot: "p"]
        }
    }

    // MARK: CommandType

    func run() throws {
        let xcodeprojPath = try getXcodeprojPath(projectRoot: argument.projectRoot)
        let project = try XcodeProj(pathString: xcodeprojPath)
        let pbxproj = project.pbxproj

        let targetsToDump: [PBXNativeTarget] = {
            if let targetsArg = argument.targets {
                let targets = targetsArg.split(separator: ",").map(String.init)
                return pbxproj.nativeTargets.filter { targets.contains($0.name) }
            } else {
                return pbxproj.nativeTargets
            }
        }()

        let sorted = targetsToDump.sorted { $0.name < $1.name }

        for (i, target) in sorted.enumerated() {
            print("## \(i) \(target.name)")
            let sourcesBuildPhase = try! target.sourcesBuildPhase()!
            let sourcefiles = sourcesBuildPhase.files!
            if sourcefiles.isEmpty {
                print("no source files found")
                continue
            }

            for file in sourcefiles {
                if let fileElement = file.file {
                    let nameOrPath = fileElement.name ?? fileElement.path!
                    print("  \(nameOrPath)")
                }
            }

            if i < targetsToDump.count - 1 {
                print()
            }
        }
    }
}

