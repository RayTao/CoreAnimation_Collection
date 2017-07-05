//
//  TextPathController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 2017/7/5.
//  Copyright © 2017年 ray. All rights reserved.
//

import Foundation

class TextPathController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = "I‘m 六弦琴殇" as NSString
        text.animate(on: self.view,
                     at: CGRect(x: 120, y: 20, width: 200, height: 200),
                     for: UIFont.systemFont(ofSize: 30),
                     with: .red,
                     andDuration: 8.0)
    }
}
