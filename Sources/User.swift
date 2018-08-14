//
//  User.swift
//  mongoProject
//
//  Created by Kirk Tautz on 6/18/17.
//
//

import Foundation
import Kitura
import Cryptor
import HeliumLogger
import LoggerAPI
import MongoKitten

struct User {
    
    // Make connection to the database server and return the database
    private let connectedDB = DatabaseConnect()
    private var db: Database? {
        do {
            return try connectedDB.connectToDB()
        } catch {
            return nil
        }
    }
    
    // Create a new user in the database
    public func createUser(name: String, pass: String, completion: (String) -> ()) throws -> Bool {
        
        // Get an array of all current usernames
        let currentUsers = try retrieveUsers()
        
        // Check that the username being created
        // does not already exist
        for username in currentUsers {
            if username == name {
                print("Username already exists")
                completion("Username already exists")
                return false
            }
        }
        
        // connect to the user collection
        guard let userColl = db?["user"] else { return false }
        
        // Create salt from reversed username
        let salt = String(name.characters.reversed())
        
        // encrypt the password to create
        // before sending to database
        let encryptedPass = password(from: pass, salt: salt)
        
        // create a document to be sent to the database
        let userDoc: Document = ["username" : name, "password" : encryptedPass, "salt" : salt]
        
        // try saving the new user document to the database
        do {
            try userColl.insert(userDoc)
            print("Added")
            completion("Created user!")
            return true
        } catch {
            print("Could not add document")
            completion("Could not create user")
            return false
        }
        
    }
    
    // log user into app
    public func loginUser(name: String, pass: String, completion: (String) -> ()) throws -> Bool {
        
        // Get an array of all current usernames
        let currentUsers = try retrieveUsers()
        
        // check to make sure username entered 
        // exists in the database
        if !currentUsers.contains(name) {
            print("Username not found")
            completion("User name not found")
        }
        
        // connect to the "user" database
        guard let userColl = db?["user"] else { return false }
        
        // set a query with the username and find the 
        // user object
        let userQuery: Query = ["username" : name]
        guard let foundUser = try userColl.findOne(userQuery) else { return false }
        
        // convert database results to dictionary
        let userDict = foundUser.dictionaryRepresentation
        
        // get encrypted password and salt from database,
        // create a temp encrypted password 
        // and compare databse vs temp
        if let encPass = userDict["password"] as? String,
            let salt = userDict["salt"] as? String {
            
            let decPass = password(from: pass, salt: salt)
            
            if decPass != encPass {
                print("WRONG PASSWORD")
                completion("wrong password")
                return false
            } else {
                completion("WELCOME")
                print("WELCOME!")
                return true
            }
            
        } else {
            return false
        }
        
        
        

    }
    
    // function to encrypt password
    private func password(from str: String, salt: String) -> String {
        let key = PBKDF.deriveKey(fromPassword: str, salt: salt, prf: .sha512, rounds: 250_000, derivedKeyLength: 64)
        
        return CryptoUtils.hexString(from: key)
    }
    
    // function to retrieve all usernames
    private func retrieveUsers() throws -> [String] {
        guard let userColl = db?["user"] else { return [String]() }
        
        let foundUsers = try userColl.find()
        var names = [String]()
        
        for users in foundUsers {
            let userDict = users.dictionaryRepresentation
            
            if let user = userDict["username"] as? String {
                names.append(user)
            }
            
        }
        
        return names
    }
    
}
