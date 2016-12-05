//
//  WaveViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/10.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit
import AVFoundation

class WaveViewController: UIViewController {

    lazy var recorder: AVAudioRecorder? = {
        let url = URL(fileURLWithPath: "/dev/null")
        let settings: [String : AnyObject] = [AVSampleRateKey: 44100.0 as AnyObject, AVFormatIDKey: Int(kAudioFormatAppleLossless) as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject, AVEncoderAudioQualityKey: 0 as AnyObject]
        do {
            let recorder = try AVAudioRecorder.init(url: url, settings: settings)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder.prepareToRecord()
            recorder.isMeteringEnabled = true
            recorder.record()
            return recorder
            
        } catch {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let waveView = WaveView.init(frame: CGRect(x: 0, y: self.view.bounds.height/2.0 - 50.0, width: self.view.bounds.width, height: 150.0))
        waveView.waveColor = UIColor.black
        waveView.maskBorder = true

        weak var weakerRecorder = recorder
        waveView.waverLevelCallback { (wavingView) -> Void in
            weakerRecorder?.updateMeters()
            let normalizedValue = pow(5, (weakerRecorder?.averagePower(forChannel: 0))! / 100)
            wavingView.setLevel(Double(normalizedValue))
        }
        self.view.addSubview(waveView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.white
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
