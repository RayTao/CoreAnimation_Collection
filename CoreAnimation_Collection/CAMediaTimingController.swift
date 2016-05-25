//
//  CAMediaTimingController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/15.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class DurationRepeatCountController: UIViewController {
    
    let shipLayer = CALayer();
    let durationField = UITextField.init(frame: CGRectMake(0, 0, 200, 45));
    let repeatField = UITextField.init(frame: CGRectMake(0, 0, 200, 45));
    let startButton = UIButton.init(frame: CGRectMake(0, 0, 200, 45));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        shipLayer.frame = CGRectMake(0, 0, 128, 128);
        shipLayer.position = CGPointMake(150, 150);
        shipLayer.contents = R.image.ship?.CGImage
        self.view.layer.addSublayer(shipLayer);
        
        startButton.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        startButton.setTitle("start", forState: .Normal)
        startButton.backgroundColor = UIColor.purpleColor()
        startButton.addTarget(self, action: #selector(DurationRepeatCountController.start), forControlEvents: .TouchUpInside)
        self.view.addSubview(startButton)
        
        durationField.center = CGPointMake(self.view.center.x, startButton.frame.minY - 50)
        durationField.placeholder = "duration"
        durationField.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(durationField)
        
        repeatField.center = CGPointMake(self.view.center.x, durationField.frame.minY - 50)
        repeatField.placeholder = "repeatCount"
        repeatField.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(repeatField)
        
    }
    
    func setControlsEnable(enabled: Bool) {
        for control in [durationField, startButton, repeatField] {
            control.enabled = enabled
            control.alpha = enabled ? 1.0 : 0.25
        }
    }
    
    func start() {
        
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
        animation.byValue = (M_PI * 2);
        animation.delegate = self
        shipLayer.addAnimation(animation, forKey:nil);
        
        setControlsEnable(false)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        setControlsEnable(true)
    }
}

class AutoreversesRepeatDurationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        let doorLayer = CALayer()
        doorLayer.frame = CGRectMake(0, 0, 128, 256);
        doorLayer.position = self.view.center;
        doorLayer.contents = R.image.door?.CGImage
        doorLayer.anchorPoint = CGPointMake(0.0, 0.5)
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
        animation.toValue = (-M_PI / 2);
        doorLayer.addAnimation(animation, forKey:nil);
    }

}

/// speed影响duration timeoffset让动画快进到某一点 fillMode决定动画间隔图层的位置,需要配合removedOnCompletion = false使用
class TimeoffsetSpeedFillmodeController: UIViewController {

    let animationKey = "rotateAnimation"
    let shipLayer = CALayer();
    let bezierPath = UIBezierPath()
    let speedLabel = UILabel.init(frame: CGRectMake(0, 0, 133, 21))
    let timeOffsetLabel = UILabel.init(frame: CGRectMake(0, 0, 133, 21));
    let speedSlider = UISlider.init(frame: CGRectMake(0, 0, 130, 30));
    let timeOffsetSlider = UISlider.init(frame: CGRectMake(0, 0, 130, 30));
    let transformSegment = UISegmentedControl.init(items: [kCAFillModeForwards,kCAFillModeBackwards,kCAFillModeBoth,kCAFillModeRemoved])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a path
        bezierPath.moveToPoint(CGPointMake(0, 150));
        bezierPath.addCurveToPoint(CGPointMake(300, 150),
            controlPoint1:CGPointMake(75, 0),
            controlPoint2:CGPointMake(225, 300));
        
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.CGPath;
        pathLayer.fillColor = UIColor.clearColor().CGColor;
        pathLayer.strokeColor = UIColor.redColor().CGColor;
        pathLayer.lineWidth = 3.0;
        self.view.layer.addSublayer(pathLayer);
        
        //add the ship
        shipLayer.frame = CGRectMake(0, 0, 64, 64);
        shipLayer.position = CGPointMake(0, 150);
        shipLayer.contents = R.image.ship?.CGImage
        self.view.layer.addSublayer(shipLayer)
        
        speedSlider.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        speedSlider.maximumValue = 2.0
        speedSlider.minimumValue = 0.0
        speedSlider.value = 1.0
        speedSlider.addTarget(self, action: #selector(TimeoffsetSpeedFillmodeController.updateSliders), forControlEvents: .ValueChanged)
        self.view.addSubview(speedSlider)
        
        speedLabel.center = CGPointMake(self.view.center.x + 130, self.view.frame.maxY - 50)
        self.view.addSubview(speedLabel)
        
        timeOffsetSlider.maximumValue = 1.0
        timeOffsetSlider.minimumValue = 0.0
        timeOffsetSlider.value = 0.5
        timeOffsetSlider.center = CGPointMake(self.view.center.x, speedSlider.frame.minY - 30)
        timeOffsetSlider.addTarget(self, action: #selector(TimeoffsetSpeedFillmodeController.updateSliders), forControlEvents: .ValueChanged)
        self.view.addSubview(timeOffsetSlider)
        
        timeOffsetLabel.center = CGPointMake(self.view.center.x + 130, speedSlider.frame.minY - 30)
        self.view.addSubview(timeOffsetLabel)

        let startButton = UIButton.init(frame: CGRectMake(0, 0, 200, 45))
        startButton.center = CGPointMake(self.view.center.x, timeOffsetLabel.frame.maxY - 60)
        startButton.setTitle("play", forState: .Normal)
        startButton.backgroundColor = UIColor.purpleColor()
        startButton.addTarget(self, action: #selector(TimeoffsetSpeedFillmodeController.play), forControlEvents: .TouchUpInside)
        self.view.addSubview(startButton)
        
        transformSegment.center = CGPointMake(self.view.center.x, startButton.frame.minY - 50)
        self.view.addSubview(transformSegment)

        
        //set initial values
        updateSliders()
    }
    
    func updateSliders() {
      
        timeOffsetLabel.text = "\(timeOffsetSlider.value)"
        speedLabel.text = "\(speedSlider.value)"
    }

    func play() {
        
        //create the keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "position";
        animation.timeOffset = CFTimeInterval(timeOffsetSlider.value)
        animation.speed = speedSlider.value
        animation.duration = 1.0;
        animation.path = bezierPath.CGPath;
        animation.rotationMode = "auto"
        animation.removedOnCompletion = false
        animation.fillMode = transformSegment.titleForSegmentAtIndex(transformSegment.selectedSegmentIndex)!;
        shipLayer.addAnimation(animation, forKey:animationKey);
        
    }

}

/// 设置整个动画然后显示特定的一帧,对于有多个图层的动画组比较方便
class ManualAnimationViewController: UIViewController {

    let doorLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        doorLayer.frame = CGRectMake(0, 0, 128, 256);
        doorLayer.position = self.view.center;
        doorLayer.contents = R.image.door?.CGImage
        doorLayer.anchorPoint = CGPointMake(0.0, 0.5)
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
        animation.toValue = (-M_PI / 2);
        doorLayer.addAnimation(animation, forKey:nil);
    }

    func pan(pan: UIPanGestureRecognizer) {
        //get horizontal component of pan gesture
        var x = pan.translationInView(self.view).x
     
        //convert from points to animation duration
        //using a reasonable scale factor
        x /= 200.0;
        
        //update timeOffset and clamp result
        var timeOffset = self.doorLayer.timeOffset;
        timeOffset = min(0.999, max(0.0, timeOffset - CFTimeInterval(x)))
        self.doorLayer.timeOffset = timeOffset;
        
        //reset pan gesture
        pan.setTranslation(CGPointZero, inView:self.view);
        
    }
}












