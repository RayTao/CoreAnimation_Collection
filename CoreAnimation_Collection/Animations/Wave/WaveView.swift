//
//  WaveView.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/10.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class WaveView: UIView {
    var numberOfWaves = 5
    var waveColor = UIColor.whiteColor()
    let mainWaveWidth: CGFloat = 2.0
    let decorativeWavesWidth: CGFloat = 1.0
    var idleAmplitude = 0.01
    var frequency: CGFloat = 1.2
    var density: CGFloat = 1.0
    let phaseShift = -0.25
    var maskBorder = false
    var callBack:(waveView: WaveView) -> Void = {_ in }
    var waves: [CAShapeLayer] = []
    private var amplitude = 1.0
    private var phase:CGFloat = 0.0
    private var waveHeight: CGFloat {
        get {
            return CGRectGetHeight(self.bounds)
        }
    }
    private var waveWidth: CGFloat {
        get {
            return CGRectGetWidth(self.bounds)
        }
    }
    private var waveMid: CGFloat {
        get {
            return self.waveWidth / 2.0
        }
    }
    private var maxAmplitude: CGFloat {
        get {
            return self.waveHeight - 4.0
        }
    }
    
    var displayLink: CADisplayLink? = nil
    func waverLevelCallback(closure: (waveView: WaveView) -> Void) {
        callBack = closure
//        displayLink!.invalidate()
        displayLink = CADisplayLink.init(target: self, selector: "invokeWaveCallback")
        displayLink!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        for i in 0..<self.numberOfWaves {
            let waveLine = CAShapeLayer.init()
            waveLine.lineCap = kCALineCapButt
            waveLine.lineJoin = kCALineJoinRound
            waveLine.fillColor = UIColor.clearColor().CGColor
            waveLine.lineWidth = (i == 0 ? mainWaveWidth : decorativeWavesWidth)
            let progress = 1.0 - Double(i) / Double(numberOfWaves)
            let multiplier = min(1.0, (progress / 3.0*2.0) + (1.0 / 3.0))
            let color = waveColor.colorWithAlphaComponent(CGFloat(i == 0 ? 1.0 : 1.0*multiplier*0.4))
            waveLine.strokeColor = color.CGColor
            self.layer.addSublayer(waveLine)
            waves.append(waveLine)
            if (maskBorder && i == numberOfWaves - 1) {
                waveLine.fillColor = color.CGColor
//                waveLine.mask = waves.first
//                waves.first?.fillColor = color.CGColor
            }
        }
        
        closure(waveView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func removeFromSuperview() {
        displayLink!.invalidate()

    }
    
    deinit {
        displayLink!.invalidate()

    }
    
    func invokeWaveCallback() {
        callBack(waveView: self)
    }
    
    func setLevel(level: Double) {
        phase += CGFloat(phaseShift)
        amplitude = max(level, idleAmplitude)
        updateMeters()
    }
    
    func updateMeters() {
        
//        UIGraphicsBeginImageContext(self.frame.size);
        for i in 0..<self.numberOfWaves {
            let wavelinePath = UIBezierPath()
            let progress = 1.0 - Double(i) / Double(numberOfWaves)
            let normedAmplitude = (1.5 * progress - 0.5) * self.amplitude
            
            for (var x: CGFloat = 0.0; x < waveWidth + density; x += density) {
                //Thanks to https://github.com/stefanceriu/SCSiriWaveformView
                // We use a parable to scale the sinus wave, that has its peak in the middle of the view.
                let scaling = -pow(x / waveMid - 1, 2) + 1  // make center bigger
                var y = scaling * self.maxAmplitude * CGFloat(normedAmplitude) * CGFloat(sinf(Float(2 * CGFloat(M_PI)*(x / self.waveWidth) * frequency + phase))) + (self.waveHeight * 0.5)
                y /= 3.0
                if (x==0) {
                    wavelinePath.moveToPoint(CGPointMake(x, y))
                } else {
                    wavelinePath.addLineToPoint(CGPointMake(x, y))
                }
            }
            if (maskBorder && (i == numberOfWaves - 1 || i == 0)) {
                let bounds = self.bounds
                wavelinePath.addLineToPoint(CGPointMake(bounds.maxX, bounds.maxY))
                wavelinePath.addLineToPoint(CGPointMake(bounds.minX, bounds.maxY))
                wavelinePath.closePath()
            }
            
            let waveline = self.waves[i]
            waveline.path = wavelinePath.CGPath;
        }
//        UIGraphicsEndImageContext();
    }
}
