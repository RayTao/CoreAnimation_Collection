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
        
        layerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.white
        self.view.addSubview(layerView)
        
        blueLayer.backgroundColor = UIColor.blue.cgColor
        blueLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        layerView.layer.addSublayer(blueLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch position
        var point = touches.first?.location(in: self.view)
        //get touched layer
        let layer = self.layerView.layer.hitTest(point!)

        //convert point to the white layer's coordinates
        point = self.layerView.layer.convert(point!, from: self.view.layer)
        //get layer using containsPoint:
        if self.layerView.layer.contains(point!) {
            point = self.blueLayer.convert(point!, from:self.layerView.layer)
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
