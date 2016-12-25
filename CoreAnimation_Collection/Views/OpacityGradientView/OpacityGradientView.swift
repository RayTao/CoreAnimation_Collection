//
//  OpacityGradientView.swift
//  CoreAnimation_Collection
//
//  Created by ray on 2016/12/6.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class OpacityGradientView: UIView {

    fileprivate let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.init(white: 0, alpha: 0).cgColor,
                        UIColor.init(white: 0, alpha: 1.0).cgColor,
                        UIColor.init(white: 0, alpha: 1.0).cgColor,
                        UIColor.init(white: 0, alpha: 0).cgColor]
        return layer
    }()

    var ocapityHeight = 0.15
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.layer.mask == nil {
            self.layer.mask = self.gradientLayer;
        }
        if !bounds.equalTo(gradientLayer.frame) {
            gradientLayer.frame = bounds
            gradientLayer.locations = [0.0, ocapityHeight as NSNumber, (1-ocapityHeight) as NSNumber, 1];
        }
        
    }
    
}
