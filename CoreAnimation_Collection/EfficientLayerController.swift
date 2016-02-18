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
        
        
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: "switchfuc:", forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)
        
        self.view.layer.addSublayer(shapeLayerRoundedCorners(CGRectMake(50, 150, 100, 100)))
        self.view.layer.addSublayer(cornerRadiusAndMask(CGRectMake(50, 150 + 100, 100, 100)))
        //contentsCenter: CGRectMake(0.5, 0.5, 0, 0))保证边框不变形，不影响性能
        self.view.layer.addSublayer(imageBackLayer(CGRectMake(50 + 110, 150, 100, 100),contentsCenter: CGRectMake(0.5, 0.5, 0, 0)))
        
        self.view.layer.addSublayer(maskRoundedLayer(CGRectMake(50 + 110, 150 + 100, 100, 100)))

    }

    func switchfuc(segment: UISegmentedControl) {
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
            self.view.layer.addSublayer(shapeLayerRoundedCorners(CGRectMake(50, 150, 100, 100)))
            self.view.layer.addSublayer(cornerRadiusAndMask(CGRectMake(50, 150 + 100, 100, 100)))
        case 1:
            self.view.layer.addSublayer(imageBackLayer(CGRectMake(50 + 110, 150, 100, 100),contentsCenter: CGRectMake(0.5, 0.5, 0, 0)))
        default:
            break
        }
        
    }
    
    
    //
    func imageBackLayer(frame: CGRect,contentsCenter: CGRect) -> CALayer {
        let blueLayer = CALayer()
        blueLayer.frame = frame
        blueLayer.contentsCenter = contentsCenter
        blueLayer.contentsScale = UIScreen.mainScreen().scale
        blueLayer.contents = R.image.rounded?.CGImage
        blueLayer.masksToBounds = true
        
        blueLayer.addSublayer(whiteLayer())
        return blueLayer
    }
    
    func cornerRadiusAndMask(frame: CGRect) -> CALayer {
        let redLayer = CALayer()
        redLayer.frame = frame
        redLayer.backgroundColor = UIColor.redColor().CGColor
        redLayer.cornerRadius = 20.0
        redLayer.masksToBounds = true
        
        redLayer.addSublayer(whiteLayer())
        return redLayer
    }
    
    func maskRoundedLayer(frame: CGRect) -> CALayer {
        
        let layer = CALayer()
        layer.frame = frame
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.blueColor().CGColor
        
        let blueLayer = CAShapeLayer()
        blueLayer.frame = layer.bounds
        blueLayer.fillColor = UIColor.blueColor().CGColor
        blueLayer.path = UIBezierPath.init(roundedRect: CGRectMake(0, 0, frame.width, frame.height), cornerRadius: 20.0).CGPath
        
        layer.mask = blueLayer
        
        layer.addSublayer(whiteLayer())
        return layer
    }
    
    /**
     cornerRadius配合masksToBounds使用产生离屏渲染，所以用CAShapeLayer配合masksToBounds达成同样效果
     */
    func shapeLayerRoundedCorners(frame: CGRect) -> CAShapeLayer {
        
        let blueLayer = CAShapeLayer()
        blueLayer.frame = frame
        blueLayer.fillColor = UIColor.blueColor().CGColor
        blueLayer.path = UIBezierPath.init(roundedRect: CGRectMake(0, 0, frame.width, frame.height), cornerRadius: 20.0).CGPath
        blueLayer.masksToBounds = true
        
        blueLayer.addSublayer(whiteLayer())
        
        return blueLayer
    }
    
    func whiteLayer() -> CALayer {
        let whiteLayer = CALayer()
        whiteLayer.frame = CGRectMake(-20, 0, 50, 50)
        whiteLayer.backgroundColor = UIColor.whiteColor().CGColor
        return whiteLayer
    }

}

class InvisiableViewController: UIViewController ,UIScrollViewDelegate {

    let scrollView = UIScrollView.init(frame: CGRectMake(0, 0, 320, 560))
    
    let WIDTH: CGFloat = 100.0
    let HEIGHT: CGFloat = 100.0
    let DEPTH: CGFloat = 10.0
    let SIZE: CGFloat = 100.0
    let SPACING: CGFloat = 150.0
    let CAMERA_DISTANCE: CGFloat = 500.0
    func PERSPECTIVE(z: CGFloat) -> CGFloat {
        return CAMERA_DISTANCE/(z + CAMERA_DISTANCE)
    }
    
    let recyclePool = NSMutableSet()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = self.view.bounds
        self.scrollView.contentSize =  CGSizeMake((WIDTH - 1)*SPACING,
            (HEIGHT - 1)*SPACING);
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        //set up perspective transform
        var transform = CATransform3DIdentity;
        transform.m34 = -1.0 / CAMERA_DISTANCE;
        self.scrollView.layer.sublayerTransform = transform;
    }

//    override func viewDidLayoutSubviews() {
//    
//        updateLayers()
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        updateLayers()
    }
    
    func updateLayers() {
        //calculate clipping bounds
        var bounds = self.scrollView.bounds
        bounds.origin = self.scrollView.contentOffset
        bounds = CGRectInset(bounds, -SIZE/2.0, -SIZE/2.0)
        
        //add existing layers to pool
        if self.scrollView.layer.sublayers != nil {
            self.recyclePool.addObjectsFromArray(self.scrollView.layer.sublayers!);
        }
        
        //disable animation
        CATransaction.begin();
        CATransaction.setDisableActions(true);
        
        //create layers
        var recycled = 0;
        let visibleLayers: NSMutableArray = NSMutableArray()
        for (var z = DEPTH-1; z >= 0; z--) {
            //increase bounds size to compensate for perspective
            var adjusted = bounds
            adjusted.size.width /= PERSPECTIVE(z*SPACING)
            adjusted.size.height /= PERSPECTIVE(z*SPACING)
            adjusted.origin.x -= (adjusted.size.width - bounds.size.width) / 2;
            adjusted.origin.y -= (adjusted.size.height - bounds.size.height) / 2;
        
            for (var y:CGFloat = 0.0; y < HEIGHT; y++)
            {
                //check if vertically outside visible rect
                if (y*SPACING < adjusted.origin.y ||
                    y*SPACING >= adjusted.origin.y + adjusted.size.height)
                {
                    continue;
                }
                
                for (var x: CGFloat = 0.0; x < WIDTH; x++)
                {
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
                        recycled++;
                        self.recyclePool.removeObject(layer!);
                    }
                    else
                    {
                        //otherwise create a new one
                        layer = CALayer();
                        layer?.frame = CGRectMake(0, 0, SIZE, SIZE);
                    }
                    
                    layer?.position = CGPointMake(x*SPACING, y*SPACING);
                    layer?.zPosition = -z*SPACING;
                    
                    //set background color
                    layer?.backgroundColor = UIColor.init(white: 1 - z*(1.0/DEPTH), alpha: 1.0).CGColor;
                    //attach to scroll view
                    visibleLayers.addObject(layer!);
                }
            }
        }
        
        CATransaction.commit()
        
        self.scrollView.layer.sublayers = visibleLayers as AnyObject as? [CALayer]

        print("displayed: " + "\(visibleLayers.count)/" + "\(DEPTH*HEIGHT*WIDTH)")
        print("recycled: " + "\(recycled)")
//        visibleLayers = nil
        
    }
    
}



