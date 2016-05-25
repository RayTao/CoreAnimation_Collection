//
//  TimerAnimateViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/16.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class TimerAnimateViewController: UIViewController {

    let ballView = UIImageView.init(image: R.image.ball)
    var timer : CADisplayLink!
    let fromValue = CGPointMake(150, 32);
    let toValue = CGPointMake(150, 268)
    let duration = 1.0;
    var timeOffset = 0.0
    var lastStep = CACurrentMediaTime()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(ballView)
        animate()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.animate()
    }
    
    func getInterpolate(from: CGFloat, to: CGFloat, time: CGFloat) -> CGFloat {
        return (to - from) * time + from;
    }
    
    func bounceEaseOut(t: Double) -> Double {
        
        if (t < 4/11.0)
        {
            return (121 * t * t)/16.0;
        }
        else if (t < 8/11.0)
        {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        }
        else if (t < 9/10.0)
        {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
    
    func interpolate(fromeValue: CGPoint,toValue: CGPoint,time: Double) -> NSValue {
        
        var resultValue = NSValue.init(CGPoint: CGPointMake(0,0))
        let result = CGPointMake(getInterpolate(fromeValue.x, to: toValue.x, time: CGFloat(time)),
            getInterpolate(fromeValue.y, to: toValue.y, time: CGFloat(time)));
        resultValue = NSValue.init(CGPoint: result)
        
        return resultValue
    }
    
    func animate() {
        //reset ball to top of screen
        self.ballView.center = CGPointMake(150, 32);
        
        lastStep = CACurrentMediaTime()
        
        if self.timer != nil {
            self.timer.invalidate()
        }
        self.timer = CADisplayLink.init(target: self, selector:#selector(TimerAnimateViewController.step(_:)))
        self.timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func step(timer: CADisplayLink) {
        //calculate time delta
        let thisStep = CACurrentMediaTime()
        let stepDuration = thisStep - self.lastStep
        lastStep = CACurrentMediaTime()
        
        //update time offset
        self.timeOffset = min(self.timeOffset + stepDuration, self.duration);
        
        //get normalized time offset (in range 0 - 1)
        var time = self.timeOffset / self.duration;
        
        //apply easing
        time = bounceEaseOut(time);
        
        //interpolate position
        let position = interpolate(fromValue, toValue: toValue, time: time)
        
        //move ball view to new position
        self.ballView.center = position.CGPointValue();
        
        //stop the timer if we've reached the end of the animation
        if (self.timeOffset >= self.duration)
        {
            self.timer.invalidate();
            self.timer = nil;
        }

    }
    
    
    
    
}
