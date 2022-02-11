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
    @IBOutlet weak var doctorCollection: UICollectionView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var sideBar: UIView!
    
    var meeting: Meeting?
    var logic = Logic()
    var doctorCount = 0
    var selectedDoctors: [User] = []
    
    func configure(myMeeting: Meeting) {
        meeting = myMeeting
        titleLabel.text = meeting?.title
        logic.dateFormatter.dateFormat = "h:mm a"
        timeLabel.text = logic.dateFormatter.string(from: meeting!.date!)
        
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
        logic.dateFormatter.dateFormat = "MMM d"
        if logic.dateFormatter.string(from: meeting!.date!) == logic.dateFormatter.string(from: Date()) {
            sideBar.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        } else {
            sideBar.backgroundColor = .systemGray6
        }
        
        doctorCollection.delegate = self
        doctorCollection.dataSource = self
        doctorCollection.reloadData()
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UI
extension MeetingsInnerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if doctorCount > 2 {
            return 2
        } else {
            return doctorCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeetingDoctorsCollectionViewCell.id, for: indexPath) as! MeetingDoctorsCollectionViewCell
        
        var img = UIImage(systemName: "person.circle")
        
        cell.configure(image: img!)
        DispatchQueue.main.async {
            if let data = self.selectedDoctors[indexPath.item].profileImage {
                img = UIImage(data: data)
            }
            cell.configure(image: img!)
        }
        
//        if let data = self.selectedDoctors[indexPath.item].profileImage {
//            img = UIImage(data: data)
//        }
//
//        cell.configure(image: img!)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
}
    
    
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }


