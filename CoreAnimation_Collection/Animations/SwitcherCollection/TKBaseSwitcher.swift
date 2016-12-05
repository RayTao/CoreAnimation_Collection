//
//  TKBaseSwitcher.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

typealias ValueChangeHook  = (_ value:Bool) -> Void
func CGPointScaleMaker(_ scale: CGFloat) -> ((CGFloat, CGFloat) -> CGPoint) {
    return { (x, y) in
        return CGPoint(x: x * scale ,y: y * scale)}
}


// 自定义 Switch 基类
class TKBaseSwitch: UIControl {
    
    // MARK: - Property
    var valueChange : ValueChangeHook?
    var on : Bool = true
    var animateDuration : Double = 0.4
    
    
    // MARK: - Getter
    var isOn : Bool{
        return on
    }
    
    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(TKBaseSwitch.changeValue))
        self.addGestureRecognizer(tap)        
    }
    
    func changeValue(){
        if valueChange != nil{
            valueChange!(isOn)
        }
        sendActions(for: UIControlEvents.valueChanged);
        on = !on
    }

}


//活的视图缩放比例
extension UIView{
    var sizeScale : CGFloat{
        return min(self.bounds.width, self.bounds.height)/100.0
    }
}


