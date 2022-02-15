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
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var officeLabel: UILabel!
    
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
    
    func configure(name: String, spec: Int16, email: String, contact: String, office: String) {
        nameLabel.text = "Dr. \(name)"
        specLabel.text = Specialities.specialities[spec]
        emailLabel.text = email
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: contact)
        var myOffice = "Not specified"
        if !office.isEmpty {
            myOffice = office
        }
        officeLabel.text = MyStrings.office + ": " + myOffice
        profileImage.image = UIImage(systemName: "person.circle")
    }

}
