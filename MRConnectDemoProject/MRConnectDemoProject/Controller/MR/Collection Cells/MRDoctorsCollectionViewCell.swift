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
    
    func configure(index: Int, removeDoctor: @escaping (Int) -> Void ) {
        profileImage.image = UIImage(systemName: "person.circle")
        self.index = index
        self.removeDoctor = removeDoctor
    }
    
    func configImg(imgData: Data) {
        DispatchQueue.main.async {
            self.profileImage.image = UIImage(data: imgData)
        }
    }
    
}
