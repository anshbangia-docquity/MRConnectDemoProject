//
//  MRMedicinesViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit
import FirebaseFirestore

class MRMedicinesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var noMeds: UILabel!
    
    //let logic = Logic()
    //var medicines: [Medicine] = []
    
    let database = Firestore.firestore()
    var medCollecRef: Query!
    var medDocuments: [QueryDocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medCollecRef = database.collection("Medicines").order(by: "company").order(by: "name")
        
        
        //medicines = logic.getMedicines()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self
        tableView.allowsSelection = false

        titleLabel.text = MyStrings.medicines
        searchField.placeholder = MyStrings.search
        
        NotificationCenter.default.addObserver(self, selector: #selector(medAdded), name: Notification.Name("medAdded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("yoooo api call")
        getDocuments()
    }
    
    func getDocuments() {
        medCollecRef.getDocuments { snapshot, error in
            guard error == nil else { return }
            self.medDocuments = snapshot?.documents ?? []
            self.tableView.reloadData()
            self.updateNoMeds()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        searchField.text = ""
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            let vc = segue.destination as! MRCreateMedicineViewController
            vc.medCount = medDocuments.count
        }
    }
    
    @objc func medAdded() {
        //getDocuments()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewData Source
extension MRMedicinesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return medicines.count
        return medDocuments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRMedicinesTableViewCell.id, for: indexPath) as! MRMedicinesTableViewCell
        
        //let medicine = medicines[indexPath.row]
        let medDoc = medDocuments[indexPath.row]
        let med = medDoc.data()
        cell.configure(med: med["name"] as! String, company: med["company"] as! String, type: med["form"] as! Int16)
        
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == medDocuments.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        
        return cell
    }
    
}

//MARK: - UITextFieldDelegate
extension MRMedicinesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if searchField.text == "" {
//            medCollecRef = database.collection("Medicines").order(by: "company").order(by: "name")
//        } else {
//            let search = searchField.text!
//            medCollecRef = database.collection("Medicines").order(by: "company").order(by: "name").whereField("name", isGreaterThanOrEqualTo: search).whereField("name", isLessThanOrEqualTo: search + "~")
//        }
//        getDocuments()
    }
    
}

//MARK: - Other
extension MRMedicinesViewController {
    
    func updateNoMeds() {
        if medDocuments.count == 0 {
            noMeds.isHidden = false
            noMeds.text = MyStrings.noMeds
        } else {
            noMeds.isHidden = true
        }
    }
    
}

