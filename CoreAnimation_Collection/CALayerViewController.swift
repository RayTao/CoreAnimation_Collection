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
        layerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.white
        self.view.addSubview(layerView)
        
        
        let blueLayer = CALayer()
        blueLayer.frame = CGRect(x: 50.0, y: 50.0, width: 100.0, height: 100.0);
        blueLayer.backgroundColor = UIColor.blue.cgColor;
        
        //add it to our view
        layerView.layer.addSublayer(blueLayer);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
