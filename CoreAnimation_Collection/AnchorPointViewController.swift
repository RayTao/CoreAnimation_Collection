//
//  AnchorPointViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/16.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class AnchorPointViewController: UIViewController {
    let hourHand = UIImageView.init(image: R.image.hourHand)
    let minuteHand = UIImageView.init(image: R.image.minuteHand)
    let secondHand = UIImageView.init(image: R.image.secondHand)
    let clockHand = UIImageView.init(image: R.image.clockFace)
    let switcher = UISwitch()
    weak var timer = NSTimer()
    
    deinit {
        print("AnchorPointViewController deinit");
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(clockHand)
        clockHand.center = self.view.center
        self.view.addSubview(hourHand);
        hourHand.center = self.view.center
        self.view.addSubview(minuteHand)
        minuteHand.center = hourHand.center
        self.view.addSubview(secondHand)
        secondHand.center = minuteHand.center
        self.view.addSubview(switcher)
        switcher.addTarget(self, action: "changeAnchorPoint:", forControlEvents: .ValueChanged)
        switcher.center = CGPointMake(minuteHand.center.x, clockHand.frame.maxY + 20)
    }

    override func viewWillAppear(animated: Bool) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        //set initial hand positions
        tick()
    }
    
    //MARK: timer?.invalidate必须执行，不然控制器吧吧不会释放
    override func viewWillDisappear(animated: Bool) {
        timer?.invalidate()
    }
    
    func tick() {

        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = calendar?.components([.Hour,.Minute,.Second], fromDate: NSDate())
        //calculate hour hand angle
        let hourAngle = (Double(components!.hour) / 12.0) * M_PI * 2.0;
        
        //calculate minute hand angle
        let minuteAngle = (Double(components!.minute) / 60.0) * M_PI * 2.0;
        
        //calculate second hand angle
        let secondAngle = (Double(components!.second) / 60.0) * M_PI * 2.0;
        
        self.hourHand.transform = CGAffineTransformMakeRotation(CGFloat(hourAngle));
        self.minuteHand.transform = CGAffineTransformMakeRotation(CGFloat(minuteAngle));
        self.secondHand.transform = CGAffineTransformMakeRotation(CGFloat(secondAngle));
    }
    
    func changeAnchorPoint(switcher: UISwitch) {
        if (switcher.on) {
            
            //adjust anchor points
            self.secondHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
            self.minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
            self.hourHand.layer.anchorPoint = CGPointMake(0.5, 0.9);
        } else {
            //adjust anchor points
            self.secondHand.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.5);
            self.hourHand.layer.anchorPoint = CGPointMake(0.5, 0.5);
        }
    }
}
