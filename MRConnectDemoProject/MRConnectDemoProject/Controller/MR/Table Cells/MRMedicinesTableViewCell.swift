//
//  MRMedicinesTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 30/01/22.
//

import UIKit

class MRMedicinesTableViewCell: UITableViewCell {

    @IBOutlet weak var medicineNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    static let id = "medicinesTableCell"
    
    func configure(med: String, company: String) {
        medicineNameLabel.text = med
        companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: company)
    }

}

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
