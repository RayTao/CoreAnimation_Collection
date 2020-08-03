//
//  CAMediaTimingController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/15.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class DurationRepeatCountController: UIViewController, CAAnimationDelegate {
    
    let shipLayer = CALayer();
    let durationField = UITextField.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45));
    let repeatField = UITextField.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45));
    let startButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        shipLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 128);
        shipLayer.position = CGPoint(x: 150, y: 150);
        shipLayer.contents = R.image.ship()?.cgImage
        self.view.layer.addSublayer(shipLayer);
        
        startButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        startButton.setTitle("start", for: .normal)
        startButton.backgroundColor = UIColor.purple
        startButton.addTarget(self, action: #selector(DurationRepeatCountController.start), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        durationField.center = CGPoint(x: self.view.center.x, y: startButton.frame.minY - 50)
        durationField.placeholder = "duration"
        durationField.backgroundColor = UIColor.white
        self.view.addSubview(durationField)
        
        repeatField.center = CGPoint(x: self.view.center.x, y: durationField.frame.minY - 50)
        repeatField.placeholder = "repeatCount"
        repeatField.backgroundColor = UIColor.white
        self.view.addSubview(repeatField)
        
    }
    
    func setControlsEnable(_ enabled: Bool) {
        for control in [durationField, startButton, repeatField] {
            control.isEnabled = enabled
            control.alpha = enabled ? 1.0 : 0.25
        }
    }
    
    @objc func start() {
        
        let duration = Double(durationField.text!)
        let repeatCount = Float(repeatField.text!)
        
        //animate the ship rotation
        let animation = CABasicAnimation();
        animation.keyPath = "transform.rotation";
        if duration != nil {
            animation.duration = duration!;
        }
        if repeatCount != nil {
            animation.repeatCount = repeatCount!
        }
        animation.byValue = (Double.pi * 2);
        animation.delegate = self
        shipLayer.add(animation, forKey:nil);
        
        setControlsEnable(false)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        setControlsEnable(true)
    }
}

class AutoreversesRepeatDurationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        let doorLayer = CALayer()
        doorLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 256);
        doorLayer.position = self.view.center;
        doorLayer.contents = R.image.door()?.cgImage
        doorLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.view.layer.addSublayer(doorLayer);
        
        //apply perspective transform
        var perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        self.view.layer.sublayerTransform = perspective;
        
        //animate swinging rotation
        let animation = CABasicAnimation();
        animation.keyPath = "transform.rotation.y";
        animation.duration = 2.0
        animation.repeatDuration = Double(1000000)
        animation.autoreverses = true
        animation.toValue = (-Double.pi / 2);
        doorLayer.add(animation, forKey:nil);
    }

}

/// speed影响duration timeoffset让动画快进到某一点 fillMode决定动画间隔图层的位置,需要配合removedOnCompletion = false使用
class TimeoffsetSpeedFillmodeController: UIViewController {

    let animationKey = "rotateAnimation"
    let shipLayer = CALayer();
    let bezierPath = UIBezierPath()
    let speedLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 133, height: 21))
    let timeOffsetLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 133, height: 21));
    let speedSlider = UISlider.init(frame: CGRect(x: 0, y: 0, width: 130, height: 30));
    let timeOffsetSlider = UISlider.init(frame: CGRect(x: 0, y: 0, width: 130, height: 30));
    let transformSegment = UISegmentedControl.init(items: [.forwards,CAMediaTimingFillMode.backwards,CAMediaTimingFillMode.both,CAMediaTimingFillMode.removed])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a path
        bezierPath.move(to: CGPoint(x: 0, y: 150));
        bezierPath.addCurve(to: CGPoint(x: 300, y: 150),
            controlPoint1:CGPoint(x: 75, y: 0),
            controlPoint2:CGPoint(x: 225, y: 300));
        
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath;
        pathLayer.fillColor = UIColor.clear.cgColor;
        pathLayer.strokeColor = UIColor.red.cgColor;
        pathLayer.lineWidth = 3.0;
        self.view.layer.addSublayer(pathLayer);
        
        //add the ship
        shipLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64);
        shipLayer.position = CGPoint(x: 0, y: 150);
        shipLayer.contents = R.image.ship()?.cgImage
        self.view.layer.addSublayer(shipLayer)
        
        speedSlider.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        speedSlider.maximumValue = 2.0
        speedSlider.minimumValue = 0.0
        speedSlider.value = 1.0
        speedSlider.addTarget(self, action: #selector(TimeoffsetSpeedFillmodeController.updateSliders), for: .valueChanged)
        self.view.addSubview(speedSlider)
        
        speedLabel.center = CGPoint(x: self.view.center.x + 130, y: self.view.frame.maxY - 50)
        self.view.addSubview(speedLabel)
        
        timeOffsetSlider.maximumValue = 1.0
        timeOffsetSlider.minimumValue = 0.0
        timeOffsetSlider.value = 0.5
        timeOffsetSlider.center = CGPoint(x: self.view.center.x, y: speedSlider.frame.minY - 30)
        timeOffsetSlider.addTarget(self, action: #selector(TimeoffsetSpeedFillmodeController.updateSliders), for: .valueChanged)
        self.view.addSubview(timeOffsetSlider)
        
        timeOffsetLabel.center = CGPoint(x: self.view.center.x + 130, y: speedSlider.frame.minY - 30)
        self.view.addSubview(timeOffsetLabel)

        let startButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        startButton.center = CGPoint(x: self.view.center.x, y: timeOffsetLabel.frame.maxY - 60)
        startButton.setTitle("play", for: .normal)
        startButton.backgroundColor = UIColor.purple
        startButton.addTarget(self, action: #selector(TimeoffsetSpeedFillmodeController.play), for: .touchUpInside)
        self.view.addSubview(startButton)
        
        transformSegment.center = CGPoint(x: self.view.center.x, y: startButton.frame.minY - 50)
        self.view.addSubview(transformSegment)

        
        //set initial values
        updateSliders()
    }
    
    @objc func updateSliders() {
      
        timeOffsetLabel.text = "\(timeOffsetSlider.value)"
        speedLabel.text = "\(speedSlider.value)"
    }

    @objc func play() {
        
        //create the keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "position";
        animation.timeOffset = CFTimeInterval(timeOffsetSlider.value)
        animation.speed = speedSlider.value
        animation.duration = 1.0;
        animation.path = bezierPath.cgPath;
        animation.rotationMode = CAAnimationRotationMode(rawValue: "auto")
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode(rawValue: transformSegment.titleForSegment(at: transformSegment.selectedSegmentIndex)!);
        shipLayer.add(animation, forKey:animationKey);
        
    }

}

/// 设置整个动画然后显示特定的一帧,对于有多个图层的动画组比较方便
class ManualAnimationViewController: UIViewController {

    let doorLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        doorLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 256);
        doorLayer.position = self.view.center;
        doorLayer.contents = R.image.door()?.cgImage
        doorLayer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        self.view.layer.addSublayer(doorLayer);
        
        //apply perspective transform
        var perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        self.view.layer.sublayerTransform = perspective;
        
        //add pan gesture recognizer to handle swipes
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(ManualAnimationViewController.pan(_:)))
        self.view.addGestureRecognizer(pan);
        
        //pause all layer animations
        self.doorLayer.speed = 0.0;
        
        //apply swinging animation (which won't play because layer is paused)
        let animation = CABasicAnimation();
        animation.keyPath = "transform.rotation.y";
        animation.duration = 1.0
        animation.toValue = (-Double.pi / 2);
        doorLayer.add(animation, forKey:nil);
    }

    @objc func pan(_ pan: UIPanGestureRecognizer) {
        //get horizontal component of pan gesture
        var x = pan.translation(in: self.view).x
     
        //convert from points to animation duration
        //using a reasonable scale factor
        x /= 200.0;
        
        //update timeOffset and clamp result
        var timeOffset = self.doorLayer.timeOffset;
        timeOffset = min(0.999, max(0.0, timeOffset - CFTimeInterval(x)))
        self.doorLayer.timeOffset = timeOffset;
        
        //reset pan gesture
        pan.setTranslation(CGPoint.zero, in:self.view);
        
    }
}












