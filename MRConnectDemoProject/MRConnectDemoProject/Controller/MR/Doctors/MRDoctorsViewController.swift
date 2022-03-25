//
//  MRDoctorsViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class MRDoctorsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDocs: UILabel!
    
    let searchController = UISearchController()
    
    let mrDoctorsViewModel = MRDoctorsViewModel()
    
    var doctors: [Doctor] = []
    var copyDoctors: [Doctor] = []
    
    //var tappedDoctor: QueryDocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchResultsUpdater = self
        
        title = MyStrings.doctors
        navigationItem.searchController?.searchBar.placeholder = MyStrings.search
        noDocs.text = ""
        
        ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
        mrDoctorsViewModel.getDoctors { [weak self] doctors in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
                self?.doctors = doctors
                self?.copyDoctors = doctors
                
                self?.reloadTable()
            }
        }
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
        cell.configure(doctor)
        
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
        
        if !doctor.imageLink.isEmpty {
            mrDoctorsViewModel.getProfileImage(urlStr: doctor.imageLink) { imgData in
                guard let imgData = imgData else { return }
                cell.configImg(imgData: imgData)
            }
        }
        
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tappedDoctor = doctorDocuments[indexPath.row]
    //        performSegue(withIdentifier: "goToDetails", sender: self)
    //    }
    //    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "goToDetails" {
    //            let vc = segue.destination as! MRDoctorDetailsViewController
    //            vc.doctorDoc = tappedDoctor!.data()
    //        }
    //    }
    
}

//MARK: - UISearchResultsUpdating
extension MRDoctorsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchStr = searchController.searchBar.text ?? ""
        doctors = copyDoctors
        if !searchStr.isEmpty {
            doctors = doctors.filter({ doctor in
                return doctor.name.lowercased().contains(searchStr.lowercased())
            })
        }
        
        reloadTable()
    }
    
}

//MARK: - Reload Table
extension MRDoctorsViewController {
    
    func reloadTable() {
        if doctors.count == 0 {
            noDocs.isHidden = false
            noDocs.text = MyStrings.noDocs
        } else {
            noDocs.isHidden = true
        }
        
        tableView.reloadData()
    }
    
}

////MARK: - UITextFieldDelegate
//extension MRDoctorsViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.endEditing(true)
//        return true
//    }
//
//    func textFieldDidChangeSelection(_ textField: UITextField) {
////        if searchField.text == "" {
////            doctors = logic.getDoctors()
////            updateNoDocs()
////        } else {
////            doctors = logic.getDoctors(contains: searchField.text!)
////            updateNoDocs()
////        }
////
////        tableView.reloadData()
//
//        if searchField.text == "" {
//            print("Hello")
//            userCollecRef = database.collection("Users").whereField("type", isEqualTo: 1).order(by: "name")
//        } else {
//            let search = searchField.text!
//            userCollecRef = database.collection("Users").whereField("type", isEqualTo: 1).order(by: "name").start(at: [search]).end(at: [search + "~"])
//        }
//        getDocuments()
//    }
//
//}

////MARK: - Other
//extension MRDoctorsViewController {
//
//    func updateNoDocs() {
//        if doctorDocuments.count == 0 {
//            noDocs.isHidden = false
//            noDocs.text = MyStrings.noDocs
//        } else {
//            noDocs.isHidden = true
//        }
//    }
//
//}

