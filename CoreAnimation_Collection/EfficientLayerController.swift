//
//  EfficientLayerController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/17.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

/// 圆角, 图层蒙版, 阴影等会出发离屏渲染, 可以使用CAShapeLayer,contentsCenter,shadowPath来优化
class OffscreenRenderController: UIViewController {

    let transformSegment = UISegmentedControl.init(items: ["RoundedCorners","image"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transformSegment.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(OffscreenRenderController.switchfuc(_:)), for: .valueChanged)
        self.view.addSubview(transformSegment)
        
        self.view.layer.addSublayer(shapeLayerRoundedCorners(CGRect(x: 50, y: 150, width: 100, height: 100)))
        self.view.layer.addSublayer(cornerRadiusAndMask(CGRect(x: 50, y: 150 + 100, width: 100, height: 100)))
        //contentsCenter: CGRectMake(0.5, 0.5, 0, 0))保证边框不变形，不影响性能
        self.view.layer.addSublayer(imageBackLayer(CGRect(x: 50 + 110, y: 150, width: 100, height: 100),contentsCenter: CGRect(x: 0.5, y: 0.5, width: 0, height: 0)))
        
        self.view.layer.addSublayer(maskRoundedLayer(CGRect(x: 50 + 110, y: 150 + 100, width: 100, height: 100)))

    }

    func switchfuc(_ segment: UISegmentedControl) {
        let index = segment.selectedSegmentIndex
        if let _ = self.view.layer.sublayers?.first {
            for sublayer in self.view.layer.sublayers! {
                if sublayer != transformSegment.layer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        
        switch (index){
        case 0:
            self.view.layer.addSublayer(shapeLayerRoundedCorners(CGRect(x: 50, y: 150, width: 100, height: 100)))
            self.view.layer.addSublayer(cornerRadiusAndMask(CGRect(x: 50, y: 150 + 100, width: 100, height: 100)))
        case 1:
            self.view.layer.addSublayer(imageBackLayer(CGRect(x: 50 + 110, y: 150, width: 100, height: 100),contentsCenter: CGRect(x: 0.5, y: 0.5, width: 0, height: 0)))
        default:
            break
        }
        
    }
    
    
    //
    func imageBackLayer(_ frame: CGRect,contentsCenter: CGRect) -> CALayer {
        let blueLayer = CALayer()
        blueLayer.frame = frame
        blueLayer.contentsCenter = contentsCenter
        blueLayer.contentsScale = UIScreen.main.scale
        blueLayer.contents = R.image.rounded()?.cgImage
        blueLayer.masksToBounds = true
        
        blueLayer.addSublayer(whiteLayer())
        return blueLayer
    }
    
    func cornerRadiusAndMask(_ frame: CGRect) -> CALayer {
        let redLayer = CALayer()
        redLayer.frame = frame
        redLayer.backgroundColor = UIColor.red.cgColor
        redLayer.cornerRadius = 20.0
        redLayer.masksToBounds = true
        
        redLayer.addSublayer(whiteLayer())
        return redLayer
    }
    
    func maskRoundedLayer(_ frame: CGRect) -> CALayer {
        
        let layer = CALayer()
        layer.frame = frame
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.blue.cgColor
        
        let blueLayer = CAShapeLayer()
        blueLayer.frame = layer.bounds
        blueLayer.fillColor = UIColor.blue.cgColor
        blueLayer.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: 20.0).cgPath
        
        layer.mask = blueLayer
        
        layer.addSublayer(whiteLayer())
        return layer
    }
    
    /**
     cornerRadius配合masksToBounds使用产生离屏渲染，所以用CAShapeLayer配合masksToBounds达成同样效果
     */
    func shapeLayerRoundedCorners(_ frame: CGRect) -> CAShapeLayer {
        
        let blueLayer = CAShapeLayer()
        blueLayer.frame = frame
        blueLayer.fillColor = UIColor.blue.cgColor
        blueLayer.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: 20.0).cgPath
        blueLayer.masksToBounds = true
        
        blueLayer.addSublayer(whiteLayer())
        
        return blueLayer
    }
    
    func whiteLayer() -> CALayer {
        let whiteLayer = CALayer()
        whiteLayer.frame = CGRect(x: -20, y: 0, width: 50, height: 50)
        whiteLayer.backgroundColor = UIColor.white.cgColor
        return whiteLayer
    }

}

class InvisiableViewController: UIViewController ,UIScrollViewDelegate {

    let scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: 320, height: 560))
    
    let WIDTH: CGFloat = 100.0
    let HEIGHT: CGFloat = 100.0
    let DEPTH: CGFloat = 10.0
    let SIZE: CGFloat = 100.0
    let SPACING: CGFloat = 150.0
    let CAMERA_DISTANCE: CGFloat = 500.0
    func PERSPECTIVE(_ z: CGFloat) -> CGFloat {
        return CAMERA_DISTANCE/(z + CAMERA_DISTANCE)
    }
    
    let recyclePool = NSMutableSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.scrollView.frame = self.view.bounds
        self.scrollView.contentSize =  CGSize(width: (WIDTH - 1)*SPACING,
            height: (HEIGHT - 1)*SPACING);
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        //set up perspective transform
        var transform = CATransform3DIdentity;
        transform.m34 = -1.0 / CAMERA_DISTANCE;
        self.scrollView.layer.sublayerTransform = transform;
    }

    override func viewDidLayoutSubviews() {
    
        updateLayers()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        updateLayers()
    }
    
    func updateLayers() {
        //calculate clipping bounds
        var bounds = self.scrollView.bounds
        bounds.origin = self.scrollView.contentOffset
        bounds = bounds.insetBy(dx: -SIZE/2.0, dy: -SIZE/2.0)
        
        //add existing layers to pool
        if self.scrollView.layer.sublayers != nil {
            self.recyclePool.addObjects(from: self.scrollView.layer.sublayers!);
        }
        
        //disable animation
        CATransaction.begin();
        CATransaction.setDisableActions(true);
        
        //create layers
        var recycled = 0;
        var visibleLayers: [CALayer] = []
        var z:CGFloat = DEPTH - 1.0
        while z >= 0.0 {
            z -= 1;
            //increase bounds size to compensate for perspective
            var adjusted = bounds
            adjusted.size.width /= PERSPECTIVE(z*SPACING)
            adjusted.size.height /= PERSPECTIVE(z*SPACING)
            adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2.0;
            adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2.0;
        
            for yl in 0 ..< Int(HEIGHT)
            {
                let y = CGFloat(yl);
                //check if vertically outside visible rect
                if (y*SPACING < adjusted.origin.y ||
                    y*SPACING >= adjusted.origin.y + adjusted.size.height)
                {
                    continue;
                }
                
                for xl in 0 ..< Int(WIDTH)
                {
                    let x = CGFloat(xl)
                    //check if horizontally outside visible rect
                    if (x*SPACING < adjusted.origin.x ||
                        x*SPACING >= adjusted.origin.x + adjusted.size.width)
                    {
                        continue;
                    }
                    
                    //recycle layer if available
                    var layer = self.recyclePool.anyObject() as! CALayer?;
                    if (layer != nil)
                    {
                        recycled += 1;
                        self.recyclePool.remove(layer!);
                    }
                    else
                    {
                        //otherwise create a new one
                        layer = CALayer();
                        layer?.frame = CGRect(x: 0, y: 0, width: SIZE, height: SIZE);
                    }
                    
                    layer?.position = CGPoint(x: x*SPACING, y: y*SPACING);
                    layer?.zPosition = -z*SPACING;
                    
                    //set background color
                    layer?.backgroundColor = UIColor.init(white: 1 - z*(1.0/DEPTH), alpha: 1.0).cgColor;
                    //attach to scroll view
                    visibleLayers.append(layer!);
                }
            }
        }
        
        CATransaction.commit()
        
        self.scrollView.layer.sublayers = visibleLayers

        print("displayed: " + "\(visibleLayers.count)/" + "\(DEPTH*HEIGHT*WIDTH)")
        print("recycled: " + "\(recycled)")
//        visibleLayers = nil
        
    }
    
}



