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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var doctorTableView: UITableView!
    @IBOutlet weak var doctorTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doctorsLabel: UILabel!
    @IBOutlet weak var medicinesLabel: UILabel!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var medicineTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hostLabel: UILabel!
    
    
    let user = CurrentUser()
    var meeting: Meeting?
    var logic = Logic()
    var doctorSet = Set<String>()
    var selectedDoctors: [User] = []
    var medicineSet = Set<Int16>()
    var selectedMedicines: [Medicine] = []
    
    override func viewDidLoad() {
        editButton.setTitle(MyStrings.edit, for: .normal)
        
        logic.dateFormatter.dateFormat = "d"
        dayLabel.text = logic.dateFormatter.string(from: meeting!.date!)
        
        logic.dateFormatter.dateFormat = "MMM"
        monthLabel.text = logic.dateFormatter.string(from: meeting!.date!)
        
        meetingTitle.text = meeting!.title
        
        hostLabel.text = MyStrings.host + ": " + logic.getUser(with: meeting!.creator!).name!
        
        logic.dateFormatter.dateFormat = "h:mm a"
        timeLabel.text = logic.dateFormatter.string(from: meeting!.date!)
        
        if meeting!.desc == nil {
            descTextView.text = MyStrings.noDescription
            descTextView.textColor = .systemGray3
        } else {
            descTextView.text = meeting!.desc
        }
        
        doctorSet = meeting!.doctors!
        selectedDoctors = logic.getUsers(with: doctorSet)
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        
        medicineSet = meeting!.medicines!
        selectedMedicines = logic.getMedicines(with: medicineSet)
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = medicineTableView.contentSize.height
        
        if user.type == .MRUser {
            editButton.isHidden = false
            hostLabel.isHidden = true
        } else {
            editButton.isHidden = true
        }
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        print("hello")
        
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.edit = true
            vc.myMeeting = meeting!
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MeetingDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == doctorTableView {
            return selectedDoctors.count
        } else {
            return selectedMedicines.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.id) as! DetailsTableViewCell
        
        if tableView == doctorTableView {
            cell.titleLabel.text = "Dr. " + selectedDoctors[indexPath.row].name!
        } else {
            cell.titleLabel.text = selectedMedicines[indexPath.row].name!
        }
        
        return cell
    }
    
}
