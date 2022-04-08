//
//  ProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 10/02/22.
//

import UIKit
import BLTNBoard

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changeNumberButton: UIButton!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var officeView: UIView!
    @IBOutlet weak var qualiView: UIView!
    @IBOutlet weak var expView: UIView!
    @IBOutlet weak var officeLabel: UILabel!
    @IBOutlet weak var qualiLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var officeTextView: UITextView!
    @IBOutlet weak var qualiTextView: UITextView!
    @IBOutlet weak var expTextView: UITextView!
    
    let user = CurrentUser()
    let imagePicker = UIImagePickerController()
    let bulletinBoard = BulletinBoard()
    let profileViewModel = ProfileViewModel()
    let alertManager = AlertManager()
    
    var textViewData: [UITextView: [String: String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewData[officeTextView] = ["placeholder": MyStrings.addOffice]
        textViewData[qualiTextView] = ["placeholder": MyStrings.addQuali]
        textViewData[expTextView] = ["placeholder": MyStrings.addExp]
        textViewData[officeTextView]!["text"] = user.office
        textViewData[qualiTextView]!["text"] = user.quali
        textViewData[expTextView]!["text"] = user.exp
        textViewData[officeTextView]!["key"] = "userOffice"
        textViewData[qualiTextView]!["key"] = "userQuali"
        textViewData[expTextView]!["key"] = "userExp"
        
        //addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        bulletinBoard.delegate = self
        officeTextView.delegate = self
        qualiTextView.delegate = self
        expTextView.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        titleLabel.text = MyStrings.profile
        
        if !user.imageLink.isEmpty {
            ActivityIndicator.shared.start(on: view, label: MyStrings.loading)
            
            profileViewModel.getProfileImage(urlStr: user.imageLink) { [weak self] imgData in
                ActivityIndicator.shared.stop()
                
                guard let imgData = imgData else { return }
                self?.profileImageView.image = UIImage(data: imgData)
            }
            
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
        } else {
            addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addImageButton.setTitle(MyStrings.add, for: .normal)
        }
        
        nameLabel.text = user.name
        emailLabel.text = user.email
        contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: user.contact)
        
        if user.type == .MRUser {
            officeView.isHidden = true
            qualiView.isHidden = true
            expView.isHidden = true
        } else {
            officeView.isHidden = false
            officeLabel.text = MyStrings.office
            setTextView(type: officeTextView, text: user.office)
            
            qualiView.isHidden = false
            qualiLabel.text = MyStrings.quali
            setTextView(type: qualiTextView, text: user.quali)
            
            expView.isHidden = false
            expLabel.text = MyStrings.exp
            setTextView(type: expTextView, text: user.exp)
        }
        
        changeNameButton.setTitle(MyStrings.changeName, for: .normal)
        changeNumberButton.setTitle(MyStrings.updateContact, for: .normal)
        changePassButton.setTitle(MyStrings.changePassword, for: .normal)
        logOutButton.setTitle(MyStrings.logOut, for: .normal)
        
    }
    
    @IBAction func changeNameTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .ChangeName)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func changeNumberTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .ChangeNumber)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func changePassTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .CheckPassword, additional: user.password)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        if profileViewModel.logOut() {
            presentingViewController?.dismiss(animated: true, completion:nil)
        } else {
            Alert.showAlert(on: self, title: MyStrings.errorOccured, subtitle: MyStrings.tryAgain)
        }
    }

    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
}

//MARK: - BulletinBoardDelegate
extension ProfileViewController: BulletinBoardDelegate {
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        bulletinBoard.boardManager?.dismissBulletin()
        
        switch type {
        case .ChangePassword:
            passwordChanged(newPass: selection as! String)
        case .ChangeNumber:
            numberChanged(newNum: selection as! String)
        case .ChangeName:
            nameChanged(newName: selection as! String)
        default:
            break
        }
    }
    
    func passwordChanged(newPass: String) {
        let confirmAlert = UIAlertController(title: MyStrings.changePassword, message: MyStrings.askChangePass, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.confirm, style: .default, handler: {[weak self] _ in
            ActivityIndicator.shared.start(on: self!.view, label: MyStrings.processing)
            
            self?.profileViewModel.changePassword(to: newPass) { error in
                DispatchQueue.main.async {
                    ActivityIndicator.shared.stop()
                    if let error = error {
                        self?.alertManager.showAlert(on: self!, text: error.getAlertMessage())
                    }
                }
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.cancel, style: .cancel, handler: nil))
        
        present(confirmAlert, animated: true)
    }
    
    func numberChanged(newNum: String) {
        if !NetworkMonitor.shared.isConnected {
            alertManager.showAlert(on: self, text: ErrorType.networkError.getAlertMessage())
        } else {
            profileViewModel.changeNumber(to: newNum, userId: user.id)
            DispatchQueue.main.async { [weak self] in
                self?.contactLabel.text = MyStrings.dispContact.replacingOccurrences(of: "|#X#|", with: self!.user.contact)
            }
        }
    }
    
    func nameChanged(newName: String) {
        if !NetworkMonitor.shared.isConnected {
            alertManager.showAlert(on: self, text: ErrorType.networkError.getAlertMessage())
        } else {
            profileViewModel.changeName(to: newName, userId: user.id)
            DispatchQueue.main.async { [weak self] in
                self?.nameLabel.text = self?.user.name
            }
        }
    }
    
}

//MARK: - UITextViewDelegate
extension ProfileViewController: UITextViewDelegate {
    
    func setTextView(type: UITextView, text: String? = nil) {
        if text == nil || text == "" {
            type.text = textViewData[type]!["placeholder"]
            type.textColor = .systemGray3
        } else {
            type.text = text
            type.textColor = .black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor != .black {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !NetworkMonitor.shared.isConnected {
            alertManager.showAlert(on: self, text: ErrorType.networkError.getAlertMessage())
            
            setTextView(type: textView, text: textViewData[textView]!["text"])
        } else {
            profileViewModel.changeInfo(userId: user.id, key: textViewData[textView]!["key"]!, newVal: textView.text ?? "")
            
            DispatchQueue.main.async { [weak self] in
                self?.setTextView(type: textView, text: textView.text)
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        ActivityIndicator.shared.start(on: view, label: MyStrings.processing)
    
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
            
            profileViewModel.saveProfileImage(img: img) {[weak self] error in
                DispatchQueue.main.async {
                    self?.profileViewModel.getProfileImage(urlStr: self!.user.imageLink, completion: { [weak self] imgData in
                        ActivityIndicator.shared.stop()
                        
                        guard let imgData = imgData else { return }
                        self?.profileImageView.image = UIImage(data: imgData)
                    })
                }
            }
        }
    }
    
}




