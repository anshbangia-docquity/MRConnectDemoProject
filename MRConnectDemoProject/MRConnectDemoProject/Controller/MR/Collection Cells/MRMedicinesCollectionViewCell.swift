//
//  MRMedicinesCollectionViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import UIKit

class MRMedicinesCollectionViewCell: UICollectionViewCell {
    
    static let id = "medicinesCollectionCell"
    
    var removeMed: ((Int) -> Void)?
    var index: Int?
    
    @IBOutlet weak var medicineName: UILabel!
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeMed?(index!)
    }
    
}
