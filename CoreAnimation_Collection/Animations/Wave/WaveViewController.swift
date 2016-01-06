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
        let url = NSURL.fileURLWithPath("/dev/null")
        let settings: [String : AnyObject] = [AVSampleRateKey: 44100.0, AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVNumberOfChannelsKey: 2, AVEncoderAudioQualityKey: 0]
        do {
            let recorder = try AVAudioRecorder.init(URL: url, settings: settings)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder.prepareToRecord()
            recorder.meteringEnabled = true
            recorder.record()
            return recorder
            
        } catch {
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let waveView = WaveView.init(frame: CGRectMake(0, CGRectGetHeight(self.view.bounds)/2.0 - 50.0, CGRectGetWidth(self.view.bounds), 150.0))
        waveView.waveColor = UIColor.blackColor()
        waveView.maskBorder = true

        weak var weakerRecorder = recorder
        waveView.waverLevelCallback { (wavingView) -> Void in
            weakerRecorder?.updateMeters()
            let normalizedValue = pow(5, (weakerRecorder?.averagePowerForChannel(0))! / 100)
            wavingView.setLevel(Double(normalizedValue))
        }
        self.view.addSubview(waveView)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.whiteColor()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
