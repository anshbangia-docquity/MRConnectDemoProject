//
//  Recording.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/03/22.
//

import Foundation

struct Recording {
    
    let link: String
    let duration: Float
    
    init(_ dict: [String: Any]) {
        link = dict["link"] as! String
        duration = dict["duration"] as! Float
    }
    
}
