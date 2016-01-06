//
//  ContentsViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/13.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class ContentsGravitysViewController: UIViewController {
    let layerView = UIView()
    let contentsGravitys:[String] = [kCAGravityCenter,kCAGravityTop,kCAGravityBottom,kCAGravityLeft,kCAGravityRight,kCAGravityTopLeft,kCAGravityTopRight,kCAGravityBottomLeft,kCAGravityBottomRight,kCAGravityResize,kCAGravityResizeAspect,kCAGravityResizeAspectFill]
    var segmentContentsArray: [UISegmentedControl]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //create sublayer
        layerView.frame = CGRectMake(0, 0, 200, 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(layerView)
        
        for(var i = 0; i < contentsGravitys.count; i += 4) {
            var array = [contentsGravitys[i],contentsGravitys[i+1],contentsGravitys[i+2]]
            if i+3 < contentsGravitys.count {
                array.append(contentsGravitys[i+3])
            }
            let segmentContents = UISegmentedControl.init(items: array)
            segmentContents.apportionsSegmentWidthsByContent = true
            segmentContents.center = CGPointMake(layerView.center.x, layerView.center.y + 150.0 + CGFloat(40 * i / 4))
            segmentContents.addTarget(self, action: "contentsGravitysChange:", forControlEvents: .ValueChanged)
            self.view.addSubview(segmentContents)
        }
        
        let image = R.image.snowman
        //add it directly to our view's layer
        self.layerView.layer.contents = image?.CGImage;
    }

    func contentsGravitysChange(segment: UISegmentedControl) {
        let contentsGravity = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)
        self.layerView.layer.contentsGravity = contentsGravity!;

    }
}

class ContentsScaleViewController: UIViewController {
    let layerView = UIView()
    let maskSegmentContents = UISegmentedControl.init(items: ["masksToBoundsOn","masksToBoundsOff"])
    let scaleSegmentContents = UISegmentedControl.init(items: ["scaleOn","scaleOff"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //create sublayer
        layerView.frame = CGRectMake(0, 0, 200, 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(layerView)
        
        let image = R.image.snowman!
        //add it directly to our view's layer
        self.layerView.layer.contents = image.CGImage;
        
        //center the image
        self.layerView.layer.contentsGravity = kCAGravityCenter;

        maskSegmentContents.apportionsSegmentWidthsByContent = true
        maskSegmentContents.center = CGPointMake(layerView.center.x, layerView.center.y + 150.0)
        maskSegmentContents.addTarget(self, action: "contentsGravitysChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(maskSegmentContents)
        
        scaleSegmentContents.apportionsSegmentWidthsByContent = true
        scaleSegmentContents.center = CGPointMake(layerView.center.x, layerView.center.y + 150.0 + 40)
        scaleSegmentContents.addTarget(self, action: "contentsGravitysChange:", forControlEvents: .ValueChanged)
        self.view.addSubview(scaleSegmentContents)

    }
    
    func contentsGravitysChange(segment: UISegmentedControl) {
        let image = R.image.snowman!
        let onOrOff = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)!
        if (onOrOff.hasSuffix("On")) {
            if segment == self.maskSegmentContents {
                self.layerView.layer.masksToBounds = true;
            } else {
                self.layerView.layer.contentsScale = image.scale;
                
            }
        } else {
            if segment == self.maskSegmentContents {
                self.layerView.layer.masksToBounds = false;
            } else {
                self.layerView.layer.contentsScale = 1.0;
            }
        }
    }

}

class ContentsRectViewController: UIViewController {

    private let coneView = UIView.init(frame: CGRectMake(10, 10 + 60, 128, 128))
    private let shipView = UIView.init(frame: CGRectMake(148, 10 + 60, 128, 128))
    private let iglooVIew = UIView.init(frame: CGRectMake(10, 148 + 60, 128, 128))
    private let anchorView = UIView.init(frame: CGRectMake(148, 148 + 60, 128, 128))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(coneView)
        self.view.addSubview(shipView)
        self.view.addSubview(iglooVIew)
        self.view.addSubview(anchorView)
        for index in 0..<self.view.subviews.count {
            let subview = self.view.subviews[index]
            subview.backgroundColor = UIColor.whiteColor()
        }
        
        let image = R.image.sprites!
        self.addSpriteImage(image, contentRect: CGRectMake(0, 0, 0.5, 0.5),toLayer: iglooVIew.layer)
        self.addSpriteImage(image, contentRect: CGRectMake(0.5, 0, 0.5, 0.5),toLayer: coneView.layer)
        self.addSpriteImage(image, contentRect: CGRectMake(0, 0.5, 0.5, 0.5),toLayer: anchorView.layer)
        self.addSpriteImage(image, contentRect: CGRectMake(0.5, 0.5, 0.5, 0.5),toLayer: shipView.layer)
    }

    func addSpriteImage(image: UIImage, contentRect rect: CGRect,toLayer layer: CALayer) {
        //set image
        layer.contents = image.CGImage
        //scale contents to fit
        layer.contentsGravity = kCAGravityResizeAspect;
        //set contentsRect
        layer.contentsRect = rect;
    }
}

class ContentsCenterViewController: UIViewController {
    
    private let button1 = UIView.init(frame: CGRectMake(68.5, 70, 100, 243))
    private let button2 = UIView.init(frame: CGRectMake(68.5, 320, 243, 100))
    private let button3 = UIView.init(frame: CGRectMake(200, 70, 100, 243))
    private let button4 = UIView.init(frame: CGRectMake(68.5, 440, 243, 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        self.view.addSubview(button4)
        
        let image = R.image.button!
        addStretchableImage(image, contentCenter: CGRectMake(0.25, 0.25, 0.5, 0.5), toLayer: button1.layer)
        addStretchableImage(image, contentCenter: CGRectMake(0.25, 0.25, 0.5, 0.5), toLayer: button2.layer)
        addStretchableImage(image, contentCenter: CGRectMake(0, 0, 1, 1), toLayer: button3.layer)
        addStretchableImage(image, contentCenter: CGRectMake(0, 0, 1, 1), toLayer: button4.layer)
    }
    
    func addStretchableImage(image: UIImage, contentCenter rect: CGRect,toLayer layer: CALayer) {
        //set image
        layer.contents = image.CGImage
        //set contentsCenter
        layer.contentsCenter = rect;
    }
    
}

class DrawingViewController: UIViewController {
    var layerView: UIView = UIView()
    let blueLayer = CALayer()
    //MARK: blueLayer.delegate必须在deinit设为nil（apple的weak不起作用）不然会崩溃
    deinit {
        print("DrawingViewController deinit")
        blueLayer.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerView.frame = CGRectMake(0, 0, 200, 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(layerView)
        
        blueLayer.frame = CGRectMake(50, 50, 100, 100)
        blueLayer.backgroundColor = UIColor.blueColor().CGColor
        
        //set controller as layer delegate
        blueLayer.delegate = self;
        //ensure that layer backing image uses correct scale
        blueLayer.contentsScale = UIScreen.mainScreen().scale;
        //add layer to our view
        self.layerView.layer.addSublayer(blueLayer)
        //force layer to redraw
        blueLayer.display()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    /**
     <#Description#>
     
     - parameter layer: <#layer description#>
     - parameter ctx:   <#ctx description#>
     */
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        //draw a thick red circle
        CGContextSetLineWidth(ctx, 10.0);
        CGContextSetStrokeColorWithColor(ctx, UIColor.redColor().CGColor);
        CGContextStrokeEllipseInRect(ctx, layer.bounds);
    }

}







