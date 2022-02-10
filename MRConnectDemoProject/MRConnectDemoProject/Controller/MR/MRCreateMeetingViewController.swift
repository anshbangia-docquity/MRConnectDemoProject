//
//  MRCreateMeetingViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 07/02/22.
//

import UIKit

class MRCreateMeetingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleDescLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
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
    var doctors: [User] = []
    var medicines: [Medicine] = []
    var selectedDoctors: [User] = []
    var selectedMedicines: [Medicine] = []
    var doctorSet = Set<String>()
    var medicineSet = Set<Int16>()
    var handler: (() -> Void)?
    
    var edit = false
    var myMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
        
        titleDescLabel.text = MyStrings.titleAndDesc
        titleField.placeholder = MyStrings.meetingTitle
        descTextView.delegate = self
        
        dateTimeLabel.text = MyStrings.dateAndTime
        dateLabel.text = MyStrings.date
        timeLabel.text = MyStrings.time
        
        selectDoctorsLabel.text = MyStrings.selectDoctors
        doctorCollection.delegate = self
        doctorCollection.dataSource = self
        doctorSearchField.placeholder = MyStrings.search
        doctorSearchField.delegate = self
        doctors = logic.getDoctors()
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        
        selectMedicinesLabel.text = MyStrings.selectMedicines
        medicineCollection.delegate = self
        medicineCollection.dataSource = self
        medicineSearchField.placeholder = MyStrings.search
        medicineSearchField.delegate = self
        medicines = logic.getMedicines()
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        
        if edit {
            titleLabel.text = MyStrings.editMeeting
            createButton.setTitle(MyStrings.done.uppercased(), for: .normal)
            
            titleField.text = myMeeting!.title
            descTextView.text = myMeeting!.desc
            
            datePicker.date = myMeeting!.date!
            timePicker.date = myMeeting!.date!
            
            doctorSet = myMeeting!.doctors!
            selectedDoctors = logic.getUsers(with: doctorSet)
            
            medicineSet = myMeeting!.medicines!
            selectedMedicines = logic.getMedicines(with: medicineSet)
        } else {
            titleLabel.text = MyStrings.createMeeting
            createButton.setTitle(MyStrings.create.uppercased(), for: .normal)
            
            descTextView.text = MyStrings.meetingDescription
            descTextView.textColor = UIColor.systemGray3
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadDoctorTable()
        reloadMedicineTable()
        
        reloadDoctorCollection()
        reloadMedicineCollection()
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
        
        if selectedDoctors.count == 0 {
            Alert.showAlert(on: self, noSelection: MyStrings.doctor)
            return
        }
        
        if selectedMedicines.count == 0 {
            Alert.showAlert(on: self, noSelection: MyStrings.medicine)
            return
        }
        
        var descText: String? = descTextView.text
        if descText == MyStrings.meetingDescription {
            descText = nil
        }
        
        let date = logic.combineDateTime(date: datePicker.date, time: timePicker.date)
        
        if edit {
            let result = logic.editMeeting(meeting: myMeeting!, title: titleField.text!, desc: descText, date: date, doctors: doctorSet, medicines: medicineSet)
            
            if result == false {
                Alert.showAlert(on: self, notUpdated: MyStrings.meeting)
                return
            }
        } else {
            let result = logic.createMeeting(title: titleField.text!, desc: descText, date: date, doctors: doctorSet, medicines: medicineSet)
            
            if result == false {
                Alert.showAlert(on: self, notCreated: MyStrings.meeting)
                return
            }
        }
        
        handler!()
        dismiss(animated: true, completion: nil)
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
            return 80
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == doctorTableView {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
            
            let doctor = doctors[indexPath.row]
            myCell.nameLabel.text = "Dr. \(doctor.name!)"
            myCell.specLabel.text = Specialities.specialities[doctor.speciality]
            
            if let img = doctor.profileImage {
                myCell.profileImage.image = UIImage(data: img)
            } else {
                myCell.profileImage.image = UIImage(systemName: "person.circle")
            }
            
            cell = myCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MRMedicinesTableViewCell.id, for: indexPath) as! MRMedicinesTableViewCell
            
            let medicine = medicines[indexPath.row]
            myCell.medicineNameLabel.text = "\(medicine.name!)"
            myCell.companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: medicine.company!)
            
            cell = myCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == doctorTableView {
            if doctorSet.contains(doctors[indexPath.row].email!) {
                return
            }
            
            doctorSet.insert(doctors[indexPath.row].email!)
            selectedDoctors.insert(doctors[indexPath.row], at: 0)
            
            reloadDoctorCollection()
        } else {
            if medicineSet.contains(medicines[indexPath.row].id) {
                return
            }
            
            medicineSet.insert(medicines[indexPath.row].id)
            selectedMedicines.insert(medicines[indexPath.row], at: 0)
            
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
                let doctor = selectedDoctors[indexPath.item]
                if let img = doctor.profileImage {
                    myCell.profileImage.image = UIImage(data: img)
                } else {
                    myCell.profileImage.image = UIImage(systemName: "person.circle")
                }
                myCell.index = indexPath.item
                myCell.removeDoctor = removeDoctor
                cell = myCell
            }
        } else {
            if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MRMedicinesCollectionViewCell.id, for: indexPath) as? MRMedicinesCollectionViewCell {
                myCell.medicineName.text = selectedMedicines[indexPath.row].name
                myCell.index = indexPath.item
                myCell.removeMed = removeMed
                cell = myCell
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == medicineCollection {
            let label = UILabel(frame: CGRect.zero)
            label.text = selectedMedicines[indexPath.item].name
            label.sizeToFit()
            let width = label.frame.width + 42
            return CGSize(width: width, height: 30)
        }
        return CGSize(width: 60, height: 50)
    }

    
    func removeDoctor(_ index: Int) {
        doctorSet.remove(selectedDoctors[index].email!)
        selectedDoctors.remove(at: index)
        reloadDoctorCollection()
    }
    
    func removeMed(_ index: Int) {
        medicineSet.remove(selectedMedicines[index].id)
        selectedMedicines.remove(at: index)
        reloadMedicineCollection()
    }
    
}

//MARK: - Reload Tables and Collections
extension MRCreateMeetingViewController {
    
    func reloadDoctorTable() {
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        if doctorTableViewHeight.constant > 175 {
            doctorTableViewHeight.constant = 175
        }
    }
    
    func reloadMedicineTable() {
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = medicineTableView.contentSize.height
        if medicineTableViewHeight.constant > 150 {
            medicineTableViewHeight.constant = 150
        }
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
        if textField == doctorSearchField {
            if doctorSearchField.text == "" {
                doctors = logic.getDoctors()
            } else {
                doctors = logic.getDoctors(contains: doctorSearchField.text!)
            }

            reloadDoctorTable()
        }
        
        if textField == medicineSearchField {
            if medicineSearchField.text == "" {
                medicines = logic.getMedicines()
            } else {
                medicines = logic.getMedicines(contains: medicineSearchField.text!)
            }

            reloadMedicineTable()
        }
    }

    
}
