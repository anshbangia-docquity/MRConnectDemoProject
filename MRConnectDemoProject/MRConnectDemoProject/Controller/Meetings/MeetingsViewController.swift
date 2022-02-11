//
//  MeetingsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import UIKit

class MeetingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var meetingTableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    var logic = Logic()
    var meetingDates: [String: [Meeting]] = [:]
    var dates: [String] = []
    var user = CurrentUser()
    var tappedMeeting: Meeting?
    
    var test: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingTableView.delegate = self
        meetingTableView.dataSource = self
        
        titleLabel.text = MyStrings.meetings
        
        if user.type == .MRUser {
            createButton.isHidden = false
        } else {
            createButton.isHidden = true
        }
        
        meetingTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let meetings: [Meeting]
        if user.type == .MRUser {
            meetings = logic.fetchMeetings(of: user.email)
        } else {
            meetings = logic.fetchMeetings(for: user.email)
        }
        (meetingDates, dates) = logic.processMeetingDates(meetings: meetings)
        
        DispatchQueue.main.async {
            self.meetingTableView.reloadData()
        }
        
//        self.meetingTableView.layoutSubviews()
//        meetingTableView.rowHeight = UITableView.automaticDimension
//        meetingTableView.estimatedRowHeight = UITableView.automaticDimension
    }

    @IBAction func createTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    func handler() {
        let meetings = logic.fetchMeetings(of: user.email)
        (meetingDates, dates) = logic.processMeetingDates(meetings: meetings)
        meetingTableView.reloadData()
    }
    
}

extension MeetingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return test
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsOuterTableViewCell.id, for: indexPath) as! MeetingsOuterTableViewCell
        
//        let meetings = meetingDates[dates[indexPath.section]]!
//        let meeting = meetings[indexPath.row]
//        logic.dateFormatter.dateFormat = "h:mm a"
//        let time = logic.dateFormatter.string(from: meeting.date!)
//        cell.titleLabel.text = meeting.title
//        cell.timeLabel.text = time
        
//        if user.type == .MRUser {
//            cell.withLabel.text = MyStrings.withLabel.replacingOccurrences(of: "|#X#|", with: ("\(meeting.doctors!.count) " + MyStrings.doctors))
//        } else {
//            let creator = logic.getUser(with: meeting.creator!)
//            cell.withLabel.text = MyStrings.withLabel.replacingOccurrences(of: "|#X#|", with: creator.name!)
//        }
        
        let meetings = meetingDates[dates[indexPath.row]]!
        cell.configure(myMeetings: meetings, dateStr: dates[indexPath.row], handler: openMeeting)
        
        test = cell.meetingTableHeight.constant + 25
        
        return cell
    }
    
    func openMeeting(_ meeting: Meeting) {
        tappedMeeting = meeting
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let meetings = meetingDates[dates[indexPath.section]]!
//        let meeting = meetings[indexPath.row]
//        tappedMeeting = meeting
//        
//        performSegue(withIdentifier: "goToDetails", sender: self)
//    }
    
}

//MARK: - Prepare for Segues
extension MeetingsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.handler = handler
        } else if segue.identifier == "goToDetails" {
            let vc = segue.destination as! MeetingDetailsViewController
            vc.meeting = tappedMeeting
        }
    }
    
}
