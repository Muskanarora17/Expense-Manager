//
//  DBManager.swift
//  Expense Manager
//
//  Created by Muskan on 19/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit
import FMDB

class DBManager: NSObject {

    static let shared: DBManager = DBManager()
    
    let databaseFileName = "database.sqlite"
     
    var pathToDatabase: String!
     
    var database: FMDatabase!

    
    override init() {
        super.init()
     
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
     
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
     
            if database != nil {
                // Open the database.
                if database.open() {
     
                }
                else {
                    print("Could not open the database.")
                }
            }
        }
     
        return created
    }
}
