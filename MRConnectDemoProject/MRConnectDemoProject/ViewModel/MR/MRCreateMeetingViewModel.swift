//
//  MRCreateMeetingViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/03/22.
//

import Foundation

struct MRCreateMeetingViewModel {
    
    let dateFormatter = MyDateFormatter.shared.dateFormatter
    
    func createMeeting(createMeetingRequest: CreateMeetingRequest, meetingId: String? = nil, completion: @escaping (_ error: ErrorType?) -> Void) {
        let validationResult = CreateMeetingValidation().validate(createMeetingRequest: createMeetingRequest)
        
        if validationResult.success {
            let firestore = FirestoreHandler()
            
            firestore.saveMeeting(createMeetingRequest: createMeetingRequest, meetingId: meetingId)
            completion(nil)
        } else {
            completion(validationResult.error)
        }
        
    }
    
    func getDoctors(completion: @escaping (_ doctors: [Doctor]) -> Void) {
        let firestore = FirestoreHandler()
        var doctors: [Doctor] = []
        
        firestore.getDoctors { doctorDocuments in
            for document in doctorDocuments {
                let dict = document.data()
                doctors.append(Doctor(dict))
            }
            
            completion(doctors)
        }
    }
    
    func getMedicines(completion: @escaping (_ medicines: [Medicine]) -> Void) {
        let firestore = FirestoreHandler()
        var medicines: [Medicine] = []
        
        firestore.getMedicines { medDocuments in
            for document in medDocuments {
                let dict = document.data()
                medicines.append(Medicine(dict))
            }
            
            completion(medicines)
        }
    }
    
    func combineDateTime(date: Date, time: Date) -> Date {
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let dateStr = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH_mm"
        let timeStr = dateFormatter.string(from: time)
        
        let dateTimeStr = dateStr + "_" + timeStr
        dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm"
        let date = dateFormatter.date(from: dateTimeStr)
        
        return date!
    }
    
}
