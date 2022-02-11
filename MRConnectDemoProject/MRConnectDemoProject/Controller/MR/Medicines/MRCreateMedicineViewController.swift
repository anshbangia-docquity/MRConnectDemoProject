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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var form: Int16 = 0
    var handler: (() -> Void)?
    let logic = Logic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.createMed
        nameField.placeholder = MyStrings.medName
        companyField.placeholder = MyStrings.company
        compositionField.placeholder = MyStrings.composition
        priceField.placeholder = MyStrings.price
        formLabel.text = MyStrings.form
        
        for i in 0...3 {
            formSelector.setTitle(MedicineForms.forms[Int16(i)], forSegmentAt: i)
        }
        
        createButton.setTitle(MyStrings.create, for: .normal)
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func formTapped(_ sender: UISegmentedControl) {
        form = Int16(sender.selectedSegmentIndex)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        if nameField.text!.isEmpty {
            Alert.showAlert(on: self, emptyField: nameField.placeholder!)
            return
        }
        if companyField.text!.isEmpty {
            Alert.showAlert(on: self, emptyField: companyField.placeholder!)
            return
        }
        if compositionField.text!.isEmpty {
            Alert.showAlert(on: self, emptyField: compositionField.placeholder!)
            return
        }
        if priceField.text!.isEmpty {
            Alert.showAlert(on: self, emptyField: priceField.placeholder!)
            return
        }
        
        let result = logic.createMedicine(name: nameField.text!, company: companyField.text!, composition: compositionField.text!, price: Float(priceField.text!) ?? 0.0, form: form)
        
        if result == false {
            Alert.showAlert(on: self, notCreated: MyStrings.medicine)
            return
        }
        
        handler!()
        dismiss(animated: true, completion: nil)
    }
    
}