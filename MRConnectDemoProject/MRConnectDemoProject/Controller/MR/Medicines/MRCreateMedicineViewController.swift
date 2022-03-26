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
    
    var form = 0
    let user = CurrentUser()
    let mrCreateMedicineViewModel = MRCreateMedicineViewModel()
    let alertManager = AlertManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = MyStrings.createMed
        nameField.placeholder = MyStrings.medName
        companyField.placeholder = MyStrings.company
        compositionField.placeholder = MyStrings.composition
        priceField.placeholder = MyStrings.price
        formLabel.text = MyStrings.form
        
        for i in 0...3 {
            formSelector.setTitle(MedicineForm(rawValue: i)!.getStr(), forSegmentAt: i)
        }
        
        createButton.setTitle(MyStrings.create, for: .normal)
        cancelButton.setTitle(MyStrings.cancel, for: .normal)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func formTapped(_ sender: UISegmentedControl) {
        form = sender.selectedSegmentIndex
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        let createMedRequest = CreateMedicineRequest(name: nameField.text, company: companyField.text, composition: compositionField.text, price: priceField.text, type: form, creator: user.email
        )
        
        mrCreateMedicineViewModel.createMedicine(createMedRequest: createMedRequest) { [weak self] error in
            if let error = error {
                self?.alertManager.showAlert(on: self!, text: error.getAlertMessage())
            } else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("medAdded"), object: nil)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
