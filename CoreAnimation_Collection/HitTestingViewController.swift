//
//  HitTestingViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/16.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class HitTestingViewController: UIViewController {

    let layerView = UIView()
    let blueLayer = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerView.frame = CGRectMake(0, 0, 200, 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(layerView)
        
        blueLayer.backgroundColor = UIColor.blueColor().CGColor
        blueLayer.frame = CGRectMake(50, 50, 100, 100)
        layerView.layer.addSublayer(blueLayer)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //get touch position
        var point = touches.first?.locationInView(self.view)
        //get touched layer
        let layer = self.layerView.layer.hitTest(point!)

        //convert point to the white layer's coordinates
        point = self.layerView.layer.convertPoint(point!, fromLayer: self.view.layer)
        //get layer using containsPoint:
        if self.layerView.layer.containsPoint(point!) {
            point = self.blueLayer.convertPoint(point!, fromLayer:self.layerView.layer)
        } else {
            return
        }
//        if self.blueLayer.containsPoint(point!)
        //get layer using hitTest
        if (layer == self.blueLayer)
        {
            UIAlertView.init(title: "Inside Blue Layer",
                message: "",
                delegate: nil,
                cancelButtonTitle: nil,
                otherButtonTitles: "OK").show()
        }
        else
        {
            UIAlertView.init(title: "Inside White Layer", message: "", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "OK").show()

        }

    }
    
}
