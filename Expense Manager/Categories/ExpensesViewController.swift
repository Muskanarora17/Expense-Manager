//
//  ExpensesViewController.swift
//  Expense Manager
//
//  Created by Muskan on 16/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit

class ExpensesViewController: UIViewController, UITableViewDataSource {
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var expenseCategory: String?
    var expenses: [ExpenseData]!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Here are your monthly expenses for \(expenseCategory!)"
        
        let id = DBManager.shared.returnID(table: "expenseCat", for: "\(expenseCategory!)")
        
        expenses = DBManager.shared.loadCatExpenses(id: Int(id))
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CategoryExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: "expensecell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (expenses != nil) ? expenses.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expensecell", for: indexPath) as! CategoryExpenseTableViewCell
        
        let currentIndex = expenses[indexPath.row]
        
        cell.expenseAmount.text = String(currentIndex.expenseAmount)
        cell.expenseDate.text = currentIndex.expenseDate
        cell.expenseLabel.text = currentIndex.note
        
        return cell
    }
    
   

}
