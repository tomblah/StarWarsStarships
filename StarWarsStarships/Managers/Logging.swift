//
//  Logging.swift
//  StarWarsStarships
//
//  Created by Thomas Argue on 26/11/21.
//

import Foundation

import os

private let subsystem = AppManager.sharedInstance.bundleIdentifier

enum Log {
    static let api = OSLog(subsystem: subsystem, category: "api")
    static let system = OSLog(subsystem: subsystem, category: "system")
    static let user = OSLog(subsystem: subsystem, category: "user")
    static let layout = OSLog(subsystem: subsystem, category: "layout")
}
