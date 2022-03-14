//
//  FirstViewController.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 02/02/22.
//

import UIKit

class FirstViewController: UIViewController {
    
    let firstViewModel = FirstViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstViewModel.decideSegue {[weak self] segueIdentifier in
//            if segueIdentifier == SegueIdentifiers.goToLoginSignup {
//                DispatchQueue.main.async {
//                    self?.performSegue(withIdentifier: segueIdentifier, sender: self!)
//                }
//            } else {
//                print(segueIdentifier)
//            }
            DispatchQueue.main.async {
                self?.performSegue(withIdentifier: segueIdentifier, sender: self!)
            }
        }
    }
    
}

