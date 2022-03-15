//
//  DoctorHomeViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 31/01/22.
//

import UIKit

class DoctorHomeViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let items = tabBar.items else { return }
        //items[0].title = MyStrings.meetings
        items[0].title = MyStrings.profile
    }
    
}
