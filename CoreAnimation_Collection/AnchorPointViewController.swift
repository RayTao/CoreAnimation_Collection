//
//  AnchorPointViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/16.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class AnchorPointViewController: UIViewController {
    let hourHand = UIImageView.init(image: R.image.hourHand())
    let minuteHand = UIImageView.init(image: R.image.minuteHand())
    let secondHand = UIImageView.init(image: R.image.secondHand())
    let clockHand = UIImageView.init(image: R.image.clockFace())
    let switcher = UISwitch()
    weak var timer = Timer()
    
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
        switcher.addTarget(self, action: #selector(AnchorPointViewController.changeAnchorPoint(_:)), for: .valueChanged)
        switcher.center = CGPoint(x: minuteHand.center.x, y: clockHand.frame.maxY + 20)
        switcher.isOn = true
        
        changeAnchorPoint(switcher)
    }

    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AnchorPointViewController.tick), userInfo: nil, repeats: true)
        //set initial hand positions
        tick()
    }
    
    //MARK: timer?.invalidate必须执行，不然控制器吧吧不会释放
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    func tick() {

        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = (calendar as NSCalendar?)?.components([.hour,.minute,.second], from: Date())
        //calculate hour hand angle
        let hourAngle = (Double(components!.hour!) / 12.0) * Double.pi * 2.0;
        
        //calculate minute hand angle
        let minuteAngle = (Double(components!.minute!) / 60.0) * Double.pi * 2.0;
        
        //calculate second hand angle
        let secondAngle = (Double(components!.second!) / 60.0) * Double.pi * 2.0;
        
        setAngle(CGFloat(hourAngle), handView: hourHand)
        setAngle(CGFloat(minuteAngle), handView: minuteHand)
        setAngle(CGFloat(secondAngle), handView: secondHand)

    }
    
    func setAngle(_ angle: CGFloat, handView: UIView) {
        
        handView.transform = CGAffineTransform(rotationAngle: angle);
    }
    
    func changeAnchorPoint(_ switcher: UISwitch) {
        if (switcher.isOn) {
            
            //adjust anchor points
            self.secondHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9);
            self.minuteHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9);
            self.hourHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9);
        } else {
            //adjust anchor points
            self.secondHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            self.minuteHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
            self.hourHand.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        }
    }
}
