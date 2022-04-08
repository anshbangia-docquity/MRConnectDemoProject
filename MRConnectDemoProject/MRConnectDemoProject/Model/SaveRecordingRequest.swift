//
//  SaveRecordingRequest.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 28/03/22.
//

import Foundation

struct SaveRecordingRequest {
    
    // duration
    var link: String?
    var meeting: String
    var recordings: [String]
    var fileName: String
    var duration: Float
    
}
