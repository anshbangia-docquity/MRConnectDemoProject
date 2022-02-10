//
//  MeetingDetailsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit

class MeetingDetailsViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var meetingTitle: UILabel!
    
    let user = CurrentUser()
    var meeting: Meeting?
    var logic = Logic()
    
    override func viewDidLoad() {
        editButton.setTitle(MyStrings.edit, for: .normal)
        
        logic.dateFormatter.dateFormat = "d"
        dayLabel.text = logic.dateFormatter.string(from: meeting!.date!)
        
        logic.dateFormatter.dateFormat = "MMM"
        monthLabel.text = logic.dateFormatter.string(from: meeting!.date!)
        
        meetingTitle.text = meeting!.title
        
        if user.type == .MRUser {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
    }
    
}
