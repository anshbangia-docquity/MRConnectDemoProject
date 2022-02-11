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
    
    var meetings: [Meeting] = []
    var logic = Logic()
    var tappedMeeting: Meeting?
    var openMeeting: ((_ meeting: Meeting) -> Void)?
    
    func configure(myMeetings: [Meeting], dateStr: String, handler: @escaping (Meeting) -> Void) {
        meetings = myMeetings
        openMeeting = handler
        logic.dateFormatter.dateFormat = "MMM d, yyyy"
        let date = logic.dateFormatter.date(from: dateStr)!
        
        logic.dateFormatter.dateFormat = "dd"
        dateLabel.text = logic.dateFormatter.string(from: date)
        logic.dateFormatter.dateFormat = "MMM"
        monthLabel.text = logic.dateFormatter.string(from: date)
        logic.dateFormatter.dateFormat = "EEEE"
        dayLabel.text = logic.dateFormatter.string(from: date)
        if dayLabel.text! == logic.dateFormatter.string(from: Date())
        {
            dayLabel.text = MyStrings.today
            dateTimeView.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 0.12)
        } else {
            dateTimeView.backgroundColor = .white
        }
        
        meetingTable.delegate = self
        meetingTable.dataSource = self
        
        meetingTable.reloadData()
        meetingTableHeight.constant = meetingTable.contentSize.height
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsInnerTableViewCell.id) as! MeetingsInnerTableViewCell
        
        cell.configure(myMeeting: meetings[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meeting = meetings[indexPath.row]
        
        openMeeting!(meeting)
    }
    
}




//override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
