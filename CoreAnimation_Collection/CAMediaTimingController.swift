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
        startButton.addTarget(self, action: "start", forControlEvents: .TouchUpInside)
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





