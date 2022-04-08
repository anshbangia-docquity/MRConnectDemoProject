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
    
    func configure(_ medicine: Medicine) {
        medicineNameLabel.text = medicine.name
        companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: medicine.company)
        typeLabel.text = MedicineForm(rawValue: medicine.type)?.getStr() ?? "NA"
        switch medicine.type {
        case 0, 1:
            typeImage.image = UIImage(named: "pill")
        case 2:
            typeImage.image = UIImage(named: "syrup")
        case 3:
            typeImage.image = UIImage(named: "injection")
        default:
            typeImage.image = nil
        }
    }

}

