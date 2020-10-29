//
//  DBManager.swift
//  Expense Manager
//
//  Created by Muskan on 19/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import Foundation
import FMDB


class DBManager : NSObject {
    
    static let shared: DBManager = DBManager()

    let databaseFileName = "ExpenseManagerDatabase.sqlite"
     
    var pathToDatabase: String!
     
    var database: FMDatabase!
    
override init() {
    super.init()
 
    let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
    pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    print(pathToDatabase!)
}
    
    func createDatabase() -> Bool {
          var created = false
          
          if !FileManager.default.fileExists(atPath: pathToDatabase) {
              database = FMDatabase(path: pathToDatabase!)
              
              if database != nil {
                  // Open the database.
                  if database.open() {
                    
                    let createIncomeCategoryTableQuery = "create table incomeCat (category text not null, cid integer primary key)"
                    
                      let createIncomesTableQuery = "create table incomes (amount integer not null, date text not null, note text, catID integer not null, FOREIGN KEY (catID) references incomes (id))"
                    
                    let createExpenseCatTableQuery = "create table expenseCat (category text not null, cid integer primary key)"
                    
                    let createExpensesTableQuery = "create table expenses (amount integer not null, date text not null, note text, catID integer not null, FOREIGN KEY (catID) references expenses (id))"
                      
                      do {
                          try database.executeUpdate(createIncomesTableQuery, values: nil)
                        
                        try database.executeUpdate(createIncomeCategoryTableQuery, values: nil)
                        
                        try database.executeUpdate(createExpenseCatTableQuery, values: nil)
                        
                        try database.executeUpdate(createExpensesTableQuery, values: nil)
                        
                          created = true
                      }
                      catch {
                          print("Could not create table.")
                          print(error.localizedDescription)
                      }
                      
                      database.close()
                  }
                  else {
                      print("Could not open the database.")
                  }
              }
          }
          
          return created
      }
      
      
      func openDatabase() -> Bool {
          if database == nil {
              if FileManager.default.fileExists(atPath: pathToDatabase) {
                  database = FMDatabase(path: pathToDatabase)
              }
          }
          
          if database != nil {
              if database.open() {
                  return true
              }
          }
          
          return false
      }

    //MARK: - Insert and Load ExpenseCat
      
      func insertExpenseCategory (category: String) {
          
          if openDatabase() {
              
              let query = "insert into expenseCat (category) values ('\(category)')"
              
              if !database.executeStatements(query) {
                                      print("Failed to insert initial data into the database.")
                                      print(database.lastError(), database.lastErrorMessage())
                                  }
              
              database.close()
          }
          
      }
      
      func loadExpenseCat() -> [ExpenseCategories]! {
          var categories: [ExpenseCategories]!

          if openDatabase() {
              let query = "select * from expenseCat order by category asc"


              do {
                  print(database!)
                  let results = try database.executeQuery(query, values: nil)

                  while results.next() {


                      let category = ExpenseCategories(category: results.string(forColumn: "category"))

                      if categories == nil {
                          categories = [ExpenseCategories]()
                      }

                      categories.append(category)
                  }
              }
              catch {
                  print(error.localizedDescription)
              }

              database.close()
          }

          return categories
      }
      
      
    
  //MARK: - Insert and Load Expenses
    
    func insertExpense (expense: Int, date: String, note: String, category: Int) {
        
        if openDatabase() {
            
            let query = "insert into expenses (amount, date, note, catID) values ('\(expense)','\(date)','\(note)', \(category))"
            
            if !database.executeStatements(query) {
                                    print("Failed to insert initial data into the database.")
                                    print(database.lastError(), database.lastErrorMessage())
                                }
            
            database.close()
        }
        
    }
    
    
    func loadExpenses() -> [ExpenseData] {
        var expenses = [ExpenseData]()
     
        if openDatabase() {
            let query = "select * from expenses order by date asc"
     
            do {
                print(database!)
                let results = try database.executeQuery(query, values: nil)
     
                while results.next() {
                    
                    let expense = ExpenseData(expense: results.string(forColumn: "catID")!, expenseDate: results.string(forColumn: "date")!, image: "airplane", expenseAmount: Int(results.int(forColumn: "amount" )), note: results.string(forColumn: "note")!)
     
                    if expenses == nil {
                        expenses = [ExpenseData]()
                    }
     
                    expenses.append(expense)
                }
            }
            catch {
                print(error.localizedDescription)
            }
     
            database.close()
        }
     
        return expenses
    }
    
    
    func loadCatExpenses(id: Int) -> [ExpenseData]! {
        var expenses: [ExpenseData]!
     
        if openDatabase() {
            let query = "select * from expenses where catID = ?"
     
            do {
                print(database!)
                let results = try database.executeQuery(query, values: ["\(id)"])
     
                while results.next() {
                    
                    let expense = ExpenseData(expense: results.string(forColumn: "catID")!, expenseDate: results.string(forColumn: "date")!, image: "airplane", expenseAmount: Int(results.int(forColumn: "amount")), note: results.string(forColumn: "note")!)
     
                    if expenses == nil {
                        expenses = [ExpenseData]()
                    }
     
                    expenses.append(expense)
                }
            }
            catch {
                print(error.localizedDescription)
            }
     
            database.close()
        }
     
        return expenses
    }
    
  
    
    
    //MARK: - Insert and Load Income
    
    func insertIncome (income: Int, date: String, note: String, category: Int) {
        
        if openDatabase() {
            
            let query = "insert into incomes (amount, date, note, catID) values ('\(income)','\(date)','\(note)', \(category))"
            
            if !database.executeStatements(query) {
                                    print("Failed to insert initial data into the database.")
                                    print(database.lastError(), database.lastErrorMessage())
                                }
            
            database.close()
        }
        
    }
       
    
    
    //MARK: - Insert and Load IncomeCat

    
    
 //MARK: - Misc.
    
    func returnSum(type: String) -> Int32 {
        
        var final =  Int32()
        var total: Int32 = 0
        
        if DBManager.shared.openDatabase() {
            let query = "select amount from \(type)"
              
            do {
            let result = try database.executeQuery(query, values: nil)
                
                while result.next() {
                final = result.int(forColumn: "amount")
                total = total + final
                }
                print(total)
            }
            catch {
                print(error.localizedDescription)
                
            }
            
            database.close()
        }
        return total
       
        
    }
    
    func returnCatSum(id: Int32) -> Int32 {
        
        var final =  Int32()
        var total: Int32 = 0
        
        if DBManager.shared.openDatabase() {
            let query = "select amount from expenses where catID = \(id)"
              
            do {
            let result = try database.executeQuery(query, values: nil)
                
                while result.next() {
                final = result.int(forColumn: "amount")
                total = total + final
                }
                print(total)
            }
            catch {
                print(error.localizedDescription)
                
            }
            
            database.close()
        }
        return total
       
        
    }
    
    
    func returnID(table: String, for text: String) -> Int32 {
        
        var final: Int32?
        
        if DBManager.shared.openDatabase() {
            let query = "select cid from \(table) where category = '\(text)'"
              
            do {
            let result = try database.executeQuery(query, values: nil)
                
                while result.next() {
                final = result.int(forColumn: "cid")
                print(final!)
                }
            }
            catch {
                print(error.localizedDescription)
                
            }
            
            database.close()
        }
        return final ?? 0
       
    }
    
    func returnCat(for id: Int32) -> String {
             
        var final: String?
        
        if DBManager.shared.openDatabase() {
            let query = "select category from expenseCat where cid = '\(id)'"
              
            do {
            let result = try database.executeQuery(query, values: nil)
                
                while result.next() {
                final = result.string(forColumn: "category")
                print(final!)
                }
            }
            catch {
                print(error.localizedDescription)
                
            }
            
            database.close()
        }
        return final ?? ""
       
    }
    
}


