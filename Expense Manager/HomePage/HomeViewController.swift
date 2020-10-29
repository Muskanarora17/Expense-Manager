//
//  HomeViewController.swift
//  Expense Manager
//
//  Created by Muskan on 15/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit
import FMDB

class HomeViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    
   var expenseDetails = [ExpenseData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       DBManager.shared.createDatabase()
        
        
        tableView.dataSource = self
              
        tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        
        
        
        self.tableView.rowHeight = 75
        
        
        //tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let income = DBManager.shared.returnSum(type: "incomes")
                let expense = DBManager.shared.returnSum(type: "expenses")
                expenseLabel.text = "$\(String(expense))"
                incomeLabel.text = "$\(String(income))"
                
                currentBalanceLabel.text = "$\(String(income - expense))"
        expenseDetails = DBManager.shared.loadExpenses()
        tableView.reloadData()
    }


}

extension HomeViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        expenseDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as! ExpenseCell
        
        let id = Int32(expenseDetails[indexPath.row].expense)!
        
        
        cell.expenseLabel.text = DBManager.shared.returnCat(for: id)
        cell.expenseAmount.text = "$\(String(expenseDetails[indexPath.row].expenseAmount))"
        //cell.leftimage.image = UIImage(named: expenseDetails[indexPath.row].image)
        cell.noteLabel.text = expenseDetails[indexPath.row].note
        
        cell.expenseDate.text = expenseDetails[indexPath.row].expenseDate

        
        return cell
            
            
            
            
        
        
    }
    
    
    
}
