//
//  ViewController.swift
//  SwitcherCollection
//
//  Created by Tbxark on 15/10/25.
//  Copyright © 2015年 TBXark. All rights reserved.
//

import UIKit

var count : Int = 0

class SwitchersCollectionViewController: UIViewController {
    
    @IBOutlet var switchArray: [TKBaseSwitch]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "SwitchersCollectionViewController", bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    @objc func animateSwitch(_ timer:Timer){
        switchArray[count].changeValue()
        count += 1
        if count  == (switchArray.count){
            count = 0
            timer.invalidate()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(SwitchersCollectionViewController.animateSwitch(_:)), userInfo: nil, repeats: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

