//
//  MeetingsInnerTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 11/02/22.
//

import UIKit

class MeetingsInnerTableViewCell: UITableViewCell {
    
    static let id = "meetingsInnerTableCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var sideBar: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var recsLabel: UILabel!
    
    var meeting: Meeting?
    var logic = Logic()
    var doctorCount = 0
    var selectedDoctors: [User] = []
    var timer: Timer?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func configure(myMeeting: Meeting) {
        meeting = myMeeting
        titleLabel.text = meeting?.title
        logic.dateFormatter.dateFormat = "hh:mm a"
        let startTime = logic.dateFormatter.string(from: meeting!.startDate!)
        let endTime = logic.dateFormatter.string(from: meeting!.endDate!)
        timeLabel.text = startTime + " - " + endTime
        
        moreLabel.isHidden = true
        selectedDoctors = logic.getUsers(with: meeting!.doctors!)
        doctorCount = selectedDoctors.count
        if doctorCount > 2 {
            moreLabel.isHidden = false
            moreLabel.textColor = .darkGray
            moreLabel.text = "+\(doctorCount - 2) more"
        } else {
            moreLabel.isHidden = true
        }
        
        img1.image = UIImage(systemName: "person.circle")
        img2.image = UIImage(systemName: "person.circle")
        img3.image = UIImage(systemName: "person.circle")
        img1.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        moreView.isHidden = true
        
        if doctorCount >= 1 {
            img1.isHidden = false
            DispatchQueue.main.async {
                if let data = self.selectedDoctors[0].profileImage {
                    self.img1.image = UIImage(data: data)
                }
            }
        }
        
        if doctorCount >= 2 {
            img2.isHidden = false
            DispatchQueue.main.async {
                if let data = self.selectedDoctors[1].profileImage {
                    self.img2.image = UIImage(data: data)
                }
            }
        }
        
        if doctorCount >= 3 {
            img3.isHidden = false
            DispatchQueue.main.async {
                if let data = self.selectedDoctors[2].profileImage {
                    self.img3.image = UIImage(data: data)
                }
            }
        }
        
        if doctorCount >= 4 {
            moreView.isHidden = false
            moreLabel.text = "+\(doctorCount - 3)"
        }
        
        configureStatus()
        //DispatchQueue.global().async {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.configureStatus()
        })
        //}
        
        updateRecordingCount()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordingCount), name: Notification.Name("recordingAdded"), object: nil)
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
            sideBar.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        } else {
            sideBar.backgroundColor = .white
        }
        
        if date > meeting!.endDate! {
            timer?.invalidate()
            timer = nil
            statusLabel.textColor = .lightGray
            statusLabel.text = MyStrings.meetingOver
        }
        
        if date >= meeting!.startDate! {
            recsLabel.isHidden = false
        } else {
            recsLabel.isHidden = true
        }
        
    }
    
    @objc func updateRecordingCount() {
        let recsCount = logic.getRecordings(of: meeting!.id).count
        if recsCount == 1 {
            recsLabel.text = "1 " + MyStrings.recording.lowercased()
        } else {
            recsLabel.text = "\(recsCount) " + MyStrings.recordings.lowercased()
        }
    }
    
}


