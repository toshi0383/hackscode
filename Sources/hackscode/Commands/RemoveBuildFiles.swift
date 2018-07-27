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
        let curdir = argument.projectRoot ?? FileManager.default.currentDirectoryPath
        guard let xcodeprojName = (try? FileManager.default.contentsOfDirectory(atPath: curdir))?
            .first(where: { $0.contains("xcodeproj")}) else {
                throw CommandError("Could not find xcodeproj in current directory: \(curdir)")
        }

        let projectPath = "\(curdir)/\(xcodeprojName)"

        let project = try XcodeProj(pathString: projectPath)
        let objects = project.pbxproj.objects

        let fromTarget = argument.fromTarget
        let keepNames = argument.excluding?.split(separator: ",").map(String.init)
        let matching = argument.matching

        let target = objects
            .nativeTargets
            .first { $0.value.name == fromTarget }!
            .value

        let sourcesBuildPhase = target
            //    .sourcesBuildPhase() Fixme: not working correctly
            .buildPhasesReferences
            .compactMap {
                objects.buildPhases[$0] as? PBXSourcesBuildPhase
            }
            .first!

        let shouldDelete: (PBXFileReference) -> Bool = { fileReference in
            let nameOrPath = fileReference.name ?? fileReference.path!
            if let keepNames = keepNames, keepNames.contains(where: { nameOrPath.contains($0) }) {
                return false
            }

            return nameOrPath.contains(matching)
        }

        let buildFilesToDelete: [PBXBuildFile] = sourcesBuildPhase
            .fileReferences
            .compactMap { objects.buildFiles[$0] }
            .compactMap {
                if let fileReference = objects.fileReferences[$0.fileReference!], shouldDelete(fileReference) {
                    return $0
                } else {
                    return nil
                }
        }

        // Delete from buildFiles
        buildFilesToDelete
            .forEach {
                if let index = objects.buildFiles.index(forKey: $0.reference) {
                    objects.buildFiles.remove(at: index)
                }
        }

        //try! project.write(pathString: projectPath, override: true)
        try! project.pbxproj.write(pathString: "\(projectPath)/project.pbxproj", override: true)
    }
}

