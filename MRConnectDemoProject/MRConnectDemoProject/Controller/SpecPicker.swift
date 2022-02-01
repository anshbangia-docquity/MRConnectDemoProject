//
//  SpecPicker.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 01/02/22.
//

import UIKit
import BLTNBoard

@objc public class PickerViewBLTNItem: BLTNPageItem {
    public lazy var picker = UIPickerView()
    
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        return [picker]
    }
}

protocol SpecPickerDelegate {
    func doneTapped(_ specPicker: SpecPicker)
}

class SpecPicker {
    
    var boardManager: BLTNItemManager?
    var delegate: SpecPickerDelegate?
    
    func define() {
        let item = PickerViewBLTNItem(title: "Specialization")
        item.actionButtonTitle = "Done"
        item.descriptionText = "Choose your Specialization"
        item.appearance.actionButtonColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        item.appearance.actionButtonTitleColor = .black
        item.appearance.titleFontSize = 25
        item.requiresCloseButton = false
        item.appearance.actionButtonFontSize = 20
        
        item.actionHandler = { _ in
            self.delegate?.doneTapped(self)
        }
        
        boardManager = BLTNItemManager(rootItem: item)
        boardManager!.cardCornerRadius = 18
    }
    
}
