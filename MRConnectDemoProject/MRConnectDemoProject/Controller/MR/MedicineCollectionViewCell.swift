//
//  MedicineCollectionViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 08/02/22.
//

import UIKit

class MedicineCollectionViewCell: UICollectionViewCell {
    
    static let id = "medicineCollectionCell"
    
    var removeMed: ((Int) -> Void)?
    var index: Int?
    
    @IBOutlet weak var medicineName: UILabel!
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeMed?(index!)
    }
    
}
