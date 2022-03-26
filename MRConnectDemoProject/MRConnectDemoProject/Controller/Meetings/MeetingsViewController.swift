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
    @IBOutlet weak var noMeetings: UILabel!
    
    let user = CurrentUser()
    let meetingsViewModel = MeetingsViewModel()
    var dates: [String] = []
    var meetings: [String: [Meeting]] = [:]
    var tappedMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        meetingTableView.delegate = self
        meetingTableView.dataSource = self
        meetingTableView.allowsMultipleSelection = true
        meetingTableView.separatorStyle = .none
        
        titleLabel.text = MyStrings.meetings
        noMeetings.text = ""
        
        if user.type == .MRUser {
            createButton.isHidden = false
        } else {
            createButton.isHidden = true
        }
        
        refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name("meetingAdded"), object: nil)
    }

    @IBAction func createTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: SegueIdentifiers.goToCreate, sender: self)
    }
    
    @objc func refreshData() {
        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        
        meetingsViewModel.getMeetings(userId: user.id, userType: user.type) { [weak self] meetings in
            (self!.dates, self!.meetings) = self!.meetingsViewModel.processMeetingDates(meetings: meetings)
            DispatchQueue.main.async {
                self?.reloadTable()
                ActivityIndicator.shared.stop()
            }
        }
    }

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MeetingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let meetings = meetings[dates[indexPath.row]]!
        var h = meetings.count
        h *= 115
        h += 25 + 75

        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.contains(indexPath) {
            return CGFloat(h)
        } else {
            return 25 + 75
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsOuterTableViewCell.id, for: indexPath) as! MeetingsOuterTableViewCell
        
        let date = dates[indexPath.row]
        let myMeetings = meetings[date]!
       
        cell.configure(myMeetings: myMeetings, dateStr: date, openMeeting: openMeeting)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        let cell = tableView.cellForRow(at: indexPath) as! MeetingsOuterTableViewCell
        cell.expand()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        let cell = tableView.cellForRow(at: indexPath) as! MeetingsOuterTableViewCell
        cell.collapse()
    }
    
    func openMeeting(_ meeting: Meeting) {
        tappedMeeting = meeting
        //performSegue(withIdentifier: SegueIdentifiers.goToDetails, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == SegueIdentifiers.goToDetails {
//            let vc = segue.destination as! MeetingDetailsViewController
//            //vc.meeting = tappedMeeting
//        }
    }

}

//MARK: - Reload Table
extension MeetingsViewController {
    
    func reloadTable() {
        if dates.count == 0 {
            noMeetings.isHidden = false
            noMeetings.text = MyStrings.noMeetings
        } else {
            noMeetings.isHidden = true
        }
        
        meetingTableView.reloadData()
    }
    
}
