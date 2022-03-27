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
    @IBOutlet weak var recordingsLabel: UILabel!
    
    var meeting: Meeting!
    let dateFormatter = MyDateFormatter.shared.dateFormatter
    let meetingsViewModel = MeetingsViewModel()
    
    //var timer: Timer?
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        timer?.invalidate()
//        timer = nil
//    }
    
//    deinit {
//        timer?.invalidate()
//        timer = nil
//    }
    
    func configure(myMeeting: Meeting) {
        meeting = myMeeting
        moreLabel.isHidden = true
        img1.image = UIImage(systemName: "person.circle")
        img2.image = UIImage(systemName: "person.circle")
        img3.image = UIImage(systemName: "person.circle")
        img1.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        moreView.isHidden = true
        
        titleLabel.text = meeting.title
        
        
        dateFormatter.dateFormat = "hh:mm a"
        timeLabel.text = dateFormatter.string(from: meeting.startDate) + " - " + dateFormatter.string(from: meeting.endDate)
        
        updateRecordingsCount()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecordingsCount), name: Notification.Name("recordingAdded"), object: nil)

        configureStatus()
        //timer
        
        meetingsViewModel.getDoctors(userIds: meeting.doctors) { [weak self] doctors in
            DispatchQueue.main.async {
                if doctors.count >= 1 {
                    self?.img1.isHidden = false
                }

                if doctors.count >= 2 {
                    self?.img2.isHidden = false
                }

                if doctors.count >= 3 {
                    self?.img3.isHidden = false
                }

                if doctors.count >= 4 {
                    self?.moreView.isHidden = false
                    self?.moreLabel.isHidden = false
                    self?.moreLabel.text = "+\(doctors.count - 3)"
                }
            }
        }

    }

//        configureStatus()
//        //DispatchQueue.global().async {
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
//            self.configureStatus()
//        })
//        //}

    
    @objc func updateRecordingsCount() {
        let count = meeting.recordings.count
        if count == 1 {
            recordingsLabel.text = "1 " + MyStrings.recording.lowercased()
        } else {
            recordingsLabel.text = "\(count) " + MyStrings.recordings.lowercased()
        }
    }
    
    func configureStatus() {
        let date = Date()
        let diffComponents = Calendar.current.dateComponents([.minute], from: date, to: meeting.startDate)
        let minutes = diffComponents.minute
        guard var minutes = minutes else { return }
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
            sideBar.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        } else {
            sideBar.backgroundColor = .clear
        }
        
        if date > meeting.endDate {
            //timer?.invalidate()
            //timer = nil
            statusLabel.textColor = .lightGray
            statusLabel.text = MyStrings.meetingOver
        }
        
        if date >= meeting.startDate {
            recordingsLabel.isHidden = false
        } else {
            recordingsLabel.isHidden = true
        }
        
    }
    
}


