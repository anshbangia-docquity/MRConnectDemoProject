//
//  FirestoreHandler.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 13/03/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct FirestoreHandler {
    
    let firestore = Firestore.firestore()
    var userCollectionRef: CollectionReference {
        firestore.collection("Users")
    }
    var medCollectionRef: CollectionReference {
        firestore.collection("Medicines")
    }
    var meetingCollectionRef: CollectionReference {
        firestore.collection("Meetings")
    }
    var recordingCollectionRef: CollectionReference {
        firestore.collection("Recordings")
    }
    
    func getUser(userId: String, completion: @escaping (_ userDict: [String: Any]?) -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        
        userDocumentRef.getDocument { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.data())
            }
        }
    }
    
    func saveUser(userId: String, signupRequest: SignupRequest, completion: @escaping (_ error: ErrorType?) -> Void) {
        let userDocumentRef = userCollectionRef.document(userId)
        
        userDocumentRef.setData([
            "userId": userId,
            "userType": signupRequest.type,
            "userImageLink": "",
            "userPassword": signupRequest.password!,
            "userName": signupRequest.name!,
            "userEmail": signupRequest.email!,
            "userContact": signupRequest.contact!
        ]) { error in
            if error == nil {
                if signupRequest.type == UserType.Doctor.rawValue {
                    userDocumentRef.setData([
                        "userSpeciality": signupRequest.speciality,
                        "userQuali": "",
                        "userOffice": "",
                        "userMRNumber": signupRequest.mrnumber!,
                        "userExp": ""
                    ], merge: true) { error2 in
                        if error2 == nil {
                            completion(nil)
                        } else {
                            completion(.defaultError)
                        }
                    }
                } else {
                    userDocumentRef.setData([
                        "userLicenseNumber": signupRequest.license!
                    ], merge: true) { error3 in
                        if error3 == nil {
                            completion(nil)
                        } else {
                            completion(.defaultError)
                        }
                    }
                }
            } else {
                completion(.defaultError)
            }
        }
    }
    
    func updateInfo(userId: String, key: String, newVal: String) {
        let userDocumentRef = userCollectionRef.document(userId)
        userDocumentRef.setData([
            key: newVal
        ], merge: true)
    }
    
    func getDoctors(completion: @escaping (_ doctorDocuments: [QueryDocumentSnapshot]) -> Void) {
        let userCollecRef = self.userCollectionRef.whereField("userType", isEqualTo: 1).order(by: "userName")
        
        userCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func getDoctors(userIds: [String], completion: @escaping (_ doctorDocuments: [QueryDocumentSnapshot]) -> Void) {
        let userCollecRef = self.userCollectionRef.whereField("userId", in: userIds).order(by: "userName")

        userCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func getMedicines(completion: @escaping (_ medDocuments: [QueryDocumentSnapshot]) -> Void) {
        let medCollecRef = self.medCollectionRef.order(by: "company").order(by: "name")
        
        medCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func getMedicines(medIds: [String], completion: @escaping (_ medDocuments: [QueryDocumentSnapshot]) -> Void) {
        let medCollecRef = self.medCollectionRef.whereField("id", in: medIds).order(by: "name")

        medCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func saveMedicine(createMedRequest: CreateMedicineRequest) {
        let medDocumentRef = medCollectionRef.document()
        
        medDocumentRef.setData([
            "id": medDocumentRef.documentID,
            "name": createMedRequest.name!,
            "company": createMedRequest.company!,
            "compostion": createMedRequest.composition!,
            "price": Float(createMedRequest.price!)!,
            "type": createMedRequest.type,
            "creator": createMedRequest.creator
        ])
    }
    
    func getMeetings(_ collecRef: Query, completion: @escaping (_ meetingDocuments: [QueryDocumentSnapshot]) -> Void) {
        collecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func getMeetings(of mr: String, completion: @escaping (_ meetingDocuments: [QueryDocumentSnapshot]) -> Void) {
        let meetingCollecRef = self.meetingCollectionRef.whereField("creator", isEqualTo: mr).order(by: "startDate")
        
        getMeetings(meetingCollecRef) { meetingDocuments in
            completion(meetingDocuments)
        }
    }
    
    func getMeetings(for doctor: String, completion: @escaping (_ meetingDocuments: [QueryDocumentSnapshot]) -> Void) {
        let meetingCollecRef = self.meetingCollectionRef.whereField("doctors", arrayContains: doctor).order(by: "startDate")
        
        getMeetings(meetingCollecRef) { meetingDocuments in
            completion(meetingDocuments)
        }
    }
    
    func getMeeting(meetingId: String, completion: @escaping (_ meetingDoc: DocumentSnapshot) -> Void) {
        let meetingDocumentRef = meetingCollectionRef.document(meetingId)
        
        meetingDocumentRef.getDocument { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot)
            }
        }
    }
    
    func saveMeeting(createMeetingRequest: CreateMeetingRequest, meetingId: String? = nil) {
        var meetingDocumentRef: DocumentReference
        if let meetingId = meetingId {
            meetingDocumentRef = meetingCollectionRef.document(meetingId)
        } else {
            meetingDocumentRef = meetingCollectionRef.document()
        }
        
        meetingDocumentRef.setData([
            "id": meetingDocumentRef.documentID,
            "title": createMeetingRequest.title!,
            "desc": createMeetingRequest.desc ?? "",
            "endDate": createMeetingRequest.endDate,
            "startDate": createMeetingRequest.startDate,
            "doctors": createMeetingRequest.doctors,
            "medicines": createMeetingRequest.medicines,
            "recordings": createMeetingRequest.recordings,
            "creator": createMeetingRequest.creator,
            "hostName": createMeetingRequest.hostName
        ])
    }
    
    func addRecordingToMeeting(meeting: String, recordings: [String]) {
        let meetingDocumentRef = meetingCollectionRef.document(meeting)
        meetingDocumentRef.setData([
            "recordings": recordings
        ], merge: true)
    }
    
    func getRecordings(meetingId: String, completion: @escaping (_ recordingDocuments: [QueryDocumentSnapshot]) -> Void) {
        let recordingCollecRef = self.recordingCollectionRef.whereField("meeting", isEqualTo: meetingId).order(by: "fileName")
        
        recordingCollecRef.getDocuments { snapshot, error in
            if error == nil, let snapshot = snapshot {
                completion(snapshot.documents)
            }
        }
    }
    
    func saveRecording(saveRecordingRequest: SaveRecordingRequest) {
        let recordingDocRef = recordingCollectionRef.document()
        
        recordingDocRef.setData([
            "id": recordingDocRef.documentID,
            "link": saveRecordingRequest.link!,
            "meeting": saveRecordingRequest.meeting,
            "fileName": saveRecordingRequest.fileName,
            "duration": saveRecordingRequest.duration
        ])
    }
}
