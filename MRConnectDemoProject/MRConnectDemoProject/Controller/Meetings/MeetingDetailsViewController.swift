//
//  MeetingDetailsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var recordingTableView: UITableView!
    @IBOutlet weak var recordingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var recordingsLabel: UILabel!
    @IBOutlet weak var recordingsView: UIView!
    
    
    let user = CurrentUser()
    var meeting: Meeting?
    var logic = Logic()
    var doctorSet = Set<String>()
    var selectedDoctors: [User] = []
    var medicineSet = Set<Int16>()
    var selectedMedicines: [Medicine] = []
    var timer: Timer?
    let bulletinBoard = BulletinBoard()
    var recordings: [Recording] = []
    
    var audioPlayer: AVAudioPlayer!
    
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
        
        recordings = logic.getRecordings(of: meeting!.id)
        recordingsView.isHidden = false
        recordingTableView.delegate = self
        recordingTableView.dataSource = self
        if recordings.count != 0 {
            recordingTableView.reloadData()
            recordingTableHeight.constant = CGFloat(recordings.count * 50)
        } else {
            recordingsView.isHidden = true
        }
        
        doctorsLabel.text = MyStrings.doctors
        medicinesLabel.text = MyStrings.medicines
        recordingsLabel.text = MyStrings.recordings
        
        recordButton.isHidden = true
        recordButton.setTitle("  " + MyStrings.recordMeeting, for: .normal)
        
        bulletinBoard.delegate = self
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMeetings), name: Notification.Name("reloadMeetings"), object: nil)
        
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
            statusLabel.textColor = .lightGray
            statusLabel.text = MyStrings.meetingOver
        }
        
    }
    
    @objc func editTapped(sender: UIButton) {
        performSegue(withIdentifier: "goToEdit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.edit = true
            vc.myMeeting = meeting!
        }
    }
    
    @IBAction func recordMeetingTapped(_ sender: UIButton) {
        if !logic.checkRecordPermission() {
            Alert.showAlert(on: self, title: MyStrings.noMic, subtitle: MyStrings.enableMic)
            return
        }
        
        bulletinBoard.define(of: .RecordItem, additional: meeting!.id)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
}

//MARK: - BulletinBoardDelegate
extension MeetingDetailsViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        bulletinBoard.boardManager?.dismissBulletin()
        let selection = selection as! (Bool, String?, AVAudioRecorder?)
        if selection.0 {
            let fileName = selection.1!
            var result = true
            
            let confirmAlert = UIAlertController(title: MyStrings.askSaveRecording, message: MyStrings.confirmSaveRecording, preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(title: MyStrings.discard, style: .destructive, handler: { _ in
                selection.2!.deleteRecording()
            }))
            
            confirmAlert.addAction(UIAlertAction(title: MyStrings.yes, style: .default, handler: { [self] (action: UIAlertAction!) in
                recordingsView.isHidden = false
                result = logic.saveRecording(fileName: fileName, meeting: meeting!.id)
                recordings = logic.getRecordings(of: meeting!.id)
                recordingTableView.reloadData()
                recordingTableHeight.constant = CGFloat(recordings.count * 50)
            }))

            present(confirmAlert, animated: true) {
                if !result {
                    Alert.showAlert(on: self, notSaved: MyStrings.recording)
                }
            }
        } else {
            Alert.showAlert(on: self, error: MyStrings.recording)
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
        } else if tableView == medicineTableView {
            return selectedMedicines.count
        } else {
            return recordings.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == recordingTableView {
            return 50
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == doctorTableView || tableView == medicineTableView {
            let myCell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.id) as! DetailsTableViewCell
            if tableView == doctorTableView {
                myCell.config(title: "Dr. " + selectedDoctors[indexPath.row].name!)
            } else {
                myCell.config(title: selectedMedicines[indexPath.row].name!)
            }
            
            cell = myCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: RecordingsTableViewCell.id, for: indexPath) as! RecordingsTableViewCell
            
            let recTitle = "Recording \(indexPath.row + 1)"
            let recording = recordings[indexPath.row]
            
            prepare_to_play(fileName: recording.fileName!)
            let duration = Float(audioPlayer.duration)
            let hr = Int((duration / 60) / 60)
            let min = Int(duration / 60)
            let sec = Int(duration.truncatingRemainder(dividingBy: 60))
            var totalTimeString: String
            if hr == 0 {
                totalTimeString = String(format: "%02d:%02d", min, sec)
            } else {
                totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            }
            myCell.configure(title: recTitle, duration: totalTimeString)
            
            cell = myCell
        }
        
        return cell
    }
    
}

//MARK: - Reload Tables
extension MeetingDetailsViewController {
    
    @objc func reloadMeetings() {
        doctorSet = meeting!.doctors!
        selectedDoctors = logic.getUsers(with: doctorSet)
        medicineSet = meeting!.medicines!
        selectedMedicines = logic.getMedicines(with: medicineSet)
        
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = medicineTableView.contentSize.height
    }
    
}

//MARK: - AVAudioPlayerDelegate
extension MeetingDetailsViewController: AVAudioPlayerDelegate {
    
    func prepare_to_play(fileName: String) {
        let filePath = logic.getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: filePath)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
    }
    
}
