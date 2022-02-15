//
//  MRDoctorDetailsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 15/02/22.
//

import UIKit

class MRDoctorDetailsViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var officeTextView: UITextView!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var qualiLabel: UILabel!
    @IBOutlet weak var qualiTextView: UITextView!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var expTextView: UITextView!
    
    var doctor: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = UIImage(systemName: "person.circle")
        if let img = doctor!.profileImage {
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: img)
            }
            
            nameLabel.text = "Dr. \(doctor!.name!)"
            specLabel.text = Specialities.specialities[doctor!.speciality]
            emailLabel.text = doctor!.email
            contactLabel.text = doctor!.contact
            officeLabel.text = MyStrings.office
            qualiLabel.text = MyStrings.quali
            expLabel.text = MyStrings.exp
            
            if doctor!.office!.isEmpty {
                officeTextView.text = MyStrings.notSpecified
                officeTextView.textColor = .systemGray3
            } else {
                officeTextView.text = doctor!.office
            }
            
            if doctor!.quali!.isEmpty {
                qualiTextView.text = MyStrings.notSpecified
                qualiTextView.textColor = .systemGray3
            } else {
                qualiTextView.text = doctor!.quali
            }
            
            if doctor!.exp!.isEmpty {
                expTextView.text = MyStrings.notSpecified
                expTextView.textColor = .systemGray3
            } else {
                expTextView.text = doctor!.exp
            }
        }
    }
    
}
