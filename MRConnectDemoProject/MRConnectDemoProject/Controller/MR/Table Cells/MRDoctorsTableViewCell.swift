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
    
    func configure(name: String, spec: Int) {
        nameLabel.text = "Dr. \(name)"
        specLabel.text = Specialities.specialities[spec]
        profileImage.image = UIImage(systemName: "person.circle")
    }
    
    func configImg(imgData: Data) {
        DispatchQueue.main.async {
            self.profileImage.image = UIImage(data: imgData)
        }
    }
    
    func configure(_ doctor: Doctor) {
        nameLabel.text = "Dr. \(doctor.name)"
        specLabel.text = Specialities.specialities[doctor.speciality] ?? "NA"
        emailLabel.text = doctor.email
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: doctor.contact)
        var office = MyStrings.notSpecified
        if !doctor.office.isEmpty {
            office = doctor.office
        }
        officeLabel.text = MyStrings.office + ": " + office
        profileImage.image = UIImage(systemName: "person.circle")
    }

}
