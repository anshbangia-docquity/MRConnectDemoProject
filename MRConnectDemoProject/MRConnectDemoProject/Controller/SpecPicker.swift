//
//  SpecPicker.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 01/02/22.
//

import UIKit
import BLTNBoard

@objc public class PickerViewBLTNItem: BLTNPageItem, UIPickerViewDelegate, UIPickerViewDataSource {
    
    public lazy var picker = UIPickerView()
    
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        picker.delegate = self
        picker.dataSource = self
        return [picker]
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Logic.specialities.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Logic.specialities[Int16(row)]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Logic.seletedSpec = Int16(row)
    }
    
}

protocol SpecPickerDelegate {
    func doneTapped(_ specPicker: SpecPicker)
}

class SpecPicker {
    
    var boardManager: BLTNItemManager?
    var delegate: SpecPickerDelegate?
    
    func define() {
        let item = PickerViewBLTNItem(title: MyStrings.specialization)
        item.actionButtonTitle = MyStrings.done
        item.descriptionText = MyStrings.chooseSpec
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
