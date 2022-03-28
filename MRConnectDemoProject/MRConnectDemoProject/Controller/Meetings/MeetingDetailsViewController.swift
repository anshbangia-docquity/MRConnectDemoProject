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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playCurrentTime: UILabel!
    @IBOutlet weak var playTotalTime: UILabel!
    @IBOutlet weak var playSlider: UISlider!
    @IBOutlet weak var playerHeight: NSLayoutConstraint!
    @IBOutlet weak var recordButtonAndPlayer: NSLayoutConstraint!
    
    //var statusTimer: Timer?
    //        self.statusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
    //            self.configureStatus()
    //        })
    
    var meeting: Meeting!
    var doctors: [Doctor] = []
    var medicines: [Medicine] = []
    var recordings: [Recording] = []
    
    let user = CurrentUser()
    let bulletinBoard = BulletinBoard()
    let dateFormatter = MyDateFormatter.shared.dateFormatter
    let meetingDetailsViewModel = MeetingDetailsViewModel()
    let alertManager = AlertManager()

    var audioPlayer: AVAudioPlayer?
    var isPlaying = false
    var isPlaybackPaused = false
    var playerTimer: Timer?
    var playerOn = false
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingsLabel.text = MyStrings.recordings
        doctorsLabel.text = MyStrings.doctors
        medicinesLabel.text = MyStrings.medicines
        recordingTableView.delegate = self
        recordingTableView.dataSource = self
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        doctorTableView.allowsSelection = false
        medicineTableView.allowsSelection = false
        recordingsView.isHidden = true
        bulletinBoard.delegate = self
        stopButton.isEnabled = false
        playSlider.isEnabled = false
        playerHeight.constant = 0
        recordButtonAndPlayer.constant = 30
        recordButton.setTitle("  " + MyStrings.recordMeeting, for: .normal)
        
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMeeting), name: Notification.Name("refreshMeetings"), object: nil)

    }
    
    @objc func refreshMeeting() {
        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        
        meetingDetailsViewModel.getMeeting(meetingId: meeting.id) { [weak self] meeting in
            self?.meeting = meeting
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
                self?.configure()
            }
        }
    }
    
    func configure() {
        recordButton.isHidden = true
        
        dateFormatter.dateFormat = "d"
        dayLabel.text = dateFormatter.string(from: meeting.startDate)
        
        dateFormatter.dateFormat = "MMM"
        monthLabel.text = dateFormatter.string(from: meeting.startDate)
        
        meetingTitle.text = meeting.title
        
        hostLabel.text = MyStrings.host + ": " + meeting.hostName
        hostLabel.isHidden = true
        if user.type == .Doctor {
            hostLabel.isHidden = false
        }
        
        dateFormatter.dateFormat = "hh:mm a"
        let startTime = dateFormatter.string(from: meeting.startDate)
        let endTime = dateFormatter.string(from: meeting.endDate)
        timeLabel.text = startTime + " - " + endTime
        
        configureStatus()
        //timer
        
        if meeting.desc == "" {
            descTextView.text = MyStrings.noDescription
            descTextView.textColor = .systemGray3
        } else {
            descTextView.text = meeting.desc
            self.descTextView.textColor = .black
        }
        
        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        refreshRecordings { [weak self] in
            self?.meetingDetailsViewModel.getDoctors(userIds: self!.meeting.doctors) { [weak self] doctors in
                self?.doctors = doctors
                
                self?.meetingDetailsViewModel.getMedicines(medIds: self!.meeting.medicines, completion: { [weak self] medicines in
                    self?.medicines = medicines
                    
                    DispatchQueue.main.async {
                        self?.reloadRecordingTable()
                        self?.reloadDoctorTable()
                        self?.reloadMedicineTable()
                        
                        ActivityIndicator.shared.stop()
                    }
                })
            }
        }
    }
    
    func configureStatus() {
        let date = Date()
        let diffComponents = Calendar.current.dateComponents([.minute], from: date, to: meeting.startDate)
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
        
        if date >= meeting.startDate && date <= meeting.endDate {
            statusLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
            statusLabel.text = MyStrings.inProgress
            
            if user.type == .MRUser {
                recordButton.isHidden = false
            }
            
            navigationItem.rightBarButtonItem = nil
        } else {
            if user.type == .MRUser {
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(self.editTapped(sender:)))
            }
        }
        
        if date > meeting.endDate {
            //statusTimer?.invalidate()
            statusLabel.textColor = .lightGray
            statusLabel.text = MyStrings.meetingOver
            recordButton.isHidden = true
        }
    }
    
    func refreshRecordings(completion: (() -> Void)?) {
        meetingDetailsViewModel.getRecordings(meetingId: meeting.id) { [weak self] recordings in
            self?.recordings = recordings
            
            completion?()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //statusTimer?.invalidate()
        //statusTimer = nil
        
        playerStopped()
        playerTimer?.invalidate()
        playerTimer = nil
        audioPlayer = nil
    }
    
    @objc func editTapped(sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.goToEdit, sender: self)
    }
    
    @IBAction func recordMeetingTapped(_ sender: UIButton) {
        let _ = AVAudioSession.sharedInstance().recordPermission
        bulletinBoard.define(of: .RecordItem, additional: (meeting.id, meeting.endDate))
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MeetingDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case doctorTableView:
            return doctors.count
        case medicineTableView:
            return medicines.count
        default:
            return recordings.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case recordingTableView:
            return 50
        default:
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == doctorTableView || tableView == medicineTableView {
            let myCell = tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.id) as! DetailsTableViewCell
            if tableView == doctorTableView {
                let doctor = doctors[indexPath.row]
                myCell.config(title: "Dr. " + doctor.name)
            } else {
                let medicine = medicines[indexPath.row]
                myCell.config(title: medicine.name)
            }
            
            cell = myCell
        } else {
            
            let myCell = tableView.dequeueReusableCell(withIdentifier: RecordingsTableViewCell.id, for: indexPath) as! RecordingsTableViewCell

            let recTitle = "Recording \(indexPath.row + 1)"
            let recording = recordings[indexPath.row]
            let hr: Int
            let min: Int
            let sec: Int
            (hr, min, sec) = meetingDetailsViewModel.calculateDuration(recording.duration)
            var totalTimeString: String
            if hr == 0 {
                totalTimeString = String(format: "%02d:%02d", min, sec)
            } else {
                totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            }
            myCell.configure(title: recTitle, duration: totalTimeString)

            myCell.titleLabel.textColor = .black
            myCell.durationLabel.textColor = .black
            if indexPath.row == selectedRow {
                myCell.titleLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
                myCell.durationLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
            }
            
            cell = myCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recording = recordings[indexPath.row]
        let hr: Int
        let min: Int
        let sec: Int
        playerStopped()
        (hr, min, sec) = meetingDetailsViewModel.calculateDuration(recording.duration)
        let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        playTotalTime.text = totalTimeString
        var cell: RecordingsTableViewCell
        let indexPaths = tableView.indexPathsForVisibleRows
        for i in indexPaths! {
            cell = tableView.cellForRow(at: i) as! RecordingsTableViewCell
            cell.titleLabel.textColor = .black
            cell.durationLabel.textColor = .black
        }
        cell = tableView.cellForRow(at: indexPath) as! RecordingsTableViewCell
        cell.titleLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        cell.durationLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        playSlider.value = 0
        playSlider.isEnabled = true
        playSlider.maximumValue = recording.duration
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)

        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        meetingDetailsViewModel.getRecordingData(urlStr: recording.link) { [weak self] data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
                
                self?.prepare_to_play(data)
                
                if !self!.playerOn {
                    UIView.animate(withDuration: 0.25) { [weak self] in
                        self?.playerHeight.constant = 120
                        self?.recordButtonAndPlayer.constant = 20
                        self?.view.layoutIfNeeded()
                    }
                } else {
                    self?.playerOn = true
                }
                
                self?.audioPlayer?.play()
                self?.isPlaying = true
                self?.isPlaybackPaused = false

                self?.playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                    if let audioPlayer = self?.audioPlayer, audioPlayer.isPlaying {
                        let hr: Int
                        let min: Int
                        let sec: Int
                        (hr, min, sec) = self!.meetingDetailsViewModel.calculateDuration(Float(audioPlayer.currentTime))
                        var totalTimeString: String
                        totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                        self?.playCurrentTime.text = totalTimeString
                        self?.playSlider.value = Float(audioPlayer.currentTime)
                    }
                })
            }
        }
    }
    
}

//MARK: - BulletinBoardDelegate
extension MeetingDetailsViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        bulletinBoard.boardManager?.dismissBulletin()
        let selection = selection as! (RecordResult, URL?, String?, AVAudioRecorder?, Float?)
        if selection.0 == .success {
            let recordingUrl = selection.1!
            let fileName = selection.2!
            let duration = selection.4!

            let confirmAlert = UIAlertController(title: MyStrings.askSaveRecording, message: MyStrings.confirmSaveRecording, preferredStyle: .alert)

            confirmAlert.addAction(UIAlertAction(title: MyStrings.discard, style: .destructive, handler: { _ in
                selection.3!.deleteRecording()
            }))

            confirmAlert.addAction(UIAlertAction(title: MyStrings.yes, style: .default, handler: { [weak self] (action: UIAlertAction!) in
                var newRecordings = self!.meeting.recordings
                newRecordings.append(fileName)
                let saveRecordingRequest = SaveRecordingRequest(link: nil, meeting: self!.meeting.id, recordings: newRecordings, fileName: fileName, duration: duration)
                
                ActivityIndicator.shared.start(on: self!.view, label: MyStrings.processing)
                if let data = try? Data(contentsOf: recordingUrl) {
                    self?.meetingDetailsViewModel.saveRecording(recordingData: data, path: "Recordings/\(fileName)", saveRecordingRequest: saveRecordingRequest, completion: {
                        [weak self] in
                        let notifData: [String: String] = ["meetingId": self!.meeting.id]
//                        NotificationCenter.default.post(name: Notification.Name("recordingAdded"), object: nil, userInfo: notifData)
                        
                        self?.refreshRecordings() { [weak self] in
                            DispatchQueue.main.async {
                                self?.reloadRecordingTable()
                                ActivityIndicator.shared.stop()
                            }
                        }
                        selection.3!.deleteRecording()
                    })
                }
            }))

            present(confirmAlert, animated: true)
        } else if selection.0 == .fail {
            alertManager.showAlert(on: self, text: ErrorType.defaultError.getAlertMessage())
        }
    }
    
}



//MARK: - AVAudioPlayerDelegate
extension MeetingDetailsViewController: AVAudioPlayerDelegate {
    
    func playerStopped() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        playerTimer?.invalidate()
        playCurrentTime.text = "00:00:00"
    }

    func prepare_to_play(_ data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        } catch {
            alertManager.showAlert(on: self, text: ErrorType.defaultError.getAlertMessage())
        }
    }

    @IBAction func playTapped(_ sender: UIButton) {
        if !isPlaying {
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            audioPlayer?.play()
            isPlaying = true
            isPlaybackPaused = false
            playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                if self!.audioPlayer!.isPlaying {
                    let hr: Int
                    let min: Int
                    let sec: Int
                    (hr, min, sec) = self!.meetingDetailsViewModel.calculateDuration(Float(self!.audioPlayer!.currentTime))
                    var totalTimeString: String
                    totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                    self?.playCurrentTime.text = totalTimeString
                    self?.playSlider.value = Float(self!.audioPlayer!.currentTime)
                }
            })
        } else {
            if !isPlaybackPaused {
                audioPlayer?.pause()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                isPlaybackPaused = true
            } else {
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                audioPlayer?.play()
                isPlaybackPaused = false
            }
        }
    }

    @IBAction func audioScrub(_ sender: UISlider) {
        audioPlayer?.pause()
        audioPlayer?.currentTime = TimeInterval(playSlider.value)
        if isPlaying && !isPlaybackPaused {
            audioPlayer?.play()
        }
        let hr = Int((audioPlayer!.currentTime / 60) / 60)
        let min = Int(audioPlayer!.currentTime / 60)
        let sec = Int(audioPlayer!.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        playCurrentTime.text = totalTimeString
    }

    @IBAction func stopPressed(_ sender: UIButton) {
        audioPlayerDidFinishPlaying(audioPlayer!, successfully: true)
    }
    
    //delegate function
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerStopped()
        recordButton.isEnabled = true
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isPlaying = false
        isPlaybackPaused = false
        stopButton.isEnabled = false
        playSlider.value = 0
    }

}

//MARK: - Other
extension MeetingDetailsViewController {
    
    func reloadMedicineTable() {
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = CGFloat(medicines.count * 45)
    }
    
    func reloadDoctorTable() {
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = CGFloat(doctors.count * 45)
    }
    
    func reloadRecordingTable() {
        if recordings.count == 0 {
            recordingsView.isHidden = true
        } else {
            recordingsView.isHidden = false
            recordingTableView.reloadData()
            recordingTableHeight.constant = CGFloat(recordings.count * 50)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.goToEdit {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.edit = true
            vc.myMeeting = meeting
            vc.selectedDoctorSet = Set(meeting.doctors)
            vc.selectedMedicineSet = Set(meeting.medicines)
            vc.selectedDoctors = doctors
            vc.selectedMedicines = medicines
        }
    }
    
}


