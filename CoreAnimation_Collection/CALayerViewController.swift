//
//  CALayerViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/12.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class CALayerViewController: UIViewController {

    let layerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //create sublayer
        layerView.frame = CGRectMake(0, 0, 200, 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(layerView)
        
        
        let blueLayer = CALayer()
        blueLayer.frame = CGRectMake(50.0, 50.0, 100.0, 100.0);
        blueLayer.backgroundColor = UIColor.blueColor().CGColor;
        
        //add it to our view
        layerView.layer.addSublayer(blueLayer);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
