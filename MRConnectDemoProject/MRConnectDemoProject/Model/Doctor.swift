//
//  Doctor.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 25/03/22.
//

import Foundation

struct Doctor {
    
    let name: String
    let speciality: Int
    let email: String
    let contact: String
    let office: String
    let imageLink: String
    
    init(_ dict: [String: Any]) {
        name = (dict["userName"] as? String) ?? "NA"
        speciality = (dict["userSpeciality"] as? Int) ?? -1
        email = (dict["userEmail"] as? String) ?? "NA"
        contact = (dict["userContact"] as? String) ?? "NA"
        office = (dict["userOffice"] as? String) ?? ""
        imageLink = (dict["userImageLink"] as? String) ?? ""
    }
    
}
