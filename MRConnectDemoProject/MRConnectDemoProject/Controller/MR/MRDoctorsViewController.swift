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
    
    var doctors = Logic.fetchUser(of: UserType.Doctor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self

        titleLabel.text = MyStrings.doctors
        
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
            doctors = Logic.fetchUser(of: UserType.Doctor)
        } else {
            doctors = Logic.fetchUser(of: .Doctor, contains: searchField.text!)
        }

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension MRDoctorsViewController: UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MRDoctorsTableViewCell
        
        let doctor = doctors[indexPath.row]
        //let spec = Logic.fetchSpec(with: doctor.speciality)
        cell.nameLabel.text = "Dr. \(doctor.name!)"
        cell.specLabel.text = Logic.specialities[doctor.speciality]
        
        return cell
    }
    
}

extension MRDoctorsViewController: UITableViewDelegate {}
