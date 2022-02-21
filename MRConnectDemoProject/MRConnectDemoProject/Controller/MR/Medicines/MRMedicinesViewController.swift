//
//  MRMedicinesViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRMedicinesViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var noMeds: UILabel!
    
    let logic = Logic()
    var medicines: [Medicine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        medicines = logic.getMedicines()
        updateNoMeds()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self
        tableView.allowsSelection = false

        titleLabel.text = MyStrings.medicines
        searchField.placeholder = MyStrings.search
        
        NotificationCenter.default.addObserver(self, selector: #selector(medAdded), name: Notification.Name("medAdded"), object: nil)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        searchField.text = ""
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    @objc func medAdded() {
        medicines = logic.getMedicines()
        updateNoMeds()
        tableView.reloadData()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewData Source
extension MRMedicinesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRMedicinesTableViewCell.id, for: indexPath) as! MRMedicinesTableViewCell
        
        let medicine = medicines[indexPath.row]
        cell.configure(med: medicine.name!, company: medicine.company!, type: medicine.form)
        
        cell.layer.maskedCorners = []
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if indexPath.row == medicines.count - 1 {
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
        if searchField.text == "" {
            medicines = logic.getMedicines()
            updateNoMeds()
        } else {
            medicines = logic.getMedicines(contains: textField.text!)
            updateNoMeds()
        }

        tableView.reloadData()
    }
    
}

//MARK: - Other
extension MRMedicinesViewController {
    
    func updateNoMeds() {
        if medicines.count == 0 {
            noMeds.isHidden = false
            noMeds.text = MyStrings.noMeds
        } else {
            noMeds.isHidden = true
        }
    }
    
}

