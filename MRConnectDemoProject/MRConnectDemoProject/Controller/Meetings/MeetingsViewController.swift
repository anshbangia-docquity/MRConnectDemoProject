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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let meetings = logic.fetchMeetings(of: user.email)
        (meetingDates, dates) = logic.processMeetingDates(meetings: meetings)
        
        meetingTableView.delegate = self
        meetingTableView.dataSource = self
        
        titleLabel.text = MyStrings.meetings
        
        if user.type == .MRUser {
            createButton.isHidden = false
        } else {
            createButton.isHidden = true
        }
    }

    @IBAction func createTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    func handler() {
        let meetings = logic.fetchMeetings(of: user.email)
        (meetingDates, dates) = logic.processMeetingDates(meetings: meetings)
        meetingTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.handler = handler
        }
    }
}

extension MeetingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dates[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingDates[dates[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsTableViewCell.id, for: indexPath) as! MeetingsTableViewCell
        
        let meetings = meetingDates[dates[indexPath.section]]!
        let meeting = meetings[indexPath.row]
        logic.dateFormatter.dateFormat = "h:mm a"
        let time = logic.dateFormatter.string(from: meeting.date!)
        cell.titleLabel.text = meeting.title
        cell.timeLabel.text = time
        
        if user.type == .MRUser {
            cell.withLabel.text = MyStrings.withLabel.replacingOccurrences(of: "|#X#|", with: ("\(meeting.doctors!.count) " + MyStrings.doctors))
        } else {
            let creator = logic.getUser(with: meeting.creator!)
            cell.withLabel.text = MyStrings.withLabel.replacingOccurrences(of: "|#X#|", with: creator.name!)
        }
        
        return cell
    }
    
}
