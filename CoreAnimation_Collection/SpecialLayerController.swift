//
//  SpecialLayerController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/7.
//  Copyright © 2016年 ray. All rights reserved.
//
import UIKit

/// CAShapeLayer用法demo
class CAShapeLayerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create path
        let path = UIBezierPath();
        path.moveToPoint(CGPointMake(175, 100))
        path.addArcWithCenter(CGPointMake(150, 100) , radius: 25, startAngle: 0, endAngle:CGFloat(2.0 * M_PI), clockwise: true);
        path.moveToPoint(CGPointMake(150, 125))
        path.addLineToPoint(CGPointMake(150, 175))
        path.addLineToPoint(CGPointMake(125, 225))
        path.moveToPoint(CGPointMake(150, 175))
        path.addLineToPoint(CGPointMake(175, 225))
        path.moveToPoint(CGPointMake(100, 150))
        path.addLineToPoint(CGPointMake(200, 150))
        
        //create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.redColor().CGColor;
        shapeLayer.fillColor = UIColor.clearColor().CGColor;
        shapeLayer.lineWidth = 5;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.path = path.CGPath;
        
        //add it to our view
        self.view.layer.addSublayer(shapeLayer);
    }
    
    
    
}

