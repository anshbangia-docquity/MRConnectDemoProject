//
//  MRHomeViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 31/01/22.
//

import UIKit

class MRHomeViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let items = tabBar.items else { return }
//        items[0].title = MyStrings.meetings
//        items[1].title = MyStrings.doctors
//        items[2].title = MyStrings.medicines
//        items[3].title = MyStrings.profile
        
        items[0].title = MyStrings.doctors
        items[1].title = MyStrings.profile
    }

}
