//
//  Utilities.swift
//  hackscode
//
//  Created by Toshihiro Suzuki on 2018/07/28.
//

import CoreCLI
import Foundation
import xcodeproj

func getXcodeprojPath(projectRoot: String? = nil) throws -> String {
    let curdir = projectRoot ?? FileManager.default.currentDirectoryPath
    guard let xcodeprojName = try FileManager.default.contentsOfDirectory(atPath: curdir)
        .first(where: { $0.contains("xcodeproj")}) else {
            throw CommandError("Could not find xcodeproj in current directory: \(curdir)")
    }
    return "\(curdir)/\(xcodeprojName)"
}

func editPbxproj(xcodeprojPath: String, _ edit: (PBXProj) throws -> ()) throws {
    let project = try XcodeProj(pathString: xcodeprojPath)
    let pbxproj = project.pbxproj
    try edit(pbxproj)
    try! pbxproj.write(pathString: "\(xcodeprojPath)/project.pbxproj", override: true)
}
