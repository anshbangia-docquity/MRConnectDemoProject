//
//  CreateMeetingRequest.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/03/22.
//

import Foundation

struct CreateMeetingRequest {
    
    var title: String?
    var desc: String?
    var endDate: Date
    var startDate: Date
    var doctors: [String]
    var medicines: [String]
    var recordings: [String]
    var creator: String
    var hostName: String
    
}
