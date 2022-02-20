//
//  RecordItem.swift
//  MRConnectDemoProject
//
//  Created by Ansh Bangia on 17/02/22.
//

import UIKit
import BLTNBoard
import AVFoundation

@objc public class RecordItem: BLTNPageItem {
    
    public var timeLabel: UILabel!
    public var recordButton: UIButton!
    public var animateView1: UIView!
    public var animateView2: UIView!
    public var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var timer: Timer!
    
    var isRecording = false
    var isRecordingPaused = false
    var recordingFileName: String?
    var logic = Logic()
    var meeting: Int16 = -1
    @objc public var saveRecording: ((Bool, String?, AVAudioRecorder?) -> Void)? = nil
    
    var anim1constraint: NSLayoutConstraint!
    var anim2constraint: NSLayoutConstraint!
    
    public override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
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
        recordButton.addTarget(self, action: #selector(recordPressed), for: .touchUpInside)
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
        anim1constraint = animateView1.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: 0)
        NSLayoutConstraint.activate([
            animateView1.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            anim1constraint,
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
        anim2constraint = animateView2.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: 0)
        NSLayoutConstraint.activate([
            animateView2.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            anim2constraint,
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
        stopButton.addTarget(self, action: #selector(stopPressed), for: .touchUpInside)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stopButton.leftAnchor.constraint(equalTo: recordButton.rightAnchor, constant: 75),
            stopButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            stopButton.widthAnchor.constraint(equalToConstant: 45),
            stopButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        stopButton.isEnabled = false
        
        return [view]
    }
    
    public override func onDismiss() {
        if isRecording {
            audioRecorder.stop()
            timer.invalidate()
            audioRecorder.deleteRecording()
            audioRecorder = nil
        }
    }
    

}

//MARK: - Audio Recorder
extension RecordItem {
    
    func getNewFileUrl() -> URL {
        logic.dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        let dateStr = logic.dateFormatter.string(from: Date())
        let filename = "meeting_\(meeting)_recording_" + dateStr + ".m4a"
        let filePath = logic.getDocumentsDirectory().appendingPathComponent(filename)
        recordingFileName = filename
        print(filePath)
        return filePath
    }
    
    func setup_recorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            audioRecorder = try AVAudioRecorder(url: getNewFileUrl(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
        } catch let error {
            print("ERROR: \(error)")
        }
    }
    
    @objc func recordPressed() {
        //super.isDismissable = false
        
        if isRecording == false {
            setup_recorder()
            audioRecorder.record()
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.125, repeats: true, block: {_ in self.updateAudioTimer()})
            recordButton.setImage(UIImage(systemName: "pause"), for: .normal)
            stopButton.isEnabled = true
            isRecording = true
            isRecordingPaused = false
            
        } else if isRecording == true {
            if isRecordingPaused == false {
                audioRecorder.pause()
                recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
                isRecordingPaused = true
                
                resetAnimation()
            } else if isRecordingPaused == true {
                audioRecorder.record()
                recordButton.setImage(UIImage(systemName: "pause"), for: .normal)
                isRecordingPaused = false
            }
        }
    }
    
    @objc func stopPressed() {
        stopRecording(success: true)
        
        saveRecording?(true, recordingFileName, audioRecorder)
        audioRecorder = nil
    }
    
    @objc func deleteRecording() {
        audioRecorder.deleteRecording()
    }
    
    func stopRecording(success : Bool) {
        if success {
            audioRecorder.stop()
            
            timer.invalidate()
            
            recordButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
            stopButton.isEnabled = false
            isRecording = false
            isRecordingPaused = false
            
            resetAnimation()
        } else {
            saveRecording?(false, nil, nil)
        }
    }
}

//MARK: - AVAudioRecorderDelegate
extension RecordItem: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(success: false)
        }
    }
    
}

//MARK: - Other
extension RecordItem {
    
    func updateAudioTimer() {
        if audioRecorder.isRecording {
            var hr: Int
            var min: Int
            var sec: Int
            (hr, min, sec) = logic.getAudioTime(time: audioRecorder.currentTime)
            let timeStr = String(format: "%02d:%02d:%02d", hr, min, sec)
            timeLabel.text = timeStr
            
            audioRecorder.updateMeters()
            let power = audioRecorder.averagePower(forChannel: 0)
            
            let oldMax: Float = -10
            let oldMin: Float = -35
            let oldRange = oldMax - oldMin
            let newMax: Float = 93.75
            let newMin: Float = 0
            let newRange = newMax - newMin
            let newValue: Float
            if power > oldMin {
                newValue = (((power - oldMin) * newRange) / oldRange) + newMin
            } else {
                newValue = 0
            }
            
            NSLayoutConstraint.deactivate([
                anim1constraint,
                anim2constraint
            ])
            anim1constraint = animateView1.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: CGFloat(newValue))
            anim2constraint = animateView2.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: CGFloat(newValue * 2))
            NSLayoutConstraint.activate([
                anim1constraint,
                anim2constraint
            ])
            
            animateView1.layer.cornerRadius = CGFloat(newValue + 55) / 2
            animateView2.layer.cornerRadius = CGFloat((newValue * 2) + 55) / 2
        }
    }
    
    func resetAnimation() {
        NSLayoutConstraint.deactivate([
            anim1constraint,
            anim2constraint
        ])
        anim1constraint = animateView1.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: 0)
        anim2constraint = animateView2.widthAnchor.constraint(equalTo: recordButton.widthAnchor, constant: 0)
        NSLayoutConstraint.activate([
            anim1constraint,
            anim2constraint
        ])
        animateView1.layer.cornerRadius = animateView1.frame.width / 2
        animateView2.layer.cornerRadius = animateView2.frame.width / 2
    }
    
}



