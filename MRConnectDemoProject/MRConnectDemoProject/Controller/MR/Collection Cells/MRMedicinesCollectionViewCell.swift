//
//  MRMedicinesCollectionViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import UIKit

class MRMedicinesCollectionViewCell: UICollectionViewCell {
    
    static let id = "medicinesCollectionCell"
    
    var removeMed: (() -> Void)?
    
    @IBOutlet weak var medicineName: UILabel!
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeMed?()
    }
    
    func configure(medName: String, removeMed: @escaping () -> Void) {
        self.medicineName.text = medName
        self.removeMed = removeMed
    }
    
}
