//
//  Medicine.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 25/03/22.
//

import Foundation

struct Medicine {
    
    let company: String
    let name: String
    let id: String
    let type: Int
    
    init(_ dict: [String: Any]) {
        company = (dict["company"] as? String) ?? "NA"
        name = (dict["name"] as? String) ?? "NA"
        id = (dict["id"] as? String) ?? ""
        type = (dict["type"] as? Int) ?? -1
    }
    
}
