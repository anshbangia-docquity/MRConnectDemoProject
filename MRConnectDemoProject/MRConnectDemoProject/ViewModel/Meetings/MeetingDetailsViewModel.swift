//
//  MeetingDetailsViewModel.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/03/22.
//

import Foundation

struct MeetingDetailsViewModel {
    
    func getRecordings(meetingId: String, completion: @escaping (_ recordings: [Recording]) -> Void) {
        let firestore = FirestoreHandler()
        var recordings: [Recording] = []
        
        firestore.getRecordings(meetingId: meetingId) { recordingDocuments in
            for document in recordingDocuments {
                let dict = document.data()
                recordings.append(Recording(dict))
            }
            
            completion(recordings)
        }
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
    
    func getMedicines(medIds: [String], completion: @escaping (_ medicines: [Medicine]) -> Void) {
        let firestore = FirestoreHandler()
        var medicines: [Medicine] = []

        firestore.getMedicines(medIds: medIds) { doctorDocuments in
            for document in doctorDocuments {
                let dict = document.data()
                medicines.append(Medicine(dict))
            }

            completion(medicines)
        }
    }
    
    func calculateDuration(_ duration: Float) -> (Int, Int, Int) {
        let hr = Int((duration / 60) / 60)
        let min = Int(duration / 60)
        let sec = Int(duration.truncatingRemainder(dividingBy: 60))
        return (hr, min, sec)
    }
    
    func getRecordingData(urlStr: String, completion: @escaping (_ data: Data) -> Void) {
        let url = URL(string: urlStr)
        guard let url = url else {
            return
        }
        
        let data = try? Data(contentsOf: url)
        guard let data = data else {
            return
        }
        completion(data)
    }
    
    func saveRecording(recordingData: Data, path: String, saveRecordingRequest: SaveRecordingRequest, completion: @escaping () -> Void) {
        let storage = StorageHandler()
        
        storage.uploadFile(path: path, data: recordingData) { url in
            let urlStr = url.absoluteString
            var request = saveRecordingRequest
            request.link = urlStr
            
            let firestore = FirestoreHandler()
            firestore.saveRecording(saveRecordingRequest: request)
            firestore.addRecordingToMeeting(meeting: request.meeting, recordings: request.recordings)
            completion()
        }
    }
    
    func getMeeting(meetingId: String, completion: @escaping (_ meeting: Meeting) -> Void) {
        let firestore = FirestoreHandler()
        
        firestore.getMeeting(meetingId: meetingId) { meetingDoc in
            if let dict  = meetingDoc.data() {
                completion(Meeting(dict))
            }
        }
    }
    
}
