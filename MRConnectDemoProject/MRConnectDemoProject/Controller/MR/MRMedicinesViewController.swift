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
    
    var medicines = Logic.fetchMedicines()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        titleLabel.text = MyStrings.medicines
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreate", sender: self)
    }
    
    func handler() {
        medicines = Logic.fetchMedicines()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreate" {
            let vc = segue.destination as! MRCreateMedicineViewController
            vc.handler = handler
        }
    }
    
}

extension MRMedicinesViewController: UITableViewDataSource {
    
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

extension MRMedicinesViewController: UITableViewDelegate {}
