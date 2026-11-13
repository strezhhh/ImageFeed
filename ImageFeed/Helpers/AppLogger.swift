//
//  AppLogger.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 12.11.2026.
//

import Foundation
import Logging

enum Apploger {
    static let logger = Logger(label: "ru.strezhhh.imageFeed")
    
    static func error(
        _ message: String,
        _ error: Error? = nil,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger.error(
"""
\(message). Error: \(error?.localizedDescription ?? "отсутствует"). \(fileName)/\(function)/\(line)

"""
        )
    }
    
    static func info(
        _ message: String,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) {
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        logger.info(
"""
\(message). \(fileName)/\(function)/\(line)

"""
        )
    }
}
