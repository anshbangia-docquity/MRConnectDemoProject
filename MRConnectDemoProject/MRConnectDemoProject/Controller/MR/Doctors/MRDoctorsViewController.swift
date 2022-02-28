//
//  MRDoctorsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit
import FirebaseFirestore

class MRDoctorsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var noDocs: UILabel!
    
    //let logic = Logic()
    //var doctors: [User] = []
    var tappedDoctor: QueryDocumentSnapshot?
    
    let database = Firestore.firestore()
    var userCollecRef: Query!
    //var listner: ListenerRegistration!
    var doctorDocuments: [QueryDocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCollecRef = database.collection("Users").whereField("type", isEqualTo: 1).order(by: "name")
        
        //doctors = logic.getDoctors()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self
        
        titleLabel.text = MyStrings.doctors
        searchField.placeholder = MyStrings.search
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDocuments()
    }
    
    func getDocuments() {
        userCollecRef.getDocuments { snaphot, error in
            guard error == nil else { return }
            self.doctorDocuments = snaphot?.documents ?? []
            self.tableView.reloadData()
            self.updateNoDocs()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //listner.remove()
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
        //return doctors.count
        return doctorDocuments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRDoctorsTableViewCell.id, for: indexPath) as! MRDoctorsTableViewCell
        
        //let doctor = doctors[indexPath.row]
        let doctorDoc = doctorDocuments[indexPath.row]
        let doctor = doctorDoc.data()
//        cell.configure(name: doctor.name!, spec: doctor.speciality, email: doctor.email!, contact: doctor.contact!, office: doctor.office!)
        cell.configure(name: doctor["name"] as! String, spec: doctor["speciality"] as! Int16, email: doctor["email"] as! String, contact: doctor["contact"] as! String, office: doctor["office"] as! String)

        
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == doctorDocuments.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        
//        if let img = doctor.profileImage {
//            cell.configImg(imgData: img)
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedDoctor = doctorDocuments[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetails" {
            let vc = segue.destination as! MRDoctorDetailsViewController
            vc.doctorDoc = tappedDoctor!
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
//        if searchField.text == "" {
//            doctors = logic.getDoctors()
//            updateNoDocs()
//        } else {
//            doctors = logic.getDoctors(contains: searchField.text!)
//            updateNoDocs()
//        }
//        
//        tableView.reloadData()

        if searchField.text == "" {
            print("Hello")
            userCollecRef = database.collection("Users").whereField("type", isEqualTo: 1).order(by: "name")
        } else {
            let search = searchField.text!
            userCollecRef = database.collection("Users").whereField("type", isEqualTo: 1).order(by: "name").start(at: [search]).end(at: [search + "~"])
        }
        getDocuments()
    }
    
}

//MARK: - Other
extension MRDoctorsViewController {
    
    func updateNoDocs() {
        if doctorDocuments.count == 0 {
            noDocs.isHidden = false
            noDocs.text = MyStrings.noDocs
        } else {
            noDocs.isHidden = true
        }
    }
    
}

