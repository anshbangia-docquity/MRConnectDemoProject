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
    
    var form = "Capsule"
    var handler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Create Medicine".localize()
        nameField.placeholder = "medicine name".localize()
        companyField.placeholder = MyStrings.company
        compositionField.placeholder = MyStrings.composition
        priceField.placeholder = MyStrings.price
        formLabel.text = MyStrings.form
        formSelector.setTitle(MyStrings.capsule, forSegmentAt: 0)
        formSelector.setTitle(MyStrings.tablet, forSegmentAt: 1)
        formSelector.setTitle(MyStrings.syrup, forSegmentAt: 2)
        formSelector.setTitle(MyStrings.injection, forSegmentAt: 3)
        createButton.setTitle("Create".localize(), for: .normal)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        if nameField.text == "" {
            showAlert(emptyField: nameField.placeholder!)
            return
        }
        if companyField.text == "" {
            showAlert(emptyField: companyField.placeholder!)
            return
        }
        if compositionField.text == "" {
            showAlert(emptyField: compositionField.placeholder!)
            return
        }
        if priceField.text == "" {
            showAlert(emptyField: priceField.placeholder!)
            return
        }
        
        let result = Logic.createMedicine(name: nameField.text!, company: companyField.text!, composition: companyField.text!, price: Float(priceField.text!) ?? 0.0, form: form)
        
        if result == false {
            showAlert(title: "Medicine was not created successfully.".localize(), subtitle: "Please try again.".localize())
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
