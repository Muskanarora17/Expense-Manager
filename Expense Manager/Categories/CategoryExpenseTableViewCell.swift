//
//  CategoryExpenseTableViewCell.swift
//  Expense Manager
//
//  Created by Muskan on 16/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit

class CategoryExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
