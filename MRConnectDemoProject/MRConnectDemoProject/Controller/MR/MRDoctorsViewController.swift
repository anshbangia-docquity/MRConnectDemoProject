//
//  MRDoctorsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRDoctorsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    let logic = Logic()
    var doctors: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctors = logic.getDoctors()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self

        titleLabel.text = MyStrings.doctors
        searchField.placeholder = MyStrings.search
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MRDoctorsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
        
        let doctor = doctors[indexPath.row]
        cell.configure(name: doctor.name!, spec: doctor.speciality)
        
        if let img = doctor.profileImage {
            cell.configImg(imgData: img)
        }
        
        return cell
    }
    
}

//MARK: - UITextFieldDelegate
extension MRDoctorsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchField.text == "" {
            doctors = logic.getDoctors()
        } else {
            doctors = logic.getDoctors(contains: searchField.text!)
        }

        tableView.reloadData()
    }
    
}

