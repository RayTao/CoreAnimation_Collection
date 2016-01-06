//
//  CoordinateSystemViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/16.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class CoordinateSystemViewController: UIViewController {

    let greenView = UIView()
    let redView = UIView()
    let switcher = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        greenView.frame = CGRectMake(80, 80, 150, 150)
        greenView.backgroundColor = UIColor.greenColor()
        redView.frame = CGRectMake(120, 120, 150, 150)
        redView.backgroundColor = UIColor.redColor()
        self.view.addSubview(greenView)
        self.view.addSubview(redView)
        
        switcher.addTarget(self, action: "changeAnchorPoint:", forControlEvents: .ValueChanged)
        switcher.center = CGPointMake(self.view.center.x, redView.frame.maxY + 20)
        self.view.addSubview(switcher)
    }
    
    func changeAnchorPoint(switcher: UISwitch) {
        if (switcher.on) {
            
            //adjust anchor points
            self.greenView.layer.zPosition = 1.0;
        } else {
            //adjust anchor points
            self.greenView.layer.zPosition = 0.0;
        }
    }
    
}
