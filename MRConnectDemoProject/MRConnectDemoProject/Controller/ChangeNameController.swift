//
//  ChangeNameController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 04/02/22.
//

import UIKit
import BLTNBoard

@objc public class ChangeNameBLTNItem: BLTNPageItem {

    public lazy var nameField = UITextField()
        
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        nameField.placeholder = MyStrings.newName
        nameField.borderStyle = UITextField.BorderStyle.roundedRect
        nameField.autocorrectionType = UITextAutocorrectionType.no
        nameField.keyboardType = UIKeyboardType.default
        nameField.textContentType = .name
        nameField.autocapitalizationType = .words
        nameField.returnKeyType = UIReturnKeyType.done
        
        return [nameField]
    }

}

protocol ChangeNameDelegate {
    func doneTapped(_ changeNameController: ChangeNameController, newName: String)
}

class ChangeNameController {

    var boardManager: BLTNItemManager?
    var delegate: ChangeNameDelegate?

    func define() {
        let item = ChangeNameBLTNItem(title: MyStrings.changeName)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.editName
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20

        item.actionHandler = { _ in
            self.delegate?.doneTapped(self, newName: item.nameField.text!)
        }

        boardManager = BLTNItemManager(rootItem: item)
        boardManager!.cardCornerRadius = 18
    }

}
