//
//  RemoveBuildFiles.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/22.
//

import CoreCLI
import Foundation
import xcodeproj

struct RemoveBuildFiles: CommandType {

    let argument: Argument

    struct Argument: AutoArgumentsDecodable {
        let fromTarget: String
        let matching: String
        let excluding: String?
        let projectRoot: String?
        let verbose: Bool

        static var shortHandOptions: [PartialKeyPath<Argument>: Character] {
            return [\Argument.fromTarget: "t", \Argument.excluding: "e", \Argument.matching: "m"]
        }

        static var shortHandFlags: [KeyPath<Argument, Bool>: Character] {
            return [\.verbose: "V"]
        }
    }

    // MARK: CommandType

    func run() throws {
        let xcodeprojPath = try getXcodeprojPath(projectRoot: argument.projectRoot)
        try editPbxproj(xcodeprojPath: xcodeprojPath) { pbxproj in

            let fromTarget = argument.fromTarget
            let keepNames = argument.excluding?.split(separator: ",").map(String.init)
            let matching = argument.matching

            let target = pbxproj.nativeTargets
                .first { $0.name == fromTarget }!

            let sourcesBuildPhase = try! target.sourcesBuildPhase()!

            let shouldDelete: (PBXFileElement) -> Bool = { fileElement in
                let nameOrPath = fileElement.name ?? fileElement.path!
                if let keepNames = keepNames, keepNames.contains(where: { nameOrPath.contains($0) }) {
                    return false
                }

                if nameOrPath.range(of: "(.*)\(matching)(.*)", options: .regularExpression) != nil {
                    return true
                } else {
                    return false
                }
            }

            let buildFilesToDelete: [PBXBuildFile] = sourcesBuildPhase
                .files!
                .compactMap {

                    if let fileElement = $0.file, shouldDelete(fileElement) {
                        return $0
                    } else {
                        return nil
                    }
            }

            // Delete from buildFiles
            for (i, buildFile) in sourcesBuildPhase.files!.enumerated().reversed() {
                if buildFilesToDelete.contains(buildFile) {
                    sourcesBuildPhase.files!.remove(at: i)
                }
            }
        }
    }
}

