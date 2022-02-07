//
//  MRMeetingsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRMeetingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.meetings
    }

    @IBAction func createTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
}
