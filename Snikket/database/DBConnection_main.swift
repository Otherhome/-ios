//
// DBConnection_main.swift
//
// Siskin IM
// Copyright (C) 2020 "Tigase, Inc." <office@tigase.com>
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
import Shared

extension DBConnection {
    public static let main: DBConnection = {
        if let dbURL = mainDbURL() {
            if FileManager.default.fileExists(atPath: dbURL.path) || createIfNotExist {
                return try! DBConnection.initialize(dbPath: dbURL.path)
            } else {
                return try! DBConnection.initialize(dbPath: ":memory:")
            }
        } else {
            // URL이 nil일 경우
            print("Warning: mainDbURL() returned nil. Using in-memory database.")
            return try! DBConnection.initialize(dbPath: ":memory:")
        }
    }()
}

