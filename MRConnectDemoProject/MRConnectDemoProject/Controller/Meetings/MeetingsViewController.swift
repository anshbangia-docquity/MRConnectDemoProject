//
//  MeetingsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MeetingsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var meetingTableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var noMeetings: UILabel!
    
    //var logic = Logic()
    var meetingDates: [String: [[String: Any]]] = [:]
    var dates: [String] = []
    //var user = CurrentUser()
    var tappedMeeting: [String: Any]?
    
    let auth = FirebaseAuth.Auth.auth()
    let database = Firestore.firestore()
    var meetingCollecRef: Query!
    var userCollecRef: CollectionReference!
    var userDocRef: DocumentReference!
    var meetingDocuments: [QueryDocumentSnapshot] = []
    
    func processMeetingDates() {
//        meetingDates = [:]
//        dates = []
//        logic.dateFormatter.dateFormat = "MMM d, yyyy"
//        for meetingDoc in meetingDocuments {
//            let meeting = meetingDoc.data()
//            let stamp = meeting["startDate"] as! Timestamp
//            let dateStr = logic.dateFormatter.string(from: stamp.dateValue())
//            if meetingDates[dateStr] == nil
//            {
//                meetingDates[dateStr] = []
//                dates.append(dateStr)
//            }
//            meetingDates[dateStr]?.append(meeting)
//        }
    }
    
    func getMeetingDocuments() {
        meetingCollecRef.getDocuments { snapshot, error in
            guard error == nil else { return }
            self.meetingDocuments = snapshot?.documents ?? []
            self.processMeetingDates()
            self.updateNoMeetings()
            self.meetingTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userDocRef.getDocument { snapshot, error in
            guard error == nil else { return }
            let user = snapshot!.data()
            
            if user!["type"] as! Int16 == UserType.MRUser.rawValue {
                self.createButton.isHidden = false
                self.meetingCollecRef = self.database.collection("Meetings").whereField("creator", isEqualTo: self.auth.currentUser!.uid)
            } else {
                self.createButton.isHidden = true
                self.meetingCollecRef = self.database.collection("Meetings").whereField("doctors", arrayContains: self.auth.currentUser!.uid)
            }
            self.getMeetingDocuments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //meetingCollecRef = database.collection("Meetings")
        userCollecRef = database.collection("Users")
        userDocRef = userCollecRef.document(auth.currentUser!.uid)
        
        meetingTableView.allowsMultipleSelection = true
        meetingTableView.delegate = self
        meetingTableView.dataSource = self
        
        titleLabel.text = MyStrings.meetings
        
        meetingTableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler), name: Notification.Name("reloadMeetings"), object: nil)
    }

    @IBAction func createTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    @objc func handler() {
//        let meetings: [Meeting]
//        if user.type == .MRUser {
//            meetings = logic.fetchMeetings(of: user.email)
//        } else {
//            meetings = logic.fetchMeetings(for: user.email)
//        }
//        updateNoMeetings(meetings)
//        (meetingDates, dates) = logic.processMeetingDates(meetings: meetings)
//        DispatchQueue.main.async {
//            self.meetingTableView.reloadData()
//        }
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
        let meetings = meetingDates[dates[indexPath.row]]!
        var h = meetings.count
        h *= 115
        h += 25 + 75
        
//        let cell = tableView.cellForRow(at: indexPath) as? MeetingsOuterTableViewCell
//        guard let cell = cell else {
//            return 25 + 75
//        }
//
//        if cell.isExpanded {
//            return CGFloat(h)
//        } else {
//            return 25 + 75
//        }
        
        //guard let cell = tableView.cellForRow(at: indexPath) as? MeetingsOuterTableViewCell else { return 25 + 75 }
        if let selectedRows = tableView.indexPathsForSelectedRows, selectedRows.contains(indexPath) {
            return CGFloat(h)
        } else {
            return 25 + 75
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MeetingsOuterTableViewCell.id, for: indexPath) as! MeetingsOuterTableViewCell
        
        let meetings = meetingDates[dates[indexPath.row]]!
        cell.configure(myMeetings: meetings, dateStr: dates[indexPath.row], handler: openMeeting)
//        {
//            if !cell.isExpanded {
//                cell.arrow.image = UIImage(systemName: "chevron.down")
//                
//                cell.isExpanded = true
//                tableView.beginUpdates()
//                tableView.endUpdates()
//            } else {
//                cell.arrow.image = UIImage(systemName: "chevron.right")
//                
//                cell.isExpanded = false
//                tableView.beginUpdates()
//                tableView.endUpdates()
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        let cell = tableView.cellForRow(at: indexPath) as! MeetingsOuterTableViewCell
        cell.arrow.image = UIImage(systemName: "chevron.down")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
        
        let cell = tableView.cellForRow(at: indexPath) as! MeetingsOuterTableViewCell
        cell.arrow.image = UIImage(systemName: "chevron.right")
    }
    
    func openMeeting(_ meeting: [String: Any]) {
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

//MARK: - Other
extension MeetingsViewController {
    
    func updateNoMeetings() {
        if meetingDocuments.count == 0 {
            noMeetings.isHidden = false
            noMeetings.text = MyStrings.noMeetings
        } else {
            noMeetings.isHidden = true
        }
    }
    
}
