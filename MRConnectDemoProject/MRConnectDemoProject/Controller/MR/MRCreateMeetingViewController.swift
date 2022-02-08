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
    
    let coreDataHandler = CoreDataHandler()
    var doctors: [User] = []
    let dateFormatter = DateFormatter()
    var selectedDoctors: [User] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        doctorTableView.reloadData()
        doctorTableViewHeight.constant = doctorTableView.contentSize.height
        if doctorTableViewHeight.constant > 250 {
            doctorTableViewHeight.constant = 250
        }
        
        doctorCollection.reloadData()
        let n = selectedDoctors.count
        if n == 0 {
            doctorCollectionHeight.constant = CGFloat(0)
        } else if n < 6 {
            doctorCollectionHeight.constant = CGFloat(50)
        } else if n % 6 == 0 {
            doctorCollectionHeight.constant = CGFloat((n / 6) * 50)
        } else {
            doctorCollectionHeight.constant = CGFloat(((n / 6) * 50) + 20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctors = coreDataHandler.fetchUser(of: .Doctor)
        doctorTableView.delegate = self
        doctorTableView.dataSource = self
        doctorSearchField.delegate = self
        
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
        
        selectDoctorsLabel.text = MyStrings.selectDoctors
        doctorSearchField.placeholder = MyStrings.search
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == doctorSearchField {
            textField.endEditing(true)
            return true
        } else {
            return false
        }
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
            if doctorTableViewHeight.constant > 250 {
                doctorTableViewHeight.constant = 250
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
        
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateStr = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = dateFormatter.string(from: timePicker.date)
        let dateTimeStr = dateStr + " " + timeStr

        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        let _ = dateFormatter.date(from: dateTimeStr)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField), subtitle: MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField)), animated: true, completion: nil)
    }
    
}

extension MRCreateMeetingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
        
        let doctor = doctors[indexPath.row]
        cell.nameLabel.text = "Dr. \(doctor.name!)"
        cell.specLabel.text = Specialities.specialities[doctor.speciality]
        
        if let img = doctor.profileImage {
            cell.profileImage.image = UIImage(data: img)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDoctors.append(doctors[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        
        doctorCollection.reloadData()
        let n = selectedDoctors.count
        if n == 0 {
            doctorCollectionHeight.constant = CGFloat(0)
        } else if n < 6 {
            doctorCollectionHeight.constant = CGFloat(50)
        } else if n % 6 == 0 {
            doctorCollectionHeight.constant = CGFloat((n / 6) * 50)
        } else {
            doctorCollectionHeight.constant = CGFloat(((n / 6) * 50) + 20)
        }
    }
    
}

extension MRCreateMeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedDoctors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "doctorCollectionCell", for: indexPath) as? DoctorCollectionViewCell {
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

        return cell
    }
    
    func removeDoctor(_ index: Int) {
        selectedDoctors.remove(at: index)
        doctorCollection.reloadData()
        let n = selectedDoctors.count
        if n == 0 {
            doctorCollectionHeight.constant = CGFloat(0)
        } else if n < 6 {
            doctorCollectionHeight.constant = CGFloat(50)
        } else if n % 6 == 0 {
            doctorCollectionHeight.constant = CGFloat((n / 6) * 50)
        } else {
            doctorCollectionHeight.constant = CGFloat(((n / 6) * 50) + 20)
        }
    }
    
}
