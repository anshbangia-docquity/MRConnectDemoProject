//
//  DoctorCollectionViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 07/02/22.
//

import UIKit

class DoctorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var removeDoctor: ((Int) -> Void)?
    var index: Int?
    
    static let id = "doctorCollectionCell"
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeDoctor?(index!)
    }
    
    func configure(with img: UIImage) {
        profileImage.image = img
    }
    
}
