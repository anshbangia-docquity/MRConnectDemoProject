//
//  MRDoctorDetailsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 15/02/22.
//

import UIKit
import FirebaseFirestore

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
    
    //var doctor: User?
    var doctorDoc: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = UIImage(systemName: "person.circle")
        if doctorDoc["profileImageUrl"] as! String != "" {
            let imgUrlStr = doctorDoc["profileImageUrl"] as! String
            let url = (URL(string: imgUrlStr))!
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let img = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImage.image = img
                        }
                    }
                }
            }
        }
        
        nameLabel.text = "Dr. \(doctorDoc["name"] as! String)"
        specLabel.text = Specialities.specialities[doctorDoc["speciality"] as! Int16]
        emailLabel.text = doctorDoc["email"] as? String
        contactLabel.text = doctorDoc["contact"] as? String
        officeLabel.text = MyStrings.office
        qualiLabel.text = MyStrings.quali
        expLabel.text = MyStrings.exp
        
        if (doctorDoc["office"] as! String).isEmpty {
            officeTextView.text = MyStrings.notSpecified
            officeTextView.textColor = .systemGray3
        } else {
            officeTextView.text = doctorDoc["office"] as? String
        }
        
        if (doctorDoc["quali"] as! String).isEmpty {
            qualiTextView.text = MyStrings.notSpecified
            qualiTextView.textColor = .systemGray3
        } else {
            qualiTextView.text = doctorDoc["quali"] as? String
        }
        
        if (doctorDoc["exp"] as! String).isEmpty {
            expTextView.text = MyStrings.notSpecified
            expTextView.textColor = .systemGray3
        } else {
            expTextView.text = doctorDoc["exp"] as? String
        }
    }
}


