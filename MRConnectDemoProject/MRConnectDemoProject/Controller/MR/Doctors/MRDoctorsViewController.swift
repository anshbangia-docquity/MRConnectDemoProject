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
    @IBOutlet weak var noDocs: UILabel!
    
    let logic = Logic()
    var doctors: [User] = []
    var tappedDoctor: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doctors = logic.getDoctors()
        updateNoDocs()
        
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
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
        
        let doctor = doctors[indexPath.row]
        cell.configure(name: doctor.name!, spec: doctor.speciality, email: doctor.email!, contact: doctor.contact!, office: doctor.office!)
        
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == doctors.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        
        if let img = doctor.profileImage {
            cell.configImg(imgData: img)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedDoctor = doctors[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let vc = segue.destination as! MRDoctorDetailsViewController
            vc.doctor = tappedDoctor
        }
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
            updateNoDocs()
        } else {
            doctors = logic.getDoctors(contains: searchField.text!)
            updateNoDocs()
        }

        tableView.reloadData()
    }
    
}

//MARK: - Other
extension MRDoctorsViewController {
    
    func updateNoDocs() {
        if doctors.count == 0 {
            noDocs.isHidden = false
            noDocs.text = MyStrings.noDocs
        } else {
            noDocs.isHidden = true
        }
    }
    
}

