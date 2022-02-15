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
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler), name: Notification.Name("reloadMeetings"), object: nil)
    }

    @IBAction func createTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    @objc func handler() {
        let meetings = logic.fetchMeetings(of: user.email)
        (meetingDates, dates) = logic.processMeetingDates(meetings: meetings)
        DispatchQueue.main.async {
            self.meetingTableView.reloadData()
        }
    }
    
}

extension MeetingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var h = meetingDates[dates[indexPath.row]]!.count
        h *= 115
        h += 25 + 55
        return CGFloat(h)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsOuterTableViewCell.id, for: indexPath) as! MeetingsOuterTableViewCell
        
        let meetings = meetingDates[dates[indexPath.row]]!
        cell.configure(myMeetings: meetings, dateStr: dates[indexPath.row], handler: openMeeting)
        
        return cell
    }
    
    func openMeeting(_ meeting: Meeting) {
        tappedMeeting = meeting
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
}

//MARK: - Prepare for Segues
extension MeetingsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let vc = segue.destination as! MeetingDetailsViewController
            vc.meeting = tappedMeeting
        }
    }
    
}
