//
//  ImplicitAnomationViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/16.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

/// 隐式动画：没有指定动画类型，仅仅改变属性值由coreanimation决定如何动画
class CATransactionViewController: UIViewController {

    let layerView = UIView.init(frame: CGRectMake(0, 0, 200, 200))
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.center = self.view.center
        self.view.addSubview(layerView)
        
        colorLayer.frame = CGRectMake(50, 50, 100, 100)
        //add a custom action
        let transition = CATransition()
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        self.colorLayer.actions = ["backgroundColor": transition];
        layerView.layer.addSublayer(colorLayer)
        
        let changeColorBtn = UIButton.init(frame: CGRectMake(layerView.bounds.width/2-60,
            layerView.bounds.maxY - 40, 120, 31))
        changeColorBtn.addTarget(self, action: #selector(CATransactionViewController.changeColor(_:)), forControlEvents: .TouchUpInside)
        changeColorBtn.layer.borderColor = UIColor.darkGrayColor().CGColor
        changeColorBtn.layer.borderWidth = 1.0
        changeColorBtn.setTitle("change Color", forState: .Normal)
        changeColorBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        layerView.addSubview(changeColorBtn)
        
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(CATransactionViewController.viewCloseCATransaction(_:)), forControlEvents: .ValueChanged)
        switcher.center = CGPointMake(self.view.center.x, self.layerView.frame.maxY + 20)
        self.view.addSubview(switcher)
        
        changeColor(changeColorBtn)
    }

    /**
     改变颜色，默认animationDutarion 0.25s
     */
    func changeColor(button: UIButton)
    {
        changeLayerColor(self.colorLayer)
    }
    
    func changeLayerColor(layer: CALayer)
    {
        //begin a new transaction
        CATransaction.begin();
        //set the animation duration to 1 second
        CATransaction.setAnimationDuration(1.9);
        
        //add the spin animation on completion
        CATransaction.setCompletionBlock { () -> Void in
           
        }
        
        //rotate the layer 90 degrees
        var transform = CGAffineTransform.init()
        transform = CGAffineTransformRotate(layer.affineTransform(), CGFloat(M_PI_2))
        layer.setAffineTransform(transform)
        
        //randomize the layer background color
        let red = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        layer.backgroundColor = randomColor.CGColor
        
        //commit the transaction
        CATransaction.commit();
        
    }
    
    /**
     属性在动画块之外发生,uiview 返回nil来禁止隐式动画
     */
    func viewCloseCATransaction(switcher: UISwitch)
    {
        //test layer action when outside of animation block
        if switcher.on {
            
            UIView.animateWithDuration(2.0) { () -> Void in
              
            }
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                
                self.changeLayerColor(self.layerView.layer)
                //test layer action when inside of animation block
                print("Outside: %@", self.layerView.actionForLayer(self.layerView.layer, forKey: "backgroundColor").debugDescription)
                
                }, completion: { (_) -> Void in
                    
            })
        } else {
            
            changeLayerColor(self.layerView.layer)
            print("Outside: %@", self.layerView.actionForLayer(self.layerView.layer, forKey: "backgroundColor"))
        }
    }
}

/// PresentationLayer: 呈现图层是CAlayer的拷贝，代表屏幕UI真正的值
class PresentationLayerViewController: UIViewController {

    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
        self.colorLayer.position = CGPointMake(self.view.bounds.width / 2,
            self.view.bounds.height / 2);
        self.colorLayer.backgroundColor = UIColor.redColor().CGColor;
        self.view.layer.addSublayer(self.colorLayer);
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //get the touch point
        let point = touches.first!.locationInView(self.view);
        
        //check if we've tapped the moving layer
        if ((self.colorLayer.presentationLayer()?.hitTest(point)) != nil)
        {
            //randomize the layer background color
            let red = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            let green = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            let blue = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
            self.colorLayer.backgroundColor = randomColor.CGColor;
        }
        else
        {
            //otherwise (slowly) move the layer to new position
            CATransaction.begin()
            CATransaction.setAnimationDuration(4.0);
            self.colorLayer.position = point;
            CATransaction.commit();
        }
    }
}



