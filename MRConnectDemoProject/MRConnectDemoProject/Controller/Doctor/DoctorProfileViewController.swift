//
//  DoctorProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let userDefault = UserDefaultManager.shared.defaults
    let user = Logic.user
    let speciality = Logic.fetchSpec(with: (Logic.user?.speciality)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.profile
        nameLabel.text = "Name: \(user?.name ?? "")"
        usernameLabel.text = "Speciality: \(speciality)"
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        userDefault.removeObject(forKey: "email")
        userDefault.removeObject(forKey: "password")
        Logic.user = nil
        
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
}
