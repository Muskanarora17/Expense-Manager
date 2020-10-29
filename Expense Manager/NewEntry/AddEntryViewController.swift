//
//  AddEntryViewController.swift
//  Expense Manager
//
//  Created by Muskan on 15/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit
import FMDB

class AddEntryViewController: UIViewController{
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var categoryLabel: UITextField!
    @IBOutlet weak var amountLabel: UITextField!
    @IBOutlet weak var noteLabel: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let incomeCatArray = ["Salary", "Allowance","Bonus","Gift","Petty Cash", "Other"]
    
    var categories = [ExpenseCategories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        categoryLabel.delegate = self
        dateLabel.delegate = self
        
        collectionView.isHidden = true
        datePicker.isHidden = true
        saveButton.isHidden = false
        categoryLabel.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        categories = DBManager.shared.loadExpenseCat()
        
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        collectionView.reloadData()
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            
            
            collectionView.isHidden = true
            datePicker.isHidden = true
            saveButton.isHidden = false
            categoryLabel.text = ""
            dateLabel.text = ""
            amountLabel.text = ""
            noteLabel.text = ""
            
        case 1:
            
            collectionView.isHidden = true
            datePicker.isHidden = true
            saveButton.isHidden = false
            categoryLabel.text = ""
            dateLabel.text = ""
            amountLabel.text = ""
            noteLabel.text = ""
        //TODO: Save Date, Category, Amount, Note for Expense in DB
        
        default:
            break
        }
    }
    
    @IBAction func pcikedDate(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        dateLabel.text = strDate
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            segmentedControl.selectedSegmentIndex = 1
            
            
            collectionView.reloadData()
            
            if let amount = Int(amountLabel.text!), let date = dateLabel.text {
                
                let cat = DBManager.shared.returnID(table: "incomeCat", for: categoryLabel.text ?? "")
                
                DBManager.shared.insertIncome(income: amount, date: date, note: noteLabel.text ?? "", category: Int(cat))
                
                categoryLabel.text = ""
                dateLabel.text = ""
                amountLabel.text = ""
                noteLabel.text = ""
                print("saved!!")
            }
        }
        
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            
            let cat = DBManager.shared.returnID(table: "expenseCat", for: categoryLabel.text ?? "")
            
            print (cat)
            
            if let amount = Int(amountLabel.text!), let date = dateLabel.text, let note = noteLabel.text ?? "" {
                
                DBManager.shared.insertExpense(expense: amount, date: date, note: note, category: Int(cat) )
                
                print(cat, "saved!!")
                
            }
            categoryLabel.text = ""
            dateLabel.text = ""
            amountLabel.text = ""
            noteLabel.text = ""
            tabBarController?.selectedIndex = 0
            
        }
    }
}


extension AddEntryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            return incomeCatArray.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            cell.categorylabel.text = incomeCatArray[indexPath.row]
            
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            cell.categorylabel.text = categories[indexPath.row].category
            
        }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
}

extension AddEntryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        categoryLabel.text = cell.categorylabel.text
        
        collectionView.isHidden = true
        saveButton.isHidden = false
    }
    
}


extension AddEntryViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryLabel {
            collectionView.isHidden = false
            saveButton.isHidden = true
            datePicker.isHidden = true
        }
        else if textField == dateLabel {
            collectionView.isHidden = true
            saveButton.isHidden = true
            datePicker.isHidden = false
            
        }
        
        else if textField == amountLabel {
            collectionView.isHidden = true
            saveButton.isHidden = false
            datePicker.isHidden = true
            
        }
        
        else if textField == noteLabel {
            collectionView.isHidden = true
            saveButton.isHidden = false
            datePicker.isHidden = true
        }
        
        
    }
    
}


