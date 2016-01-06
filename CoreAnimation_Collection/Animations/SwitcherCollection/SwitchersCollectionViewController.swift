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
    
    @IBOutlet var switchArray: [TKMainSwitch]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "SwitchersCollectionViewController", bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    func animateSwitch(timer:NSTimer){
        switchArray[count].changeValue()
        count++
        if count  == (switchArray.count){
            count = 0
            timer.invalidate()
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "animateSwitch:", userInfo: nil, repeats: true)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

