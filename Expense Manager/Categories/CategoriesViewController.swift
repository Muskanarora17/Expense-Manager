//
//  CategoriesViewController.swift
//  Expense Manager
//
//  Created by Muskan on 16/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit


struct ExpenseCategories {
    
    var category: String!
    
}

class CategoriesViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var categories: [ExpenseCategories]?
    
    var searchActive : Bool = false

    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        categories = DBManager.shared.loadExpenseCat()
        
        tableView.reloadData()
    }
   
    @IBAction func addcategories(_ sender: Any) {
        
        var textField = UITextField()
         let alert = UIAlertController(title: "Add New Expense Category", message: "", preferredStyle: .alert )
               let action = UIAlertAction(title: "Add Type", style: .default) { (action) in
                if let text = textField.text {
                    DBManager.shared.insertExpenseCategory(category: text)
                    self.categories = DBManager.shared.loadExpenseCat()
                    self.tableView.reloadData()
                }
                   
               }
               alert.addAction(action)
               alert.addTextField { (field) in
                   textField = field
                   textField.placeholder = "Add expense category"
               }
               
               present(alert, animated: true, completion: nil)
        
    }
}

//MARK: - TableView DtaSource Methods

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
        }
        
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if(searchActive){
        cell.textLabel?.text = filtered[indexPath.row]
        }
        else {
            cell.textLabel?.text = categories?[indexPath.row].category ?? ""
        }
        
        return cell
    }
    
    
    
}

//MARK: - TableView Delegate Methods

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "expenses") as? ExpensesViewController {
        
            vc.expenseCategory = tableView.cellForRow(at: indexPath)?.textLabel?.text
 
            tabBarController?.show(vc, sender: self)
            //tabBarController?.showDetailViewController(vc, sender: self)
        
    }
}
}

//MARK: - SearchBar Delegate Methods

extension CategoriesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        filtered = categoryArray.filter({ (text) -> Bool in
//            let tmp: NSString = text as NSString
//            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
//    }
    
    
    
    
}
