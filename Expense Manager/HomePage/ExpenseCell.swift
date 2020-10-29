//
//  ExpenseCell.swift
//  Expense Manager
//
//  Created by Muskan on 15/10/20.
//  Copyright © 2020 Muskan. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {

    @IBOutlet weak var leftimage: UIImageView!
    
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var expenseDate: UILabel!
    @IBOutlet weak var expenseAmount: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
