//
//  MRCreateMeetingViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 07/02/22.
//

import UIKit

class MRCreateMeetingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.createMeeting
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
        createButton.setTitle(MyStrings.create.uppercased(), for: .normal)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: UIButton) {
        print("Create Tapped")
        dismiss(animated: true, completion: nil)
    }
    
}
