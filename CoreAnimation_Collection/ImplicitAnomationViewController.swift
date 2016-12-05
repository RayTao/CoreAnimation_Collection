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

    let layerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        self.view.addSubview(layerView)
        
        colorLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        //add a custom action
        let transition = CATransition()
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        self.colorLayer.actions = ["backgroundColor": transition];
        layerView.layer.addSublayer(colorLayer)
        
        let changeColorBtn = UIButton.init(frame: CGRect(x: layerView.bounds.width/2-60,
            y: layerView.bounds.maxY - 40, width: 120, height: 31))
        changeColorBtn.addTarget(self, action: #selector(CATransactionViewController.changeColor(_:)), for: .touchUpInside)
        changeColorBtn.layer.borderColor = UIColor.darkGray.cgColor
        changeColorBtn.layer.borderWidth = 1.0
        changeColorBtn.setTitle("change Color", for: UIControlState())
        changeColorBtn.setTitleColor(UIColor.blue, for: UIControlState())
        layerView.addSubview(changeColorBtn)
        
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(CATransactionViewController.viewCloseCATransaction(_:)), for: .valueChanged)
        switcher.center = CGPoint(x: self.view.center.x, y: self.layerView.frame.maxY + 20)
        self.view.addSubview(switcher)
        
        changeColor(changeColorBtn)
    }

    /**
     改变颜色，默认animationDutarion 0.25s
     */
    func changeColor(_ button: UIButton)
    {
        changeLayerColor(self.colorLayer)
    }
    
    func changeLayerColor(_ layer: CALayer)
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
        transform = layer.affineTransform().rotated(by: CGFloat(M_PI_2))
        layer.setAffineTransform(transform)
        
        //randomize the layer background color
        let red = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        layer.backgroundColor = randomColor.cgColor
        
        //commit the transaction
        CATransaction.commit();
        
    }
    
    /**
     属性在动画块之外发生,uiview 返回nil来禁止隐式动画
     */
    func viewCloseCATransaction(_ switcher: UISwitch)
    {
        //test layer action when outside of animation block
        if switcher.isOn {
            
            UIView.animate(withDuration: 2.0, animations: { () -> Void in
              
            }) 
            UIView.animate(withDuration: 2.0, animations: { () -> Void in
                
                self.changeLayerColor(self.layerView.layer)
                //test layer action when inside of animation block
                
                }, completion: { (_) -> Void in
                    
            })
        } else {
            
            changeLayerColor(self.layerView.layer)
//            print("Outside: %@", self.layerView.actionForLayer(self.layerView.layer, forKey: "backgroundColor"))
        }
    }
}

/// PresentationLayer: 呈现图层是CAlayer的拷贝，代表屏幕UI真正的值
class PresentationLayerViewController: UIViewController {

    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100);
        self.colorLayer.position = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height / 2);
        self.colorLayer.backgroundColor = UIColor.red.cgColor;
        self.view.layer.addSublayer(self.colorLayer);
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //get the touch point
        let point = touches.first!.location(in: self.view);
        
        //check if we've tapped the moving layer
        if ((self.colorLayer.presentation()?.hitTest(point)) != nil)
        {
            //randomize the layer background color
            let red = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
            let green = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
            let blue = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
            let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
            self.colorLayer.backgroundColor = randomColor.cgColor;
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



