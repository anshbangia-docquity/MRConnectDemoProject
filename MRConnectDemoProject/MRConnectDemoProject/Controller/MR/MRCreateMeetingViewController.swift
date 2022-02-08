//
//  MRCreateMeetingViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 07/02/22.
//

import UIKit

class MRCreateMeetingViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
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
    
    let coreDataHandler = CoreDataHandler()
    var doctors: [User] = []
    var medicines: [Medicine] = []
    let dateFormatter = DateFormatter()
    var selectedDoctors: [User] = []
    var selectedMedicines: [Medicine] = []
    var doctorSet = Set<String>()
    var medicineSet = Set<Int16>()
    var handler: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        if doctorTableViewHeight.constant > 175 {
            doctorTableViewHeight.constant = 175
        }
        
        medicineTableView.reloadData()
        medicineTableViewHeight.constant = medicineTableView.contentSize.height
        if medicineTableViewHeight.constant > 150 {
            medicineTableViewHeight.constant = 150
        }
        
        doctorCollection.reloadData()
        
        medicineCollection.reloadData()
        
        doctorCollectionHeight.constant = 0
        medicineCollectionHeight.constant = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctors = coreDataHandler.fetchUser(of: .Doctor)
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        doctorSearchField.delegate = self
        
        medicines = coreDataHandler.fetchMedicines()
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        medicineSearchField.delegate = self
        
        titleLabel.text = MyStrings.createMeeting
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
        createButton.setTitle(MyStrings.create.uppercased(), for: .normal)
        titleDescLabel.text = MyStrings.titleAndDesc
        titleField.placeholder = MyStrings.meetingTitle
        
        descTextView.delegate = self
        descTextView.text = MyStrings.meetingDescription
        descTextView.textColor = UIColor.systemGray3
        
        dateTimeLabel.text = MyStrings.dateAndTime
        dateLabel.text = MyStrings.date
        timeLabel.text = MyStrings.time
        
        doctorCollection.delegate = self
        doctorCollection.dataSource = self
        medicineCollection.delegate = self
        medicineCollection.dataSource = self
        
        selectDoctorsLabel.text = MyStrings.selectDoctors
        selectMedicinesLabel.text = MyStrings.selectMedicines
        doctorSearchField.placeholder = MyStrings.search
        medicineSearchField.placeholder = MyStrings.search
    }
    
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
    
    
    @IBAction func doctorSearchTapped(_ sender: UIButton) {
        doctorSearchField.endEditing(true)
    }
    
    @IBAction func medicineSearchTapped(_ sender: UIButton) {
        medicineSearchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == doctorSearchField {
            if doctorSearchField.text == "" {
                doctors = coreDataHandler.fetchUser(of: UserType.Doctor)
            } else {
                doctors = coreDataHandler.fetchUser(of: .Doctor, contains: doctorSearchField.text!)
            }

            doctorTableView.reloadData()
            doctorTableViewHeight.constant = doctorTableView.contentSize.height
            if doctorTableViewHeight.constant > 175 {
                doctorTableViewHeight.constant = 175
            }
        }
        
        if textField == medicineSearchField {
            if medicineSearchField.text == "" {
                medicines = coreDataHandler.fetchMedicines()
            } else {
                medicines = coreDataHandler.fetchMedicines(contains: medicineSearchField.text!)
            }

            medicineTableView.reloadData()
            medicineTableViewHeight.constant = medicineTableView.contentSize.height
            if medicineTableViewHeight.constant > 150 {
                medicineTableViewHeight.constant = 150
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: UIButton) {
        if titleField.text == nil || titleField.text!.isEmpty {
            showAlert(emptyField: MyStrings.meetingTitle)
            return
        }
        
        if selectedDoctors.count == 0 {
            showAlert(noSelection: MyStrings.doctor)
            return
        }
        
        if selectedMedicines.count == 0 {
            showAlert(noSelection: MyStrings.medicine)
            return
        }
        
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateStr = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = dateFormatter.string(from: timePicker.date)
        let dateTimeStr = dateStr + " " + timeStr

        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let date = dateFormatter.date(from: dateTimeStr)!
        
        var descText: String? = descTextView.text
        if descText == "" {
            descText = nil
        }
        
        let result = coreDataHandler.createMeeting(title: titleField.text!, desc: descText, date: date, doctors: doctorSet, medicines: medicineSet)
        
        if result == false {
            showAlert(notCreated: MyStrings.meeting)
            return
        }
        

        handler!()
        dismiss(animated: true, completion: nil)
        
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField), subtitle: MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField)), animated: true, completion: nil)
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
    func showAlert(noSelection: String) {
        self.present(Alert.showAlert(title: MyStrings.noSelectionAlertTitle.replacingOccurrences(of: "|#X#|", with: noSelection), subtitle: MyStrings.noSelectionAlertSubtitle.replacingOccurrences(of: "|#X#|", with: noSelection)), animated: true, completion: nil)
    }
    
    func showAlert(notCreated: String) {
        self.present(Alert.showAlert(title: MyStrings.createUnsuccess.replacingOccurrences(of: "|#X#|", with: notCreated), subtitle: MyStrings.tryAgain), animated: true, completion: nil)
    }
    
}

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
        if tableView == doctorTableView {
            if doctorSet.contains(doctors[indexPath.row].email!) {
                return
            }
            
            doctorSet.insert(doctors[indexPath.row].email!)
            
            if selectedDoctors.count == 0 {
                doctorCollectionHeight.constant = 60
            }
            
            selectedDoctors.insert(doctors[indexPath.row], at: 0)
            tableView.deselectRow(at: indexPath, animated: true)
            
            DispatchQueue.main.async {
                self.doctorCollection.reloadData()
            }
        } else {
            if medicineSet.contains(medicines[indexPath.row].id) {
                return
            }
            
            medicineSet.insert(medicines[indexPath.row].id)
            
            if selectedMedicines.count == 0 {
                medicineCollectionHeight.constant = 40
            }
            
            selectedMedicines.insert(medicines[indexPath.row], at: 0)
            tableView.deselectRow(at: indexPath, animated: true)
            
            DispatchQueue.main.async {
                self.medicineCollection.reloadData()
            }
        }
    }
    
}

extension MRCreateMeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorCollectionViewCell.id, for: indexPath) as? DoctorCollectionViewCell {
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
            if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicineCollectionViewCell.id, for: indexPath) as? MedicineCollectionViewCell {
                myCell.medicineName.text = selectedMedicines[indexPath.row].name
                myCell.index = indexPath.item
                myCell.removeMed = removeMed
                cell = myCell
            }
        }

        return cell
            
    }
    
    func removeDoctor(_ index: Int) {
        doctorSet.remove(selectedDoctors[index].email!)
        selectedDoctors.remove(at: index)
        
        if selectedDoctors.count == 0 {
            doctorCollectionHeight.constant = 0
        }
        
        doctorCollection.reloadData()
    }
    
    func removeMed(_ index: Int) {
        medicineSet.remove(selectedMedicines[index].id)
        selectedMedicines.remove(at: index)
        
        if selectedMedicines.count == 0 {
            medicineCollectionHeight.constant = 0
        }
        
        medicineCollection.reloadData()
    }
    
}

extension MRCreateMeetingViewController: UICollectionViewDelegateFlowLayout {
    
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
