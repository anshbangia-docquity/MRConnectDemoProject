//
//  RecordItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 17/02/22.
//

import UIKit
import BLTNBoard

@objc public class RecordItem: BLTNPageItem {
    
    public var timeLabel: UILabel!
    public var recordButton: UIButton!
    public var animateView1: UIView!
    public var animateView2: UIView!
    public var stopButton: UIButton!
    
    public override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 237.5).isActive = true
        
        timeLabel = UILabel(frame: view.frame)
        view.addSubview(timeLabel)
        timeLabel.text = "00:00:00"
        timeLabel.font = timeLabel.font.withSize(22.5)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: view.topAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        recordButton = UIButton(frame: view.frame)
        view.addSubview(recordButton)
        recordButton.configuration = .plain()
        recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        recordButton.tintColor = .black
        recordButton.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 1)
        recordButton.layer.masksToBounds = true
        recordButton.layer.cornerRadius = 27.5
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 55),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 55),
            recordButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        animateView1 = UIView(frame: view.frame)
        view.addSubview(animateView1)
        view.sendSubviewToBack(animateView1)
        animateView1.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 0.5)
        animateView1.layer.masksToBounds = true
        animateView1.layer.cornerRadius = 27.5
        animateView1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animateView1.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            animateView1.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: 0),
            animateView1.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            animateView1.widthAnchor.constraint(equalTo: animateView1.heightAnchor)
        ])
        
        animateView2 = UIView(frame: view.frame)
        view.addSubview(animateView2)
        view.sendSubviewToBack(animateView2)
        animateView2.backgroundColor = UIColor(red: 125/255, green: 185/255, blue: 58/255, alpha: 0.25)
        animateView2.layer.masksToBounds = true
        animateView2.layer.cornerRadius = 27.5
        animateView2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animateView2.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            animateView2.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: 0),
            animateView2.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            animateView2.widthAnchor.constraint(equalTo: animateView2.heightAnchor)
        ])
        
        stopButton = UIButton(frame: view.frame)
        view.addSubview(stopButton)
        stopButton.configuration = .plain()
        stopButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        stopButton.tintColor = .black
        stopButton.backgroundColor = .systemGray3
        stopButton.layer.masksToBounds = true
        stopButton.layer.cornerRadius = 22.5
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 55),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 45),
            stopButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        return [view]
    }

}

