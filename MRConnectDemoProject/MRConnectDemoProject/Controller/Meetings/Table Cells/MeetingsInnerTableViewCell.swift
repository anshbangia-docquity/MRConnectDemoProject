//
//  MeetingsInnerTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 11/02/22.
//

import UIKit
import FirebaseFirestore

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
    
    var meeting: [String: Any]?
    var logic = Logic()
    var doctorCount = 0
    var selectedDoctors: [[String: Any]] = []
    var timer: Timer?
    let database = Firestore.firestore()
    var userCollec: CollectionReference!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    func configure(myMeeting: [String: Any]) {
        selectedDoctors = []
        meeting = myMeeting
        moreLabel.isHidden = true
        img1.image = UIImage(systemName: "person.circle")
        img2.image = UIImage(systemName: "person.circle")
        img3.image = UIImage(systemName: "person.circle")
        img1.isHidden = true
        img2.isHidden = true
        img3.isHidden = true
        moreView.isHidden = true
        let doctorArray = meeting!["doctors"] as! [String]
        userCollec = database.collection("Users")
        userCollec.getDocuments { snapshot, error in
            guard error == nil else { return }
            let docs = (snapshot?.documents)!
            for doc in docs {
                if doctorArray.contains(doc.documentID) {
                    self.selectedDoctors.append(doc.data())
                }
            }
            self.doctorCount = self.selectedDoctors.count
            if self.doctorCount > 2 {
                self.moreLabel.isHidden = false
                self.moreLabel.textColor = .darkGray
                self.moreLabel.text = "+\(self.doctorCount - 2) more"
            } else {
                self.moreLabel.isHidden = true
            }
            if self.doctorCount >= 1 {
                self.img1.isHidden = false
//                DispatchQueue.main.async {
//                    if let data = self.selectedDoctors[0].profileImage {
//                        self.img1.image = UIImage(data: data)
//                    }
//                }
            }
            
        if self.doctorCount >= 2 {
            self.img2.isHidden = false
//                DispatchQueue.main.async {
//                    if let data = self.selectedDoctors[1].profileImage {
//                        self.img2.image = UIImage(data: data)
//                    }
//                }
            }
            
            if self.doctorCount >= 3 {
                self.img3.isHidden = false
//                DispatchQueue.main.async {
//                    if let data = self.selectedDoctors[2].profileImage {
//                        self.img3.image = UIImage(data: data)
//                    }
//                }
            }
            
            if self.doctorCount >= 4 {
                self.moreView.isHidden = false
                self.moreLabel.text = "+\(self.doctorCount - 3)"
            }
        }
        
        titleLabel.text = meeting!["title"] as? String
        logic.dateFormatter.dateFormat = "hh:mm a"
        var stamp = meeting!["startDate"] as! Timestamp
        let startTime = logic.dateFormatter.string(from: stamp.dateValue())
        stamp = meeting!["endDate"] as! Timestamp
        let endTime = logic.dateFormatter.string(from: stamp.dateValue())
        timeLabel.text = startTime + " - " + endTime
        
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
        let startStamp = meeting!["startDate"] as! Timestamp
        let endStamp = meeting!["endDate"] as! Timestamp
        let diffComponents = Calendar.current.dateComponents([.minute], from: date, to: startStamp.dateValue())
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
        
        if date >= startStamp.dateValue() && date <= endStamp.dateValue() {
            statusLabel.textColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
            statusLabel.text = MyStrings.inProgress
            sideBar.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        } else {
            sideBar.backgroundColor = .white
        }
        
        if date > endStamp.dateValue() {
            timer?.invalidate()
            timer = nil
            statusLabel.textColor = .lightGray
            statusLabel.text = MyStrings.meetingOver
        }
        
        if date >= startStamp.dateValue() {
            recsLabel.isHidden = false
        } else {
            recsLabel.isHidden = true
        }
        
    }
    
    @objc func updateRecordingCount() {
        recsLabel.text = "n recordings"
//        let recsCount = logic.getRecordings(of: meeting!.id).count
//        if recsCount == 1 {
//            recsLabel.text = "1 " + MyStrings.recording.lowercased()
//        } else {
//            recsLabel.text = "\(recsCount) " + MyStrings.recordings.lowercased()
//        }
    }
    
}


