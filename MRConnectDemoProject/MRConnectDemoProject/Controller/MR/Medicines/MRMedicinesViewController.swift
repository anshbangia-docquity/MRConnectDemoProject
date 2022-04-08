//
//  MRMedicinesViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRMedicinesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noMeds: UILabel!
    
    let searchController = UISearchController()
    
    let mrMedicinesViewModel = MRMedicinesViewModel()
    
    var medicines: [Medicine] = []
    var copyMedicines: [Medicine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self

        title = MyStrings.medicines
        navigationItem.searchController?.searchBar.placeholder = MyStrings.search
        noMeds.text = ""
        
        refreshData()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name("medAdded"), object: nil)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.goToCreate, sender: self)
    }
    
    @objc func refreshData() {
        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        mrMedicinesViewModel.getMedicines { [weak self] medicines in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
                self?.medicines = medicines
                self?.copyMedicines = medicines
                
                self?.reloadTable()
            }
        }
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
        cell.configure(medicine)
        
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


//MARK: - UISearchResultsUpdating
extension MRMedicinesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchStr = searchController.searchBar.text ?? ""
        medicines = copyMedicines
        if !searchStr.isEmpty {
            var set = Set<String>()
            let meds1 = medicines.filter({ medicine in
                if medicine.company.lowercased().contains(searchStr.lowercased()) {
                    set.insert(medicine.id)
                    return true
                } else {
                    return false
                }
            })
            let meds2 = medicines.filter({ medicine in
                return medicine.name.lowercased().contains(searchStr.lowercased())
            })
            medicines = meds1
            meds2.forEach { med in
                if !set.contains(med.id) {
                    medicines.append(med)
                }
            }
        }
        
        reloadTable()
    }
    
}

//MARK: - Reload Table
extension MRMedicinesViewController {
    
    func reloadTable() {
        if medicines.count == 0 {
            noMeds.isHidden = false
            noMeds.text = MyStrings.noMeds
        } else {
            noMeds.isHidden = true
        }
        
        tableView.reloadData()
    }
    
}

