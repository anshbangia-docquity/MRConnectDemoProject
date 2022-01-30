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
    
    let doctors = Logic.fetchUser(of: UserType.Doctor)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        titleLabel.text = "Your \(tabBarItem.title ?? "")"
        
    }

}

extension MRDoctorsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MRDoctorsTableViewCell
        
        let doctor = doctors[indexPath.row]
        let spec = Logic.fetchSpec(with: doctor.speciality)
        cell.nameLabel.text = "Dr. \(doctor.name!)"
        cell.specLabel.text = spec
        
        return cell
    }
    
}

extension MRDoctorsViewController: UITableViewDelegate {}
