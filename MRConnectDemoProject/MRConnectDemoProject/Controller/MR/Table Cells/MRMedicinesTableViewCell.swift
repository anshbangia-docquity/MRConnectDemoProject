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
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    
    static let id = "medicinesTableCell"
    
    func configure(med: String, company: String) {
        medicineNameLabel.text = med
        companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: company)
    }
    
    func configure(med: String, company: String, type: Int16) {
        medicineNameLabel.text = med
        companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: company)
        typeLabel.text = MedicineForms.forms[type]
        switch type {
        case 0, 1:
            typeImage.image = UIImage(named: "pill")
        case 2:
            typeImage.image = UIImage(named: "syrup")
        default:
            typeImage.image = UIImage(named: "injection")
        }
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
