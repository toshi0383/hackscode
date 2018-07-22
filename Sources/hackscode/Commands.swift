//
//  Commands.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/22.
//

import Foundation
import xcodeproj

protocol CommandType {
    func run() throws
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

protocol AutoCommandOptionDecodable { }

struct RemoveBuildFileCommand: CommandType {
    private let fromTarget: String
    private let keepNames: [String]
    private let matching: String

    struct Option: AutoCommandOptionDecodable {
        let fromTarget: String
        let excluding: String
        let matching: String
    }

    // TODO: init(parser: ArgumentParser, printer: PrinterType = Printer(), commandRunner: CommandRunnerType = CommandRunner) throws {
    init(parser: ArgumentParser) throws {

        let option = try Option(parser: parser)
        fromTarget = option.fromTarget
        keepNames = option.excluding.split(separator: ",").map(String.init)
        matching = option.matching
    }

    func run() throws {
        let curdir = FileManager.default.currentDirectoryPath
        guard let xcodeprojName = (try? FileManager.default.contentsOfDirectory(atPath: curdir))?
            .first(where: { $0.contains("xcodeproj")}) else {
                throw CommandError("Could not find xcodeproj in current directory: \(curdir)")
        }

        let projectPath = "\(curdir)/\(xcodeprojName)"

        let project = try XcodeProj(pathString: projectPath)
        let objects = project.pbxproj.objects

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
            if self.keepNames.contains(where: { nameOrPath.contains($0) }) {
                return false
            }

            return nameOrPath.contains(self.matching)
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

struct CreateAndAddNewFileCommand: CommandType {
    func run() throws {
        throw CommandError("Not implemented yet.")
    }
}
