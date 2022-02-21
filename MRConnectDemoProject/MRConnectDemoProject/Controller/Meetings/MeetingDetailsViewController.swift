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
    
    let user = CurrentUser()
    var meeting: Meeting?
    var logic = Logic()
    var doctorSet = Set<String>()
    var selectedDoctors: [User] = []
    var medicineSet = Set<Int16>()
    var selectedMedicines: [Medicine] = []
    var statusTimer: Timer?
    let bulletinBoard = BulletinBoard()
    var recordings: [Recording] = []
    
    var audioPlayer: AVAudioPlayer!
    var isPlaying = false
    var isPlaybackPaused = false
    var playerTimer: Timer!
    var replay = false
    var playerOn = false
    var durationPlayer: AVAudioPlayer!
    var selectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctorSet = meeting!.doctors!
        selectedDoctors = logic.getUsers(with: doctorSet)
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        doctorTableView.allowsSelection = false
        
        medicineSet = meeting!.medicines!
        selectedMedicines = logic.getMedicines(with: medicineSet)
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = medicineTableView.contentSize.height
        medicineTableView.allowsSelection = false
        
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
        
        stopButton.isEnabled = false
        playSlider.isEnabled = false
        playerHeight.constant = 0
        recordButtonAndPlayer.constant = 30
        
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
        self.statusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
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
            statusTimer?.invalidate()
            statusLabel.textColor = .lightGray
            statusLabel.text = MyStrings.meetingOver
        }
        
    }
    
    @objc func editTapped(sender: UIButton) {
        performSegue(withIdentifier: "goToEdit", sender: self)
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
        let selection = selection as! (RecordResult, String?, AVAudioRecorder?)
        if selection.0 == .success {
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
                
                NotificationCenter.default.post(name: Notification.Name("recordingAdded"), object: nil)
            }))
            
            present(confirmAlert, animated: true) {
                if !result {
                    Alert.showAlert(on: self, notSaved: MyStrings.recording)
                }
            }
        } else if selection.0 == .fail {
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
            
            prepare_duration_player(fileName: recording.fileName!)
            let hr: Int
            let min: Int
            let sec: Int
            (hr, min, sec) = calculateDuration(durationPlayer.duration)
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
        prepare_to_play(fileName: recording.fileName!)
        (hr, min, sec) = calculateDuration(audioPlayer.duration)
        var totalTimeString: String
        totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        playTotalTime.text = totalTimeString
        
        if !playerOn {
            UIView.animate(withDuration: 0.25) { [self] in
                playerHeight.constant = 120
                recordButtonAndPlayer.constant = 20
                view.layoutIfNeeded()
            }
        } else {
            playerOn = true
        }
        
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
        playSlider.maximumValue = Float(audioPlayer.duration)
        
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        audioPlayer.play()
        isPlaying = true
        isPlaybackPaused = false
        playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] _ in
            if audioPlayer.isPlaying {
                let hr: Int
                let min: Int
                let sec: Int
                (hr, min, sec) = calculateDuration(audioPlayer.currentTime)
                var totalTimeString: String
                totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                playCurrentTime.text = totalTimeString
                playSlider.value = Float(audioPlayer.currentTime)
            }
        })
    }
    
}

//MARK: - AVAudioPlayerDelegate
extension MeetingDetailsViewController: AVAudioPlayerDelegate {
    
    func prepare_to_play(fileName: String) {
        let filePath = logic.getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: filePath)
                audioPlayer.delegate = self
                audioPlayer.prepareToPlay()
            } catch {
                Alert.showAlert(on: self, title: MyStrings.error, subtitle: MyStrings.tryAgain)            }
        } else {
            Alert.showAlert(on: self, title: MyStrings.fileNotFound, subtitle: MyStrings.tryAgain)
        }
    }
    
    func prepare_duration_player(fileName: String) {
        let filePath = logic.getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: filePath.path) {
            do {
                durationPlayer = try AVAudioPlayer(contentsOf: filePath)
                durationPlayer.delegate = self
                durationPlayer.prepareToPlay()
            } catch {
                Alert.showAlert(on: self, title: MyStrings.error, subtitle: MyStrings.tryAgain)            }
        } else {
            Alert.showAlert(on: self, title: MyStrings.fileNotFound, subtitle: MyStrings.tryAgain)
        }
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        if !isPlaying {
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            audioPlayer.play()
            isPlaying = true
            isPlaybackPaused = false
            playerTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [self] _ in
                if audioPlayer.isPlaying {
                    let hr: Int
                    let min: Int
                    let sec: Int
                    (hr, min, sec) = calculateDuration(audioPlayer.currentTime)
                    var totalTimeString: String
                    totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                    playCurrentTime.text = totalTimeString
                    playSlider.value = Float(audioPlayer.currentTime)
                }
            })
        } else {
            if !isPlaybackPaused {
                audioPlayer.pause()
                playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                isPlaybackPaused = true
            } else {
                playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                audioPlayer.play()
                isPlaybackPaused = false
            }
        }
    }
    
    @IBAction func audioScrub(_ sender: UISlider) {
        audioPlayer.pause()
        audioPlayer.currentTime = TimeInterval(playSlider.value)
        if isPlaying && !isPlaybackPaused {
            audioPlayer.play()
        }
        let hr = Int((audioPlayer.currentTime / 60) / 60)
        let min = Int(audioPlayer.currentTime / 60)
        let sec = Int(audioPlayer.currentTime.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
        playCurrentTime.text = totalTimeString
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        audioPlayerDidFinishPlaying(audioPlayer, successfully: true)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerStopped()
        recordButton.isEnabled = true
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isPlaying = false
        isPlaybackPaused = false
        stopButton.isEnabled = false
        playSlider.value = 0
    }
    
    func playerStopped() {
        if replay {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            playerTimer.invalidate()
            playCurrentTime.text = "00:00:00"
        } else {
            replay = true
        }
    }
    
}

//MARK: - Other
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
    
    func calculateDuration(_ duration: TimeInterval) -> (Int, Int, Int) {
        let duration = Float(duration)
        let hr = Int((duration / 60) / 60)
        let min = Int(duration / 60)
        let sec = Int(duration.truncatingRemainder(dividingBy: 60))
        return (hr, min, sec)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEdit" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.edit = true
            vc.myMeeting = meeting!
        }
    }
    
}


