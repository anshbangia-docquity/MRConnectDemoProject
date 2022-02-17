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
        
        meetingTable.layer.cornerRadius = 15
        meetingTable.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        dateTimeView.layer.cornerRadius = 15
        dateTimeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
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
            dateTimeView.backgroundColor = UIColor(red: 125/255, green: 200/255, blue: 58/255, alpha: 0.5)
            dateLabel.textColor = .black
            monthLabel.textColor = .black
            dayLabel.textColor = .black
        } else {
            dateTimeView.backgroundColor = .white
            dateLabel.textColor = .black
            monthLabel.textColor = .black
            dayLabel.textColor = .black
        }
        
        meetingTable.delegate = self
        meetingTable.dataSource = self
        
        meetingTable.reloadData()
        meetingTableHeight.constant = CGFloat((meetings.count * 115))
        
//        let _ = Timer.scheduledTimer(withTimeInterval: 0, repeats: true) { _ in
//            NotificationCenter.default.post(name: Notification.Name("oneSecond"), object: nil)
//        }
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
        
        //NotificationCenter.default.addObserver(self, selector: #selector(self.oneSecond(cell:)), name: Notification.Name("oneSecond"), object: nil)
        
//        NotificationCenter.default.addObserver(forName: Notification.Name("oneSecond"), object: nil, queue: nil) { _ in
//            cell.configureStatus()
//        }
        
        return cell
    }
    
//    @objc func oneSecond(cell: MeetingsInnerTableViewCell) {
//        cell.configureStatus()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let meeting = meetings[indexPath.row]
        
        openMeeting!(meeting)
    }
    
}

