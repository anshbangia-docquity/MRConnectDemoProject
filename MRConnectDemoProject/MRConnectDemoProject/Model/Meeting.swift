//
//  Meeting.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/03/22.
//

import Foundation
import FirebaseFirestore

struct Meeting {
    
    let startDate: Date
    let title: String
    let endDate: Date
    let doctors: [String]
    let recordings: [String]
    
    init(_ dict: [String: Any]) {
        var timeStamp = dict["startDate"] as! Timestamp
        startDate = timeStamp.dateValue()
        timeStamp = dict["endDate"] as! Timestamp
        endDate = timeStamp.dateValue()
        
        title = dict["title"] as! String
        doctors = dict["doctors"] as! [String]
        recordings = dict["recordings"] as! [String]
    }
    
}
