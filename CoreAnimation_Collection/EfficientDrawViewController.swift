//
//  EfficientDrawViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/17.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class EfficientDrawViewController: UIViewController {

    let drawView = EfficientDrawView.init(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addSubview(drawView)
        drawView.frame = self.view.bounds;
        drawView.backgroundColor = self.view.backgroundColor;
    }
}
