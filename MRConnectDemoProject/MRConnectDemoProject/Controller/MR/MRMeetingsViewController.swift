//
//  MRMeetingsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRMeetingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var meetingTableView: UITableView!
    
    let coreDataHandler = CoreDataHandler()
    var meetingDates: [String: [Meeting]] = [:]
    var dates: [String] = []
    var user = CurrentUser()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let meetings = coreDataHandler.fetchMeetings(of: user.email)
        process(meetings: meetings)
        
        meetingTableView.delegate = self
        meetingTableView.dataSource = self
        
        titleLabel.text = MyStrings.meetings
    }
    
    func process(meetings: [Meeting]) {
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        for meeting in meetings {
            let dateStr = dateFormatter.string(from: meeting.date!)
            if meetingDates[dateStr] == nil
            {
                meetingDates[dateStr] = []
                dates.append(dateStr)
            }
            meetingDates[dateStr]?.append(meeting)
        }
    }

    @IBAction func createTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    func handler() {
        let meetings = coreDataHandler.fetchMeetings(of: user.email)
        process(meetings: meetings)
        meetingTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            let vc = segue.destination as! MRCreateMeetingViewController
            vc.handler = handler
        }
    }
}

extension MRMeetingsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRMeetingsTableViewCell.id, for: indexPath) as! MRMeetingsTableViewCell
        
        let meetings = meetingDates[dates[indexPath.section]]!
        let meeting = meetings[indexPath.row]
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: meeting.date!)
        cell.titleLabel.text = meeting.title
        cell.timeLabel.text = time
        
        return cell
    }
    
}
