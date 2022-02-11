//
//  MRDoctorsCollectionViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import UIKit

class MRDoctorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var removeDoctor: ((Int) -> Void)?
    var index: Int?
    
    static let id = "doctorsCollectionCell"
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeDoctor?(index!)
    }
    
    func configure(with img: UIImage) {
        profileImage.image = img
    }
    
}
