//
//  MeetingDetailsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit

class MeetingDetailsViewController: UIViewController {
    
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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    
    let user = CurrentUser()
    var meeting: Meeting?
    var logic = Logic()
    var doctorSet = Set<String>()
    var selectedDoctors: [User] = []
    var medicineSet = Set<Int16>()
    var selectedMedicines: [Medicine] = []
    var timer: Timer?
    let bulletinBoard = BulletinBoard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        doctorsLabel.text = MyStrings.doctors
        medicinesLabel.text = MyStrings.medicines
        
        recordButton.isHidden = true
        recordButton.setTitle("  " + MyStrings.recordMeeting, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logic.dateFormatter.dateFormat = "d"
        dayLabel.text = logic.dateFormatter.string(from: meeting!.startDate!)
        
        logic.dateFormatter.dateFormat = "MMM"
        monthLabel.text = logic.dateFormatter.string(from: meeting!.startDate!)
        
        meetingTitle.text = meeting!.title
        
        hostLabel.text = MyStrings.host + ": " + logic.getUser(with: meeting!.creator!).name!
        
        logic.dateFormatter.dateFormat = "hh:mm a"
        let startDate = logic.dateFormatter.string(from: meeting!.startDate!)
        let endDate = logic.dateFormatter.string(from: meeting!.endDate!)
        timeLabel.text = startDate + " - " + endDate
        
        if meeting!.desc == nil {
            descTextView.text = MyStrings.noDescription
            descTextView.textColor = .systemGray3
        } else {
            descTextView.text = meeting!.desc
            descTextView.textColor = .black
        }
        
        if user.type == .MRUser {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(self.editTapped(sender:)))
            
            hostLabel.isHidden = true
        } else {
            hostLabel.isHidden = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler), name: Notification.Name("reloadMeetings"), object: nil)
        
        configureStatus()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.configureStatus()
        })
    }
    
    func configureStatus() {
        let date = Date()
        let diffComponents = Calendar.current.dateComponents([.minute], from: date, to: meeting!.startDate!)
        let minutes = diffComponents.minute
        guard var minutes = minutes else {return}
        minutes += 1
        statusLabel.textColor = .red
        if minutes <= 10 && minutes > 1 {
            statusLabel.text = MyStrings.minsRemaining.replacingOccurrences(of: "|#X#|", with: "\(minutes)")
        } else if minutes == 1 {
            statusLabel.text = MyStrings.minRemaining.replacingOccurrences(of: "|#X#|", with: "\(minutes)")
        } else {
            statusLabel.text = ""
        }
        
        if date >= meeting!.startDate! && date <= meeting!.endDate! {
            statusLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
            statusLabel.text = MyStrings.inProgress
            
            if user.type == .MRUser {
                recordButton.isHidden = false
            }
        }
        
        if date > meeting!.endDate! {
            timer?.invalidate()
        }
        
    }
    
    @objc func editTapped(sender: UIButton) {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    @objc func handler() {
        doctorSet = meeting!.doctors!
        selectedDoctors = logic.getUsers(with: doctorSet)
        medicineSet = meeting!.medicines!
        selectedMedicines = logic.getMedicines(with: medicineSet)
        
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = medicineTableView.contentSize.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.edit = true
            vc.myMeeting = meeting!
        }
    }
    
    @IBAction func recordMeetingTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .RecordItem)
        bulletinBoard.boardManager?.showBulletin(above: self)
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
            cell.config(title: "Dr. " + selectedDoctors[indexPath.row].name!)
        } else {
            cell.config(title: selectedMedicines[indexPath.row].name!)
        }
        
        return cell
    }
    
}
