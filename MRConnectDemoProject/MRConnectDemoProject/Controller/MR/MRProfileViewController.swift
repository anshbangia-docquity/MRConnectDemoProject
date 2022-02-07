//
//  MRProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit
import BLTNBoard

class MRProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BulletinBoardDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changeNameButton: UIButton!
    @IBOutlet weak var changePassButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    let userDefault = UserDefaultManager.shared.defaults
    var user: CurrentUser? = CurrentUser()
    let imagePicker = UIImagePickerController()
    let coreDataHandler = CoreDataHandler()
    let bulletinBoard = BulletinBoard()
    let logic = Logic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        
        bulletinBoard.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        if let img = user?.profileImage {
            profileImageView.image = img
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
        } else {
            addImageButton.setImage(UIImage(systemName: "plus"), for: .normal)
            addImageButton.setTitle(MyStrings.add, for: .normal)
        }
        
        titleLabel.text = MyStrings.profile
        nameLabel.text = user?.name
        emailLabel.text = user?.email
        changeNameButton.setTitle(MyStrings.changeName, for: .normal)
        changePassButton.setTitle(MyStrings.changePassword, for: .normal)
        logOutButton.setTitle(MyStrings.logOut, for: .normal)
        
    }
    
    @IBAction func changeNameTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .ChangeName)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    @IBAction func changePassTapped(_ sender: UIButton) {
        bulletinBoard.define(of: .CheckPassword)
        bulletinBoard.boardManager?.showBulletin(above: self)
    }
    
    func doneTapped(_ bulletinBoard: BulletinBoard, selection: Any, type: BulletinTypes) {
        bulletinBoard.boardManager?.dismissBulletin()
        
        switch type {
        case .ChangeName:
            nameChanged(newName: selection as! String)
        case .ChangePassword:
            passwordChanged(newPass: selection as! String)
        default:
            break
        }
    }
    
    func nameChanged(newName: String) {
        let result = logic.updateName(email: user!.email, newName: newName)
        if result == false {
            showAlert(title: MyStrings.nameNotUpdated, subtitle: MyStrings.errorNameChange)
            return
        }
        userDefault.setValue(newName, forKey: "userName")
        nameLabel.text = user?.name
    }
    
    func passwordChanged(newPass: String) {
        var result = true
        var pass = user?.password
        let confirmAlert = UIAlertController(title: MyStrings.changePassword, message: MyStrings.askChangePass, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: MyStrings.confirm, style: .default, handler: { (action: UIAlertAction!) in
            result = self.logic.updatePassword(email: self.user!.email, newPass: newPass)
            pass = newPass
        }))

        confirmAlert.addAction(UIAlertAction(title: MyStrings.cancel, style: .cancel, handler: nil))

        present(confirmAlert, animated: true) {
            if result {
                self.userDefault.setValue(pass, forKey: "userPassword")
            } else {
                self.showAlert(title: MyStrings.passNotUpdated, subtitle: MyStrings.errorPassChange)
            }
        }
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let result = coreDataHandler.saveProfileImage(user!.email, image: img)
            if result == false {
                showAlert(title: MyStrings.imageNotChosen, subtitle: MyStrings.errorImage)
                return
            }
            profileImageView.image = img
            addImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            addImageButton.setTitle(MyStrings.edit, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        userDefault.removeObject(forKey: "email")
        userDefault.removeObject(forKey: "password")
        userDefault.removeObject(forKey: "userType")
        userDefault.removeObject(forKey: "userSpeciality")
        userDefault.removeObject(forKey: "userPassword")
        userDefault.removeObject(forKey: "userName")
        userDefault.removeObject(forKey: "userMRNumber")
        userDefault.removeObject(forKey: "userLicense")
        userDefault.removeObject(forKey: "userEmail")
        userDefault.removeObject(forKey: "userContact")

        userDefault.setValue(true, forKey: "authenticate")
        
        user = nil
        
        self.presentingViewController?.dismiss(animated: true, completion:nil)
    }
    
    func showAlert(title: String, subtitle: String) {
        self.present(Alert.showAlert(title: title, subtitle: subtitle), animated: true, completion: nil)
    }
    
    func showAlert(emptyField: String) {
        self.present(Alert.showAlert(title: MyStrings.emptyFieldAlertTitle.replacingOccurrences(of: "|#X#|", with: emptyField), subtitle: MyStrings.emptyFieldAlertSubtitle.replacingOccurrences(of: "|#X#|", with: emptyField)), animated: true, completion: nil)
    }
    
}
