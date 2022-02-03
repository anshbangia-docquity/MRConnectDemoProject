//
//  DoctorProfileViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 26/01/22.
//

import UIKit

class DoctorProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    
    let userDefault = UserDefaultManager.shared.defaults
    var user: CurrentUser? = CurrentUser()
    let imagePicker = UIImagePickerController()
    let coreDataHandler = CoreDataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        
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
    
}
