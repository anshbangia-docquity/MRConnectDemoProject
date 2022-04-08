//
//  SignInViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 24/01/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var mrButton: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var specialityButton: UIButton!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    var allUI: [UIControl] = []
        
    let signupViewModel = SignupViewModel()
    let alertManager = AlertManager()
    var type = UserType.MRUser
    var selectedSpec = -1
    
    lazy var specPicker = BulletinBoard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUI = [mrButton, doctorButton, nameField, contactField, numberField, specialityButton, emailField, passField, confirmPassField, signupButton]
        
        specPicker.delegate = self
        specPicker.define(of: .SpeckPicker)
        
        navItem.title = MyStrings.signup
        userTypeLabel.text = MyStrings.usertype
        mrButton.setTitle(MyStrings.mr, for: .normal)
        doctorButton.setTitle(MyStrings.doctor, for: .normal)
        nameField.placeholder = MyStrings.name
        contactField.placeholder = MyStrings.contact
        specialityButton.setTitle(MyStrings.specialization, for: .normal)
        emailField.placeholder = MyStrings.email
        passField.placeholder = MyStrings.password
        confirmPassField.placeholder = MyStrings.confirmPass
        signupButton.setTitle(MyStrings.signup, for: .normal)
        numberField.placeholder = MyStrings.licenseNumber
    }
    
    @IBAction func userTypePressed(_ sender: UIButton) {
        mrButton.isSelected = false
        doctorButton.isSelected = false
        
        sender.isSelected = true
        switch sender.currentTitle {
        case MyStrings.mr:
            type = .MRUser
            numberField.placeholder = MyStrings.licenseNumber
            specialityButton.isHidden = true
        default:
            type = .Doctor
            numberField.placeholder = MyStrings.mrNumber
            specialityButton.isHidden = false
        }
    }
    
    @IBAction func specButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        specPicker.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        ActivityIndicator.shared.start(on: view, label: MyStrings.signingUp)
        
        let request = SignupRequest(name: nameField.text, contact: contactField.text, email: emailField.text, password: passField.text, confirmPassword: confirmPassField.text, type: type.rawValue, license: numberField.text, mrnumber: numberField.text, speciality: selectedSpec)
        
        signupViewModel.signupUser(signupRequest: request) { [weak self] result in
            DispatchQueue.main.async {
                ActivityIndicator.shared.stop()
                if !result.success {
                    self?.alertManager.showAlert(on: self!, text: result.error!.getAlertMessage())
                } else {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

//MARK: - BulletinBoardDelegate
extension SignUpViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        specPicker.boardManager?.dismissBulletin()
        
        selectedSpec = selection as! Int
        let name = Specialities.specialities[selectedSpec]
        specialityButton.setTitleColor(.black, for: .normal)
        specialityButton.setTitle(name, for: .normal)
        specialityButton.backgroundColor = .white
    }
    
}



