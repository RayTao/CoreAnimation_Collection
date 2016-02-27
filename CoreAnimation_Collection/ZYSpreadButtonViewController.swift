//
//  ZYSpreadButtonViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/23.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class ZYSpreadButtonViewController: UIViewController {

    lazy var changePositionModeButton: UIButton = {
        let button = UIButton.init(frame: CGRectMake(0, 0, 200, 45))
        button.center = self.view.center
        button.setTitle(" ModeFixed ", forState: .Normal)
        button.addTarget(self, action: "changePositionMode:", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    var spreadButton: SpreadButton!         //swift
    var zySpreadButton: ZYSpreadButton!       //objc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButtonCorner()
        
        //        runWithSwiftCode();
        runWithObjcCode();
        self.view.addSubview(self.changePositionModeButton)
    }
    
    //ObjC
    func runWithObjcCode() {
        let btn1 = ZYSpreadSubButton(backgroundImage: UIImage(named: "clock"), highlightImage: UIImage(named: "clock_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        } 
        
        let btn2 = ZYSpreadSubButton(backgroundImage: UIImage(named: "pencil"), highlightImage: UIImage(named: "pencil_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }
        
        
        let btn3 = ZYSpreadSubButton(backgroundImage: UIImage(named: "juice"), highlightImage: UIImage(named: "juice_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }
        
        
        let btn4 = ZYSpreadSubButton(backgroundImage: UIImage(named: "service"), highlightImage: UIImage(named: "service_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }
        
        
        let btn5 = ZYSpreadSubButton(backgroundImage: UIImage(named: "shower"), highlightImage: UIImage(named: "shower_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }
        
        let zySpreadButton = ZYSpreadButton(backgroundImage: UIImage(named: "powerButton"), highlightImage: UIImage(named: "powerButton_highlight"), position: CGPointMake(40, UIScreen.mainScreen().bounds.height - 40))
        self.zySpreadButton = zySpreadButton;
        
        zySpreadButton.subButtons = [btn1, btn2, btn3, btn4, btn5]
        zySpreadButton.mode = SpreadModeSickleSpread
        zySpreadButton.direction = SpreadDirectionRightUp
        zySpreadButton.radius = 120
        zySpreadButton.positionMode = SpreadPositionModeFixed
        
        /*  and you can assign a newValue to change the default
        spreadButton?.animationDuring = 0.2
        spreadButton?.animationDuringClose = 0.25
        spreadButton?.radius = 180
        spreadButton?.coverAlpha = 0.3
        spreadButton?.coverColor = UIColor.yellowColor()
        spreadButton?.touchBorderMargin = 10.0
        */
        
        
        //you can assign the Blocks like this
        zySpreadButton.buttonWillSpreadBlock = { print("\(CGRectGetMaxY($0.frame)) will spread") }
        zySpreadButton.buttonDidSpreadBlock = { _ in print("did spread") }
        zySpreadButton.buttonWillCloseBlock = { _ in print("will closed") }
        zySpreadButton.buttonDidCloseBlock = { _ in print("did closed") }
        
        if zySpreadButton != nil {
            self.view.addSubview(zySpreadButton)
        }
    }
    
    //Swift
    func runWithSwiftCode() {
        let btn1 = SpreadSubButton(backgroundImage: UIImage(named: "clock"), highlightImage: UIImage(named: "clock_highlight")) { (index, sender) -> Void in
            print("first")
        }
        
        let btn2 = SpreadSubButton(backgroundImage: UIImage(named: "pencil"), highlightImage: UIImage(named: "pencil_highlight")) { (index, sender) -> Void in
            print("second")
        }
        
        let btn3 = SpreadSubButton(backgroundImage: UIImage(named: "juice"), highlightImage: UIImage(named: "juice_highlight")) { (index, sender) -> Void in
            print("third")
        }
        
        let btn4 = SpreadSubButton(backgroundImage: UIImage(named: "service"), highlightImage: UIImage(named: "service_highlight")) { (index, sender) -> Void in
            print("fourth")
        }
        
        let btn5 = SpreadSubButton(backgroundImage: UIImage(named: "shower"), highlightImage: UIImage(named: "shower_highlight")) { (index, sender) -> Void in
            print("fifth")
        }
        
        
        let spreadButton = SpreadButton(image: UIImage(named: "powerButton"),
            highlightImage: UIImage(named: "powerButton_highlight"),
            position: CGPointMake(40, UIScreen.mainScreen().bounds.height - 40))
        self.spreadButton = spreadButton
        
        spreadButton?.setSubButtons([btn1, btn2, btn3, btn4, btn5])
        spreadButton?.mode = SpreadMode.SpreadModeSickleSpread
        spreadButton?.direction = SpreadDirection.SpreadDirectionRightUp
        spreadButton?.radius = 120
        spreadButton?.positionMode = SpreadPositionMode.SpreadPositionModeFixed
        
        /*  and you can assign a newValue to change the default
        spreadButton?.animationDuring = 0.2
        spreadButton?.animationDuringClose = 0.25
        spreadButton?.radius = 180
        spreadButton?.coverAlpha = 0.3
        spreadButton?.coverColor = UIColor.yellowColor()
        spreadButton?.touchBorderMargin = 10.0
        */
        
        //you can assign the Blocks like this
        spreadButton?.buttonWillSpreadBlock = { print(CGRectGetMaxY($0.frame)) }
        spreadButton?.buttonDidSpreadBlock = { _ in print("did spread") }
        spreadButton?.buttonWillCloseBlock = { _ in print("will closed") }
        spreadButton?.buttonDidCloseBlock = { _ in print("did closed") }
        
        if spreadButton != nil {
            self.view.addSubview(spreadButton!)
        }
    }
    
    func changePositionMode(sender: AnyObject) {
        
        //display with Swift Code
        if spreadButton != nil {
            if spreadButton?.positionMode == SpreadPositionMode.SpreadPositionModeFixed {
                spreadButton?.positionMode = SpreadPositionMode.SpreadPositionModeTouchBorder
                sender.setTitle(" ModeTouchBorder ", forState: .Normal)
            } else {
                spreadButton?.positionMode = SpreadPositionMode.SpreadPositionModeFixed
                sender.setTitle(" ModeFixed ", forState: .Normal)
            }
        }
        
        //display with OC Code
        if zySpreadButton != nil {
            if zySpreadButton.positionMode == SpreadPositionModeFixed {
                zySpreadButton.positionMode = SpreadPositionModeTouchBorder
                sender.setTitle(" ModeTouchBorder ", forState: .Normal)
            } else {
                zySpreadButton.positionMode = SpreadPositionModeFixed
                sender.setTitle(" ModeFixed ", forState: .Normal)
            }
        }
    }
    
    func configureButtonCorner() {
        changePositionModeButton.layer.cornerRadius = changePositionModeButton.bounds.height/2
        changePositionModeButton.layer.masksToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}
