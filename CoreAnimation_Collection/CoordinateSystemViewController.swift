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
        greenView.frame = CGRect(x: 80, y: 80, width: 150, height: 150)
        greenView.backgroundColor = UIColor.green
        redView.frame = CGRect(x: 120, y: 120, width: 150, height: 150)
        redView.backgroundColor = UIColor.red
        self.view.addSubview(greenView)
        self.view.addSubview(redView)
        
        switcher.addTarget(self, action: #selector(CoordinateSystemViewController.changeAnchorPoint(_:)), for: .valueChanged)
        switcher.center = CGPoint(x: self.view.center.x, y: redView.frame.maxY + 20)
        self.view.addSubview(switcher)
    }
    
    func changeAnchorPoint(_ switcher: UISwitch) {
        if (switcher.isOn) {
            
            //adjust anchor points
            self.greenView.layer.zPosition = 1.0;
        } else {
            //adjust anchor points
            self.greenView.layer.zPosition = 0.0;
        }
    }
    
}
