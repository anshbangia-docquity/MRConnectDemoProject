//
//  MRCreateMedicineViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 27/01/22.
//

import UIKit

class MRCreateMedicineViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var companyField: UITextField!
    @IBOutlet weak var compositionField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var formSelector: UISegmentedControl!
    
    var form = "Capsule"
    var handler: (() -> Void)?
    
    @IBAction func createPressed(_ sender: UIButton) {
        if nameField.text == "" {
            showAlert(emptyField: "Medicine Name")
            return
        }
        if companyField.text == "" {
            showAlert(emptyField: "Company")
            return
        }
        if compositionField.text == "" {
            showAlert(emptyField: "Composition")
            return
        }
        if priceField.text == "" {
            showAlert(emptyField: "Price")
            return
        }
        
        let result = Logic.createMedicine(name: nameField.text!, company: companyField.text!, composition: companyField.text!, price: Float(priceField.text!) ?? 0.0, form: form)
        
        if result == false {
            showAlert(title: "Medicine was not created successfully.", subtitle: "Please try again.")
            return
        }
        
        handler!()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func formTapped(_ sender: UISegmentedControl) {
        form = sender.titleForSegment(at: sender.selectedSegmentIndex)!
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: "The \(emptyField) field cannot be empty.", subtitle: "Please fill your \(emptyField)."), animated: true, completion: nil)
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
}
