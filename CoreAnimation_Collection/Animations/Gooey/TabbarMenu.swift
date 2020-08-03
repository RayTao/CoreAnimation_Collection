//
//  TabbarMenu.swift
//  GooeyTabbar
//
//  Created by KittenYang on 11/16/15.
//  Copyright © 2015 KittenYang. All rights reserved.
//

import UIKit

class TabbarMenu: UIView{
  
  /// 是否打开
  var opened : Bool = false

  fileprivate var normalRect : UIView!
  fileprivate var springRect : UIView!
  fileprivate var keyWindow  : UIWindow!
  fileprivate var blurView   : UIVisualEffectView!
  fileprivate var displayLink : CADisplayLink!
  fileprivate var animationCount : Int = 0
  fileprivate var diff : CGFloat = 0
  fileprivate var terminalFrame : CGRect?
  fileprivate var initialFrame : CGRect?
  fileprivate var animateButton : AnimatedButton?
  
  let TOPSPACE : CGFloat = 64.0 //留白
  fileprivate var tabbarheight : CGFloat? //tabbar高度
  
  init(tabbarHeight : CGFloat)
  {
    tabbarheight = tabbarHeight
    terminalFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    initialFrame = CGRect(x: 0, y: UIScreen.main.bounds.height - tabbarHeight - TOPSPACE, width: terminalFrame!.width, height: terminalFrame!.height)
    super.init(frame: initialFrame!)
    setUpViews()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  override func draw(_ rect: CGRect)
  {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: self.frame.height))
    path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
    path.addLine(to: CGPoint(x: self.frame.width, y: TOPSPACE))
    path.addQuadCurve(to: CGPoint(x: 0, y: TOPSPACE), controlPoint: CGPoint(x: self.frame.width/2, y: TOPSPACE-diff))
    path.close()
    
    let context = UIGraphicsGetCurrentContext()
    context?.addPath(path.cgPath)
    UIColor(red: 50/255.0, green: 58/255.0, blue: 68/255.0, alpha: 1.0).set()
    context?.fillPath()
  }
  
  
  fileprivate func setUpViews()
  {
    keyWindow = UIApplication.shared.keyWindow
    
    blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    blurView.frame = self.bounds
    blurView.alpha = 0.0
    keyWindow.addSubview(blurView)
    
    self.backgroundColor = UIColor.clear
    keyWindow.addSubview(self)
    
    normalRect = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 30 - 50, width: 30, height: 30))
    normalRect.backgroundColor = UIColor.blue
    normalRect.isHidden = true
    keyWindow.addSubview(normalRect)
    
    springRect = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2 - 30/2, y: normalRect.frame.origin.y, width: 30, height: 30))
    springRect.backgroundColor = UIColor.yellow
    springRect.isHidden = true
    keyWindow.addSubview(springRect)
    
    animateButton = AnimatedButton(frame: CGRect(x: 0, y: TOPSPACE + (tabbarheight! - 30)/2, width: 50, height: 30))
    self.addSubview(animateButton!)
    animateButton!.didTapped = { (button) -> () in
      self.triggerAction()
    }
    
  }
  
  func triggerAction()
  {
    if animateButton!.animating {
      return
    }
    
    /**
    *  展开
    */
    if !opened {
      opened = true
      startAnimation()
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.springRect.center = CGPoint(x: self.springRect.center.x, y: self.springRect.center.y - 40)
        }) { (finish) -> Void in
          UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.frame = self.terminalFrame!
            }, completion: nil)
          
          UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: { () -> Void in
            self.normalRect.center = CGPoint(x: self.normalRect.center.x, y: 100)
            self.blurView.alpha = 1.0
            }, completion: nil)
          
          UIView.animate(withDuration: 1.0, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.springRect.center = CGPoint(x: self.springRect.center.x, y: 100)
            }, completion: { (finish) -> Void in
              self.finishAnimation()
          })
      }
    }else{
      /**
      *  收缩
      */
      opened = false
      startAnimation()
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.frame = self.initialFrame!
        }, completion: nil)
      
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
        self.normalRect.center = CGPoint(x: self.normalRect.center.x, y: UIScreen.main.bounds.size.height - 30 - 50)
        self.blurView.alpha = 0.0
        }, completion: nil)
      
      UIView.animate(withDuration: 0.2, delay:0.0, options: .curveEaseOut, animations: { () -> Void in
        self.springRect.center = CGPoint(x: self.springRect.center.x, y: UIScreen.main.bounds.size.height - 30 - 50 + 10)
        }, completion: { (finish) -> Void in
          UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.springRect.center = CGPoint(x: self.springRect.center.x, y: UIScreen.main.bounds.size.height - 30 - 50 - 40)
            }, completion: { (finish) -> Void in
              UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.springRect.center = CGPoint(x: self.springRect.center.x, y: UIScreen.main.bounds.size.height - 30 - 50)
                }, completion: { (finish) -> Void in
                  self.finishAnimation()
              })
          })
      })
    }
  }

  
  @objc fileprivate func update(_ displayLink: CADisplayLink)
  {
    let normalRectLayer = normalRect.layer.presentation()
    let springRectLayer = springRect.layer.presentation()
    
    let normalRectFrame = (normalRectLayer!.value(forKey: "frame")! as AnyObject).cgRectValue
    let springRectFrame = (springRectLayer!.value(forKey: "frame")! as AnyObject).cgRectValue
    
    diff = (normalRectFrame?.origin.y)! - (springRectFrame?.origin.y)!
    print("=====\(diff)")
    
    self.setNeedsDisplay()
  }
  
  fileprivate func startAnimation()
  {
    if displayLink == nil
    {
      self.displayLink = CADisplayLink(target: self, selector: #selector(TabbarMenu.update(_:)))
        self.displayLink.add(to: RunLoop.main, forMode: .default)
    }
    animationCount += 1
  }
  
  fileprivate func finishAnimation()
  {
    animationCount -= 1
    if animationCount == 0
    {
      displayLink.invalidate()
      displayLink = nil
    }
  }
  
  
}
