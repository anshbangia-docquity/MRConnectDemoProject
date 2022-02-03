//
//  MRMedicinesViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRMedicinesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    let coreDataHandler = CoreDataHandler()
    var medicines: [Medicine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        medicines = coreDataHandler.fetchMedicines()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchField.delegate = self

        titleLabel.text = MyStrings.medicines
        searchField.placeholder = MyStrings.search
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchField.text == "" {
            medicines = coreDataHandler.fetchMedicines()
        } else {
            medicines = coreDataHandler.fetchMedicines(contains: textField.text!)
        }

        tableView.reloadData()
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        searchField.text = ""
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    func handler() {
        medicines = coreDataHandler.fetchMedicines()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            let vc = segue.destination as! MRCreateMedicineViewController
            vc.handler = handler
        }
    }
    
}

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MRMedicinesTableViewCell
        
        let medicine = medicines[indexPath.row]
        cell.medicineNameLabel.text = "\(medicine.name!)"
        cell.companyLabel.text = MyStrings.companyName.replacingOccurrences(of: "|#X#|", with: medicine.company!)
        
        return cell
    }
    
}

