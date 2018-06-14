//
//  Logger.swift
//  Phantom
//
//  Created by Alberto Cantallops on 14/06/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
import CleanroomLogger

class Logger {
    static var directory: URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentationDirectory, in: .userDomainMask)[0].appendingPathComponent("logs")
    }

    static var logsFileURLs: [URL] {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            return []
        }
    }

    static var logsFileURL: URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return logsFileURLs.filter({
                $0.lastPathComponent.hasSuffix(".log")
            }).sorted { (url1, url2) -> Bool in
                let fileName1 = url1.lastPathComponent.replacing(".log", "")
                let fileName2 = url2.lastPathComponent.replacing(".log", "")
                let date1 = dateFormatter.date(from: fileName1)!
                let date2 = dateFormatter.date(from: fileName2)!
                return date1.compare(date2) == ComparisonResult.orderedDescending
            }.first
    }

    static func enable() {
        var configs = [LogConfiguration]()
        let fileCfg = RotatingLogFileConfiguration(minimumSeverity: .info,
                                                   daysToKeep: 7,
                                                   directoryPath: directory.path,
                                                   formatters: [StandardLogFormatter()])

        try? fileCfg.createLogDirectory()

        configs.append(fileCfg)

        Log.enable(configuration: configs)
    }


    enum Severity {
        case info
        case warning
        case error
    }

    static func log(
        _ msg: String,
        severity: Severity = .info,
        function: String = #function,
        filePath: String = #file,
        fileLine: Int = #line
    ) {
        switch severity {
        case .info:
            Log.info?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
        case .warning:
            Log.warning?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
        case .error:
            Log.error?.message(msg, function: function, filePath: filePath, fileLine: fileLine)
        }
    }

    static func log(_ error: Error, function: String = #function, filePath: String = #file, fileLine: Int = #line) {
        let description = (error as NSError).debugDescription
        log(description, severity: .error, function: function, filePath: filePath, fileLine: fileLine)
    }

}
