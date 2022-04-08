//
//  CreateMeetingValidation.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/03/22.
//

import Foundation

struct CreateMeetingValidation {
    
    func validate(createMeetingRequest: CreateMeetingRequest) -> ValidationResult {
        if createMeetingRequest.title!.isEmpty {
            return ValidationResult(success: false, error: .emptyTitleField)
        }
        
        if (Date() > createMeetingRequest.startDate) || (createMeetingRequest.endDate <= createMeetingRequest.startDate) {
            return ValidationResult(success: false, error: .invalidTime)
        }
        
        if createMeetingRequest.doctors.isEmpty {
            return ValidationResult(success: false, error: .noDoctorsSelected)
        }
        
        if createMeetingRequest.medicines.isEmpty {
            return ValidationResult(success: false, error: .noMedicinesSelected)
        }
        
        
        return ValidationResult(success: true, error: nil)
    }
    
}
