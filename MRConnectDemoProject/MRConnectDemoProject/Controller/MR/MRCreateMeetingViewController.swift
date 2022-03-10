//
//  MRCreateMeetingViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 07/02/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MRCreateMeetingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var doctorTableView: UITableView!
    @IBOutlet weak var doctorSearchField: UITextField!
    @IBOutlet weak var doctorTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doctorCollection: UICollectionView!
    @IBOutlet weak var doctorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var selectDoctorsLabel: UILabel!
    @IBOutlet weak var medicineCollection: UICollectionView!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var medicineSearchField: UITextField!
    @IBOutlet weak var medicineTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var medicineCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var selectMedicinesLabel: UILabel!

    var logic = Logic()
    var doctors: [QueryDocumentSnapshot] = []
    var medicines: [QueryDocumentSnapshot] = []
    var selectedDoctors: [QueryDocumentSnapshot] = []
    var selectedMedicines: [QueryDocumentSnapshot] = []
    //var doctorSet = Set<String>()
    //var medicineSet = Set<Int16>()
    
    var edit = false
    var myMeeting: [String: Any]?
    
    let auth = FirebaseAuth.Auth.auth()
    let database = Firestore.firestore()
    var userCollecRef: Query!
    var medCollecRef: Query!
    var meetingCollecRef: CollectionReference!
    var meetingDocRef: DocumentReference!
    var medIds: [String] = []
    var docIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollecRef = database.collection("Users").whereField("type", isEqualTo: 1)
        medCollecRef = database.collection("Medicines")
        meetingCollecRef = database.collection("Meetings")
        if edit {
            meetingDocRef = meetingCollecRef.document(myMeeting!["id"] as! String)
        } else {
            meetingDocRef = meetingCollecRef.document()
        }
        
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
        
        titleDescLabel.text = MyStrings.titleAndDesc
        titleField.placeholder = MyStrings.meetingTitle
        descTextView.delegate = self
        
        dateTimeLabel.text = MyStrings.dateAndTime
        dateLabel.text = MyStrings.date
        startTimeLabel.text = MyStrings.startTime
        endTimeLabel.text = MyStrings.endTime
        
        selectDoctorsLabel.text = MyStrings.selectDoctors
        doctorCollection.delegate = self
        doctorCollection.dataSource = self
        doctorSearchField.placeholder = MyStrings.search
        doctorSearchField.delegate = self
        //doctors = logic.getDoctors()
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        
        selectMedicinesLabel.text = MyStrings.selectMedicines
        medicineCollection.delegate = self
        medicineCollection.dataSource = self
        medicineSearchField.placeholder = MyStrings.search
        medicineSearchField.delegate = self
        //medicines = logic.getMedicines()
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        
        if edit {
            titleLabel.text = MyStrings.editMeeting
            createButton.setTitle(MyStrings.done.uppercased(), for: .normal)
            
            titleField.text = myMeeting!["title"] as? String
            descTextView.text = myMeeting!["desc"] as? String
            if descTextView.text == "" {
                descTextView.text = MyStrings.meetingDescription
                descTextView.textColor = UIColor.lightGray
            } else {
                descTextView.textColor = .black
            }
            
            let startStamp = myMeeting!["startDate"] as! Timestamp
            let endDate = myMeeting!["endDate"] as! Timestamp
            datePicker.date = startStamp.dateValue()
            startTimePicker.date = startStamp.dateValue()
            endTimePicker.date = endDate.dateValue()
            
//            doctorSet = myMeeting!.doctors!
//            selectedDoctors = logic.getUsers(with: doctorSet)
            
//            medicineSet = myMeeting!.medicines!
//            selectedMedicines = logic.getMedicines(with: medicineSet)
        } else {
            titleLabel.text = MyStrings.createMeeting
            createButton.setTitle(MyStrings.create.uppercased(), for: .normal)
            
            descTextView.text = MyStrings.meetingDescription
            descTextView.textColor = UIColor.systemGray3
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userCollecRef.getDocuments { snapshot, error in
            guard error == nil else { return }
            let docs = snapshot?.documents ?? []
            self.doctors = docs
            if self.edit {
                let doctors = self.myMeeting!["doctors"] as! [String]
                for doc in docs {
                    if doctors.contains(doc.documentID) {
                        self.selectedDoctors.append(doc)
                        self.docIds.append(doc.documentID)
                    }
                }
            }
            self.reloadDoctorTable()
            self.reloadDoctorCollection()
        }
        medCollecRef.getDocuments { snapshot, error in
            guard error == nil else { return }
            let docs = snapshot?.documents ?? []
            self.medicines = docs
            if self.edit {
                let meds = self.myMeeting!["medicines"] as! [String]
                for doc in docs {
                    if meds.contains(doc.documentID) {
                        self.selectedMedicines.append(doc)
                        self.medIds.append(doc.documentID)
                    }
                }
            }
            self.reloadMedicineTable()
            self.reloadMedicineCollection()
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doctorSearchTapped(_ sender: UIButton) {
        doctorSearchField.endEditing(true)
    }
    
    @IBAction func medicineSearchTapped(_ sender: UIButton) {
        medicineSearchField.endEditing(true)
    }
    
    @IBAction func createTapped(_ sender: UIButton) {
        if titleField.text == nil || titleField.text!.isEmpty {
            Alert.showAlert(on: self, emptyField: MyStrings.meetingTitle)
            return
        }
        
        if endTimePicker.date <= startTimePicker.date {
            Alert.showAlert(on: self, title: MyStrings.invalidTime, subtitle: MyStrings.againApptTime)
            return
        }
        
        if selectedDoctors.count == 0 {
            Alert.showAlert(on: self, noSelection: MyStrings.doctor)
            return
        }
        
        if selectedMedicines.count == 0 {
            Alert.showAlert(on: self, noSelection: MyStrings.medicine)
            return
        }
        
        var descText: String = descTextView.text
        if descText == MyStrings.meetingDescription {
            descText = ""
        }
        
        let startDate = logic.combineDateTime(date: datePicker.date, time: startTimePicker.date)
        let endDate = logic.combineDateTime(date: datePicker.date, time: endTimePicker.date)
        if Date() > startDate {
            Alert.showAlert(on: self, title: MyStrings.invalidTime, subtitle: MyStrings.againApptTime)
            return
        }
        
//        if edit {
//            let result = logic.editMeeting(meeting: myMeeting!, title: titleField.text!, desc: descText, startDate: startDate, endDate: endDate, doctors: doctorSet, medicines: medicineSet)
//
//            if result == false {
//                Alert.showAlert(on: self, notUpdated: MyStrings.meeting)
//                return
//            }
//        } else {
//            let result = logic.createMeeting(title: titleField.text!, desc: descText, startDate: startDate, endDate: endDate, doctors: doctorSet, medicines: medicineSet)
//
//            if result == false {
//                Alert.showAlert(on: self, notCreated: MyStrings.meeting)
//                return
//            }
//        }
        
        let creator = auth.currentUser!.uid
        let recordingArray: [String] = []
        meetingDocRef.setData([
            "title": titleField.text!,
            "startDate": startDate,
            "medicines": medIds,
            "id": meetingDocRef.documentID,
            "endDate": endDate,
            "doctors": docIds,
            "desc": descText,
            "creator": creator,
            "recordings": recordingArray
        ]) { error in
            guard error == nil else { return }
            self.dismiss(animated: true, completion: nil)
        }
        
        //NotificationCenter.default.post(name: Notification.Name("reloadMeetings"), object: nil)
        
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MRCreateMeetingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == doctorTableView {
            return doctors.count
        } else {
            return medicines.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == doctorTableView {
            return 90
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == doctorTableView {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
            
            let doctor = doctors[indexPath.row].data()
            myCell.configure(name: doctor["name"] as! String, spec: doctor["speciality"] as! Int16)
            
            if doctor["profileImageUrl"] as! String != "" {
                let imgUrlStr = doctor["profileImageUrl"] as! String
                let url = (URL(string: imgUrlStr))!
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        myCell.configImg(imgData: data)
                    }
                }
            }
            
            cell = myCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MRMedicinesTableViewCell.id, for: indexPath) as! MRMedicinesTableViewCell
            
            let medicine = medicines[indexPath.row].data()
            myCell.configure(med: medicine["name"] as! String, company: medicine["company"] as! String)
            
            cell = myCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == doctorTableView {
            if selectedDoctors.contains(doctors[indexPath.row]) {
                return
            }
            
            let doctor = doctors[indexPath.row]
            selectedDoctors.insert(doctor, at: 0)
            docIds.insert(doctor.documentID, at: 0)
            
            reloadDoctorCollection()
        } else {
            if selectedMedicines.contains(medicines[indexPath.row]) {
                return
            }
            
            let medicine = medicines[indexPath.row]
            selectedMedicines.insert(medicine, at: 0)
            medIds.insert(medicine.documentID, at: 0)
            
            reloadMedicineCollection()
        }
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MRCreateMeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == doctorCollection {
            return selectedDoctors.count
        } else {
            return selectedMedicines.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == doctorCollection {
            if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MRDoctorsCollectionViewCell.id, for: indexPath) as? MRDoctorsCollectionViewCell {
                //let doctor = selectedDoctors[indexPath.item]
                myCell.configure() {
                    //selectedDoctors
                    self.selectedDoctors.remove(at: indexPath.row)
                    self.docIds.remove(at: indexPath.row)
                    self.reloadDoctorCollection()
                }
                
//                if let img = doctor.profileImage {
//                    myCell.configImg(imgData: img)
//                }
                
                cell = myCell
            }
        } else {
            if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MRMedicinesCollectionViewCell.id, for: indexPath) as? MRMedicinesCollectionViewCell {
                let medicine = selectedMedicines[indexPath.item].data()
                myCell.configure(medName: medicine["name"] as! String) { [self] in
                    selectedMedicines.remove(at: indexPath.row)
                    self.medIds.remove(at: indexPath.row)
                    reloadMedicineCollection()
                }
                
                cell = myCell
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == medicineCollection {
            let label = UILabel(frame: CGRect.zero)
            label.text = selectedMedicines[indexPath.item].data()["name"] as? String
            label.sizeToFit()
            let width = label.frame.width + 42
            return CGSize(width: width, height: 30)
        }
        return CGSize(width: 60, height: 50)
    }
    
}

//MARK: - Reload Tables and Collections
extension MRCreateMeetingViewController {
    
    func reloadDoctorTable() {
        doctorTableView.reloadData()
        let count = CGFloat(doctors.count)
        if count >= 0 && count <= 2 {
            doctorTableViewHeight.constant = count * 90
            return
        }
        doctorTableViewHeight.constant = (2 * 90) + 45
    }
    
    func reloadMedicineTable() {
        medicineTableView.reloadData()
        let count = CGFloat(medicines.count)
        if count >= 0 && count <= 2 {
            medicineTableViewHeight.constant = count * 50
            return
        }
        medicineTableViewHeight.constant = (2 * 50) + 25
    }
    
    func reloadDoctorCollection() {
        DispatchQueue.main.async {
            self.doctorCollection.reloadData()
        }
        if selectedDoctors.count == 0 {
            doctorCollectionHeight.constant = 0
        } else {
            doctorCollectionHeight.constant = 60
        }
    }
    
    func reloadMedicineCollection() {
        DispatchQueue.main.async {
            self.medicineCollection.reloadData()
        }
        if selectedMedicines.count == 0 {
            medicineCollectionHeight.constant = 0
        } else {
            medicineCollectionHeight.constant = 40
        }
    }
    
}

//MARK: - UITextViewDelegate
extension MRCreateMeetingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != UIColor.black {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = MyStrings.meetingDescription
            textView.textColor = UIColor.lightGray
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension MRCreateMeetingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if textField == doctorSearchField {
//            if doctorSearchField.text == "" {
//                doctors = logic.getDoctors()
//            } else {
//                doctors = logic.getDoctors(contains: doctorSearchField.text!)
//            }
//
//            reloadDoctorTable()
//        }
//        
//        if textField == medicineSearchField {
//            if medicineSearchField.text == "" {
//                medicines = logic.getMedicines()
//            } else {
//                medicines = logic.getMedicines(contains: medicineSearchField.text!)
//            }
//
//            reloadMedicineTable()
//        }
    }

    
}
