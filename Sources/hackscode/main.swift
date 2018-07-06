import Foundation
import xcodeproj

let version = "0.1.1"

var keepNames: [String]?
var fromTarget: String?
var matching: String?

let parameters = ProcessInfo.processInfo.arguments

let removeBuildFileAction = "remove-build-files"

for (index, param) in parameters.enumerated() {
    switch param {
    case "--version":
        print(version)
        exit(0)
    case "--from-target":
        fromTarget = parameters[index + 1]
    case "--excluding":
        keepNames = Array(parameters[index + 1].split(separator: ",").map(String.init))
    case "--matching":
        matching = parameters[index + 1]
    default:
        break
    }
}

if !parameters.contains(removeBuildFileAction) {
    print(
    """
    Missing action. Specify one of those.
      \(removeBuildFileAction)
    """
    )
    exit(1)
}

guard let keepNames = keepNames else {
    print("parameter --excluding is missing")
    exit(1)
}

guard let fromTarget = fromTarget else {
    print("parameter --from-target is missing")
    exit(1)
}

guard let matching = matching else {
    print("parameter --matching is missing")
    exit(1)
}

let curdir = FileManager.default.currentDirectoryPath
guard let xcodeprojName = (try? FileManager.default.contentsOfDirectory(atPath: curdir))?
    .first(where: { $0.contains("xcodeproj")}) else {
        print("Could not find xcodeproj in current directory: \(curdir)")
        exit(1)
}

let projectPath = "\(curdir)/\(xcodeprojName)"

var project = try XcodeProj(pathString: projectPath)
var objects = project.pbxproj.objects

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
    if let nameOrPath = fileReference.name, keepNames.contains(where: { nameOrPath.contains($0) }) {
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
