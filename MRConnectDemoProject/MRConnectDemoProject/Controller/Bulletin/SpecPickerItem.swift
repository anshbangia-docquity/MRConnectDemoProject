//
//  SpecPickerItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 05/02/22.
//

import UIKit
import BLTNBoard

@objc public class SpecPickerItem: BLTNPageItem {

    public lazy var picker = UIPickerView()
    var spec: Int = Specialities.specialities.keys.first!
    
    override public func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        picker.delegate = self
        picker.dataSource = self
        return [picker]
    }

}

extension SpecPickerItem: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
