//
//  Gradient.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 09/02/22.
//

import Foundation
import QuartzCore
import UIKit

func setGradientBackground() -> CAGradientLayer {
    let colorTop =  UIColor(red: 125.0/255.0, green: 185.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
    let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.3, 1.0]
    return gradientLayer
}
