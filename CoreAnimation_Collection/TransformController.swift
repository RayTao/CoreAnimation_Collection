//
//  TransformController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/6.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class AffineTransformController: UIViewController {

    let layerView = UIImageView.init(image: R.image.snowman)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSize = layerView.image?.size
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.frame = CGRectMake(50, 50, (imageSize?.width)!, (imageSize?.height)!)

        self.view.addSubview(layerView)
        
        var transform = rotation45Transform();
        transform = combineTransform()
        
        //apply transform to layer
        self.layerView.layer.setAffineTransform(transform);
    }
    
    func rotation45Transform() -> CGAffineTransform {
        //rotate the layer 45 degrees
       return CGAffineTransformMakeRotation(CGFloat(M_PI_4))
    }
    
    func combineTransform() -> CGAffineTransform {
        var transform = CGAffineTransformIdentity;
        
        //scale by 50%
        transform = CGAffineTransformScale(transform, 0.5, 0.5);
        
        //rotate by 30 degrees
        transform = CGAffineTransformRotate(transform, CGFloat( M_PI / 180.0 * 30.0));
        
        //translate by 200 points
        transform = CGAffineTransformTranslate(transform, 200, 0);
        return transform
    }
    


}