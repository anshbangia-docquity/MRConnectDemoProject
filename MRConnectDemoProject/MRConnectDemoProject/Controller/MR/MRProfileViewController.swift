//
//  MRProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRProfileViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let userDefault = UserDefaultManager.shared.defaults
    let user = Logic.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = tabBarItem.title
        nameLabel.text = "Name: \(user?.name ?? "")"
        usernameLabel.text = "Username: \(user?.email ?? "")"
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        userDefault.removeObject(forKey: "email")
        userDefault.removeObject(forKey: "password")
        Logic.user = nil
        
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
}
