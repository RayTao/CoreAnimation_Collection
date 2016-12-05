//
//  ViewController.swift
//  GooeyTabbar
//
//  Created by KittenYang on 11/16/15.
//  Copyright © 2015 KittenYang. All rights reserved.
//

import UIKit

class GooeyViewController: UIViewController {

  var menu : TabbarMenu!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {

    menu = TabbarMenu(tabbarHeight: 40.0)
  
  }
  
    override func viewWillDisappear(_ animated: Bool) {
        menu.removeFromSuperview()
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
}

