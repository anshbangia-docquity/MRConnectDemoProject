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
    
    let logic = Logic()
    var medicines: [Medicine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicines = logic.getMedicines()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self

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
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MRMedicinesTableViewCell.id, for: indexPath) as! MRMedicinesTableViewCell
        
        let medicine = medicines[indexPath.row]
        cell.medicineNameLabel.text = "\(medicine.name!)"
        cell.companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: medicine.company!)
        
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
        } else {
            medicines = logic.getMedicines(contains: textField.text!)
        }

        tableView.reloadData()
    }
    
}

