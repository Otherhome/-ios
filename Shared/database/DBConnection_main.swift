//
// DBConnection_main.swift
//
// Siskin IM
// Copyright (C) 2019 "Tigase, Inc." <office@tigase.com>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. Look for COPYING file in the top folder.
// If not, see https://www.gnu.org/licenses/.
//

import Foundation

extension DBConnection {

    public static func mainDbURL() -> URL? {
        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.adelaideinside.otherhome.ios.Shared") {
            return containerURL.appendingPathComponent("snikket_main.db")
        } else {
            return nil
        }
    }
    
    public private(set) static var createIfNotExist: Bool = false;
        
    public static func migrateToGroupIfNeeded() throws {
            guard let dbURL = mainDbURL() else {
                print("Error: Unable to get the container URL.")
                return
            }

            if !FileManager.default.fileExists(atPath: dbURL.path) {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                if let documentDirectory = paths.first {
                    let oldPath = documentDirectory.appending("/mobile_messenger1.db")
                    if FileManager.default.fileExists(atPath: oldPath) {
                        do {
                            try FileManager.default.moveItem(atPath: oldPath, toPath: dbURL.path)
                        } catch {
                            print("Error: Unable to move the file - \(error.localizedDescription)")
                            throw error
                        }
                    }
                }
            }
        
        createIfNotExist = true;
    }
    
    public static func initialize(dbPath: String) throws -> DBConnection {
        let conn = try DBConnection(dbPath: dbPath);
        try? conn.execute("PRAGMA busy_timeout = 2")
        try DBSchemaManager(dbConnection: conn).upgradeSchema();
        return conn;
    }
}
