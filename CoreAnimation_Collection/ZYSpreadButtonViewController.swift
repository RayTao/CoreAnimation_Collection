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
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        button.center = self.view.center
        button.setTitle(" ModeFixed ", for: UIControlState())
        button.addTarget(self, action: #selector(ZYSpreadButtonViewController.changePositionMode(_:)), for: UIControlEvents.touchUpInside)
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
        let btn1 = ZYSpreadSubButton(backgroundImage: UIImage(named: "clock"), highlight: UIImage(named: "clock_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }!
        
        let btn2 = ZYSpreadSubButton(backgroundImage: UIImage(named: "pencil"), highlight: UIImage(named: "pencil_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }!
        
        
        let btn3 = ZYSpreadSubButton(backgroundImage: UIImage(named: "juice"), highlight: UIImage(named: "juice_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }!
        
        
        let btn4 = ZYSpreadSubButton(backgroundImage: UIImage(named: "service"), highlight: UIImage(named: "service_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }!
        
        
        let btn5 = ZYSpreadSubButton(backgroundImage: UIImage(named: "shower"), highlight: UIImage(named: "shower_highlight")) { (index, sender) -> Void in
            print("第\(index+1)个按钮被按了")
        }!
        
        let zySpreadButton = ZYSpreadButton(backgroundImage: UIImage(named: "powerButton"), highlight: UIImage(named: "powerButton_highlight"), position: CGPoint(x: 40, y: UIScreen.main.bounds.height - 40))
        self.zySpreadButton = zySpreadButton;
        
        zySpreadButton?.subButtons = [btn1, btn2, btn3, btn4, btn5]
        zySpreadButton?.mode = SpreadModeSickleSpread
        zySpreadButton?.direction = SpreadDirectionRightUp
        zySpreadButton?.radius = 120
        zySpreadButton?.positionMode = SpreadPositionModeFixed
        
        /*  and you can assign a newValue to change the default
        spreadButton?.animationDuring = 0.2
        spreadButton?.animationDuringClose = 0.25
        spreadButton?.radius = 180
        spreadButton?.coverAlpha = 0.3
        spreadButton?.coverColor = UIColor.yellowColor()
        spreadButton?.touchBorderMargin = 10.0
        */
        
        
        //you can assign the Blocks like this
        zySpreadButton?.buttonWillSpreadBlock = { print("\(String(describing: $0?.frame.maxY)) will spread") }
        zySpreadButton?.buttonDidSpreadBlock = { _ in print("did spread") }
        zySpreadButton?.buttonWillCloseBlock = { _ in print("will closed") }
        zySpreadButton?.buttonDidCloseBlock = { _ in print("did closed") }
        
        if zySpreadButton != nil {
            self.view.addSubview(zySpreadButton!)
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
            position: CGPoint(x: 40, y: UIScreen.main.bounds.height - 40))
        self.spreadButton = spreadButton
        
        spreadButton?.setSubButtons([btn1, btn2, btn3, btn4, btn5])
        spreadButton?.mode = SpreadMode.spreadModeSickleSpread
        spreadButton?.direction = SpreadDirection.spreadDirectionRightUp
        spreadButton?.radius = 120
        spreadButton?.positionMode = SpreadPositionMode.spreadPositionModeFixed
        
        /*  and you can assign a newValue to change the default
        spreadButton?.animationDuring = 0.2
        spreadButton?.animationDuringClose = 0.25
        spreadButton?.radius = 180
        spreadButton?.coverAlpha = 0.3
        spreadButton?.coverColor = UIColor.yellowColor()
        spreadButton?.touchBorderMargin = 10.0
        */
        
        //you can assign the Blocks like this
        spreadButton?.buttonWillSpreadBlock = { print($0.frame.maxY) }
        spreadButton?.buttonDidSpreadBlock = { _ in print("did spread") }
        spreadButton?.buttonWillCloseBlock = { _ in print("will closed") }
        spreadButton?.buttonDidCloseBlock = { _ in print("did closed") }
        
        if spreadButton != nil {
            self.view.addSubview(spreadButton!)
        }
    }
    
    func changePositionMode(_ sender: AnyObject) {
        
        //display with Swift Code
        if spreadButton != nil {
            if spreadButton?.positionMode == SpreadPositionMode.spreadPositionModeFixed {
                spreadButton?.positionMode = SpreadPositionMode.spreadPositionModeTouchBorder
                sender.setTitle(" ModeTouchBorder ", for: UIControlState())
            } else {
                spreadButton?.positionMode = SpreadPositionMode.spreadPositionModeFixed
                sender.setTitle(" ModeFixed ", for: UIControlState())
            }
        }
        
        //display with OC Code
        if zySpreadButton != nil {
            if zySpreadButton.positionMode == SpreadPositionModeFixed {
                zySpreadButton.positionMode = SpreadPositionModeTouchBorder
                sender.setTitle(" ModeTouchBorder ", for: UIControlState())
            } else {
                zySpreadButton.positionMode = SpreadPositionModeFixed
                sender.setTitle(" ModeFixed ", for: UIControlState())
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
