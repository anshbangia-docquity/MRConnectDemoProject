//
//  MRDoctorsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRDoctorsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    let coreDataHandler = CoreDataHandler()
    var doctors: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctors = coreDataHandler.fetchUser(of: .Doctor)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self

        titleLabel.text = MyStrings.doctors
        searchField.placeholder = MyStrings.search
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchField.text == "" {
            doctors = coreDataHandler.fetchUser(of: UserType.Doctor)
        } else {
            doctors = coreDataHandler.fetchUser(of: .Doctor, contains: searchField.text!)
        }

        tableView.reloadData()
    }
    
}

extension MRDoctorsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
    
}

