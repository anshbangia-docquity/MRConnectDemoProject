//
//  ActivityIndicator.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 14/03/22.
//

import UIKit

struct ActivityIndicator {
    
    static var shared = ActivityIndicator()
    
    var activityIndicator: UIActivityIndicatorView?
    var activityLabel: UILabel?
    //let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let effectView = UIView()
    var view: UIView?
    
    mutating func start(on view: UIView, label: String) {
        view.isUserInteractionEnabled = false
        self.view = view
        activityIndicator(title: label, view: view)
    }
    
    mutating func stop() {
        effectView.removeFromSuperview()
        view?.isUserInteractionEnabled = true
        view = nil
    }
    
    mutating func activityIndicator(title: String, view: UIView) {
        activityLabel?.removeFromSuperview()
        activityIndicator?.removeFromSuperview()
        
        activityLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        activityLabel!.text = title
        activityLabel!.font = .systemFont(ofSize: 17, weight: .medium)
        activityLabel!.textColor = .black
        
        effectView.frame = CGRect(x: view.frame.midX - activityLabel!.frame.width/2, y: view.frame.midY - activityLabel!.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 23
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator?.color = .black
        activityIndicator!.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator!.startAnimating()
        
        effectView.backgroundColor = .systemGray5
        effectView.addSubview(activityIndicator!)
        effectView.addSubview(activityLabel!)
        view.addSubview(effectView)
    }
    
}
