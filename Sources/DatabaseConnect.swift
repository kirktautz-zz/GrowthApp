//
//  DatabaseConnect.swift
//  mongoProject
//
//  Created by Kirk Tautz on 6/18/17.
//
//

import Foundation
import HeliumLogger
import LoggerAPI
import MongoKitten
import SwiftyJSON

struct DatabaseConnect {
    
    public func connectToDB() throws -> Database {
        
        let server = try Server("mongodb://kirk:888323@localhost:27017")
        let databaseToConnect = server["dev"]
        
        return databaseToConnect
        
    }
    
}
