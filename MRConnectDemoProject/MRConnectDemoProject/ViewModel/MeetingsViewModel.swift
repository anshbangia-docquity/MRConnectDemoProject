//
//  MeetingsViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/03/22.
//

import Foundation
import FirebaseFirestore

struct MeetingsViewModel {
    
    let dateFormatter = MyDateFormatter.shared.dateFormatter
    
    func getMeetings(userId: String, userType: UserType, completion: @escaping (_ meetings: [Meeting]) -> Void) {
        let firestore = FirestoreHandler()
        var meetings: [Meeting] = []
        
        let handler = { (meetingDocuments: [QueryDocumentSnapshot]) in
            for document in meetingDocuments {
                let dict = document.data()
                meetings.append(Meeting(dict))
            }
            
            completion(meetings)
        }
        
        switch userType {
        case .MRUser:
            firestore.getMeetings(of: userId, completion: handler)
        case .Doctor:
            firestore.getMeetings(for: userId, completion: handler)
        }
    }
    
    func processMeetingDates(meetings: [Meeting]) -> ([String], [String: [Meeting]]) {
        dateFormatter.dateFormat = "yyyy_MM_dd"
        var meetingDates: [String: [Meeting]] = [:]
        var dates: [String] = []
        
        for meeting in meetings {
            let dateStr = dateFormatter.string(from: meeting.startDate)
            if meetingDates[dateStr] == nil {
                meetingDates[dateStr] = []
                dates.append(dateStr)
            }
            meetingDates[dateStr]!.append(meeting)
        }
        
        return (dates, meetingDates)
    }
    
    func getDoctors(userIds: [String], completion: @escaping (_ doctors: [Doctor]) -> Void) {
        let firestore = FirestoreHandler()
        var doctors: [Doctor] = []

        firestore.getDoctors(userIds: userIds) { doctorDocuments in
            for document in doctorDocuments {
                let dict = document.data()
                doctors.append(Doctor(dict))
            }

            completion(doctors)
        }
    }
    
}
