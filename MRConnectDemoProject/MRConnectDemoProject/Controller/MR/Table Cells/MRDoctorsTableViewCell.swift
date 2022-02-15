//
//  MRDoctorsTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/01/22.
//

import UIKit

class MRDoctorsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    static let id = "doctorsTableCell"
    
    func configure(name: String, spec: Int16) {
        nameLabel.text = "Dr. \(name)"
        specLabel.text = Specialities.specialities[spec]
        profileImage.image = UIImage(systemName: "person.circle")
    }
    
    func configImg(imgData: Data) {
        DispatchQueue.main.async {
            self.profileImage.image = UIImage(data: imgData)
        }
    }

}
