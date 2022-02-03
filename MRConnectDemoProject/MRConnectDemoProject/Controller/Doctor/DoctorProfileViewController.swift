//
//  DoctorProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class DoctorProfileViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let userDefault = UserDefaultManager.shared.defaults
    var user: CurrentUser? = CurrentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.profile
        //nameLabel.text = "Name: \(user!.name)"
        //usernameLabel.text = "Speciality: \(Specialities.specialities[user!.speciality]!)"
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        userDefault.removeObject(forKey: "email")
        userDefault.removeObject(forKey: "password")
        userDefault.removeObject(forKey: "userType")
        userDefault.removeObject(forKey: "userSpeciality")
        userDefault.removeObject(forKey: "userPassword")
        userDefault.removeObject(forKey: "userName")
        userDefault.removeObject(forKey: "userMRNumber")
        userDefault.removeObject(forKey: "userLicense")
        userDefault.removeObject(forKey: "userEmail")
        userDefault.removeObject(forKey: "userContact")
        
        userDefault.setValue(true, forKey: "authenticate")
        
        user = nil
        
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
}
