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
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePicker: UIDatePicker!
    @IBOutlet weak var doctorTableView: UITableView!
    @IBOutlet weak var doctorSearchBar: UISearchBar!
    @IBOutlet weak var doctorTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var doctorCollection: UICollectionView!
    @IBOutlet weak var doctorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var selectDoctorsLabel: UILabel!
    @IBOutlet weak var medicineCollection: UICollectionView!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var medicineSearchBar: UISearchBar!
    @IBOutlet weak var medicineTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var medicineCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var selectMedicinesLabel: UILabel!
    
    var doctors: [Doctor] = []
    var copyDoctors: [Doctor] = []
    var medicines: [Medicine] = []
    var copyMedicines: [Medicine] = []
    var selectedDoctors: [Doctor] = []
    var selectedMedicines: [Medicine] = []
    var selectedDoctorSet = Set<String>()
    var selectedMedicineSet = Set<String>()
    
    let user = CurrentUser()
    let mrCreateMeetingViewModel = MRCreateMeetingViewModel()
    let alertManager = AlertManager()
    
    var edit = false
    var myMeeting: Meeting?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.createMeeting
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
        
        titleDescLabel.text = MyStrings.titleAndDesc
        titleField.placeholder = MyStrings.meetingTitle
        descTextView.delegate = self
        setDescTextView()
        
        dateTimeLabel.text = MyStrings.dateAndTime
        dateLabel.text = MyStrings.date
        startTimeLabel.text = MyStrings.startTime
        endTimeLabel.text = MyStrings.endTime
        
        selectDoctorsLabel.text = MyStrings.selectDoctors
        doctorCollection.delegate = self
        doctorCollection.dataSource = self
        reloadDoctorCollection()
        doctorSearchBar.delegate = self
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        
        selectMedicinesLabel.text = MyStrings.selectMedicines
        medicineCollection.delegate = self
        medicineCollection.dataSource = self
        reloadMedicineCollection()
        medicineSearchBar.delegate = self
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        
        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        mrCreateMeetingViewModel.getDoctors { [weak self] doctors in
            self?.doctors = doctors
            self?.copyDoctors = doctors
            
            self?.mrCreateMeetingViewModel.getMedicines { [weak self] medicines in
                self?.medicines = medicines
                self?.copyMedicines = medicines
                
                DispatchQueue.main.async {
                    ActivityIndicator.shared.stop()
                    self?.reloadDoctorTable()
                    self?.reloadMedicineTable()
                }
            }
        }
        
        createButton.setTitle(MyStrings.create.uppercased(), for: .normal)
        
        if edit {
            let myMeeting = self.myMeeting!
            
            titleLabel.text = MyStrings.editMeeting
            titleField.text = myMeeting.title
            setDescTextView(myMeeting.desc)
            
            datePicker.date = myMeeting.startDate
            startTimePicker.date = myMeeting.startDate
            endTimePicker.date = myMeeting.endDate
            
            createButton.setTitle(MyStrings.done.uppercased(), for: .normal)
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: UIButton) {
        var descText: String? = descTextView.text
        if descText == MyStrings.meetingDescription {
            descText = nil
        }
        let recordings = myMeeting?.recordings ?? []
        
        let startDate = mrCreateMeetingViewModel.combineDateTime(date: datePicker.date, time: startTimePicker.date)
        let endDate = mrCreateMeetingViewModel.combineDateTime(date: datePicker.date, time: endTimePicker.date)
        
        let createMeetingRequest = CreateMeetingRequest(title: titleField.text, desc: descText, endDate: endDate, startDate: startDate, doctors: Array(selectedDoctorSet), medicines: Array(selectedMedicineSet), recordings: recordings, creator: user.id, hostName: user.name)
        
        mrCreateMeetingViewModel.createMeeting(createMeetingRequest: createMeetingRequest, meetingId: myMeeting?.id) { [weak self] error in
            if let error = error {
                self?.alertManager.showAlert(on: self!, text: error.getAlertMessage())
            } else {
                DispatchQueue.main.async {
                    let notifData: [String: Bool] = ["edit": self!.edit]
                    NotificationCenter.default.post(name: Notification.Name("refreshMeetings"), object: nil, userInfo: notifData)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MRCreateMeetingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case doctorTableView:
            return doctors.count
        default:
            return medicines.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case doctorTableView:
            return 90
        default:
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == doctorTableView {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
            
            let doctor = doctors[indexPath.row]
            
            myCell.configure(name: doctor.name, spec: doctor.speciality)
            
            cell = myCell
        } else {
            let myCell = tableView.dequeueReusableCell(withIdentifier: MRMedicinesTableViewCell.id, for: indexPath) as! MRMedicinesTableViewCell
            
            let medicine = medicines[indexPath.row]
            
            myCell.configure(med: medicine.name, company: medicine.company)
            
            cell = myCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == doctorTableView {
            let doctor = doctors[indexPath.row]
            
            if selectedDoctorSet.contains(doctor.id) {
                return
            }
            
            selectedDoctors.insert(doctor, at: 0)
            selectedDoctorSet.insert(doctor.id)
            
            reloadDoctorCollection()
        } else {
            let medicine = medicines[indexPath.row]
            
            if selectedMedicineSet.contains(medicine.id) {
                return
            }
            
            selectedMedicines.insert(medicine, at: 0)
            selectedMedicineSet.insert(medicine.id)
            
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
        switch collectionView {
        case doctorCollection:
            return selectedDoctors.count
        default:
            return selectedMedicines.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == doctorCollection {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MRDoctorsCollectionViewCell.id, for: indexPath) as! MRDoctorsCollectionViewCell
            let doctor = selectedDoctors[indexPath.item]
            
            myCell.configure() { [weak self] in
                self?.selectedDoctors.remove(at: indexPath.item)
                self?.selectedDoctorSet.remove(doctor.id)
                self?.reloadDoctorCollection()
            }
            
            //                if let img = doctor.profileImage {
            //                    myCell.configImg(imgData: img)
            //                }
            
            cell = myCell
            
        } else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MRMedicinesCollectionViewCell.id, for: indexPath) as! MRMedicinesCollectionViewCell
            let medicine = selectedMedicines[indexPath.item]
            
            myCell.configure(medName: medicine.name) { [weak self] in
                self?.selectedMedicines.remove(at: indexPath.item)
                self?.selectedMedicineSet.remove(medicine.id)
                self?.reloadMedicineCollection()
            }
            
            cell = myCell
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
    
}

//MARK: - UISearchBarDelegate
extension MRCreateMeetingViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchStr = searchText
        if searchBar == doctorSearchBar {
            doctors = copyDoctors
            if !searchStr.isEmpty {
                doctors = doctors.filter({ doctor in
                    return doctor.name.lowercased().contains(searchStr.lowercased())
                })
            }
            
            reloadDoctorTable()
        } else {
            medicines = copyMedicines
            if !searchStr.isEmpty {
                var set = Set<String>()
                let meds1 = medicines.filter({ medicine in
                    if medicine.company.lowercased().contains(searchStr.lowercased()) {
                        set.insert(medicine.id)
                        return true
                    } else {
                        return false
                    }
                })
                let meds2 = medicines.filter({ medicine in
                    return medicine.name.lowercased().contains(searchStr.lowercased())
                })
                medicines = meds1
                meds2.forEach { med in
                    if !set.contains(med.id) {
                        medicines.append(med)
                    }
                }
            }
            
            reloadMedicineTable()
        }
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
            setDescTextView()
        }
    }
    
}

//MARK: - Other
extension MRCreateMeetingViewController {
    
    func setDescTextView(_ desc: String? = nil) {
        if desc == nil || desc == "" {
            descTextView.text = MyStrings.meetingDescription
            descTextView.textColor = UIColor.lightGray
        } else {
            descTextView.text = desc
            descTextView.textColor = .black
        }
    }
    
}


