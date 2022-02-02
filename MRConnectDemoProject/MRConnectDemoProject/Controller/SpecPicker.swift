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
    var spec: Int16 = Specialities.specialities.keys.first!
        
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        picker.delegate = self
        picker.dataSource = self
        return [picker]
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Specialities.specialities.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Specialities.specialities[Array(Specialities.specialities.keys)[row]]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        spec = Array(Specialities.specialities.keys)[row]
    }

}

protocol SpecPickerDelegate {
    func doneTapped(_ specPicker: SpecPicker, id: Int16, name: String)
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
            self.delegate?.doneTapped(self, id: item.spec, name: Specialities.specialities[item.spec]!)
        }

        boardManager = BLTNItemManager(rootItem: item)
        boardManager!.cardCornerRadius = 18
    }

}
