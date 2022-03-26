//
//  MeetingsOuterTableViewCell.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 11/02/22.
//

import UIKit

class MeetingsOuterTableViewCell: UITableViewCell {
    
    static let id = "meetingsOuterTableCell"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var meetingTable: UITableView!
    @IBOutlet weak var meetingTableHeight: NSLayoutConstraint!
    @IBOutlet weak var meetingNum: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    
    var meetings: [Meeting] = []
    var tappedMeeting: Meeting?
    var openMeeting: ((_ meeting: Meeting) -> Void)?
    let dateFormatter = MyDateFormatter.shared.dateFormatter
    
    func configure(myMeetings: [Meeting], dateStr: String, openMeeting: @escaping (_ meeting: Meeting) -> Void) {
        meetingTable.layer.cornerRadius = 15
        meetingTable.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dateTimeView.layer.cornerRadius = 15
        dateTimeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        meetings = myMeetings
        self.openMeeting = openMeeting
        
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let date = dateFormatter.date(from: dateStr)!
        
        dateFormatter.dateFormat = "dd"
        dateLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "MMM"
        monthLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "EEEE"
        dayLabel.text = dateFormatter.string(from: date)
        
        if dayLabel.text! == dateFormatter.string(from: Date()) {
            dayLabel.text = MyStrings.today
            dateTimeView.backgroundColor = UIColor(red: 125/255, green: 200/255, blue: 58/255, alpha: 0.5)
        } else {
            dateTimeView.backgroundColor = .white
        }
        
        if meetings.count == 1 {
            meetingNum.text = "\(meetings.count) " + MyStrings.meeting.lowercased()
        } else {
            meetingNum.text = "\(meetings.count) " + MyStrings.meetings.lowercased()
        }
        
        meetingTable.delegate = self
        meetingTable.dataSource = self
        
        meetingTableHeight.constant = CGFloat((meetings.count * 115))
        meetingTable.reloadData()
    }

}

//MARK: - Expand and Collapse
extension MeetingsOuterTableViewCell {
    
    func expand() {
        arrow.image = UIImage(systemName: "chevron.down")
    }
    
    func collapse() {
        arrow.image = UIImage(systemName: "chevron.right")
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MeetingsOuterTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsInnerTableViewCell.id) as! MeetingsInnerTableViewCell
        
        cell.configure(myMeeting: meetings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let meeting = meetings[indexPath.row]
        openMeeting?(meeting)
    }
    
}

