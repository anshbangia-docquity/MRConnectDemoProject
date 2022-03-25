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
    
    var doctor: Doctor!
    let mrDoctorDetailsViewModel = MRDoctorDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = UIImage(systemName: "person.circle")
        if !doctor.imageLink.isEmpty {
            ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
            
            mrDoctorDetailsViewModel.getProfileImage(urlStr: doctor.imageLink) { [weak self] imgData in
                ActivityIndicator.shared.stop()
                
                guard let imgData = imgData else { return }
                self?.profileImage.image = UIImage(data: imgData)
            }
        }
        
        nameLabel.text = "Dr. \(doctor.name)"
        specLabel.text = Specialities.specialities[doctor.speciality] ?? "NA"
        emailLabel.text = doctor.email
        contactLabel.text = doctor.contact
        
        officeLabel.text = MyStrings.office
        qualiLabel.text = MyStrings.quali
        expLabel.text = MyStrings.exp
        let textViews: [(UITextView, String)] = [(officeTextView, doctor.office), (qualiTextView, doctor.quali), (expTextView, doctor.exp)]
        textViews.forEach { tuple in
            if tuple.1.isEmpty {
                tuple.0.text = MyStrings.notSpecified
                tuple.0.textColor = .systemGray3
            } else {
                tuple.0.text = tuple.1
            }
        }
    }
    
}


