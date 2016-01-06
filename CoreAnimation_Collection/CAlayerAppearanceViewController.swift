//
//  CAlayerAppearanceViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/16.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class CornerRadiusViewController: UIViewController {

    let layerView1 = UIView()
    let layerView2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //set the corner radius on our layers
        self.layerView1.layer.cornerRadius = 20.0;
        layerView1.backgroundColor = UIColor.whiteColor()
        layerView1.frame = CGRectMake(100, 100, 100, 100)
        self.view.addSubview(layerView1)
        
        self.layerView2.layer.cornerRadius = 20.0;
        layerView2.backgroundColor = UIColor.redColor()
        layerView2.frame = CGRectMake(-25, -25, 70, 70)
        self.layerView1.addSubview(layerView2)
        
        //enable clipping on the second layer
        dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 2)), dispatch_get_main_queue()) { () -> Void in
            self.layerView1.layer.masksToBounds = true;
        }
    }
}

class BorderViewController: UIViewController {
    let layerView1 = UIView()
    let layerView2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //set the corner radius on our layers
        self.layerView1.layer.cornerRadius = 20.0;
        layerView1.backgroundColor = UIColor.whiteColor()
        layerView1.frame = CGRectMake(100, 100, 100, 100)
        //边框随着图层边界变化，而不是图层内容
        layerView1.layer.borderWidth = 5.0
        self.view.addSubview(layerView1)
        
        self.layerView2.layer.cornerRadius = 20.0;
        layerView2.backgroundColor = UIColor.redColor()
        layerView2.frame = CGRectMake(-25, -25, 70, 70)
        self.layerView1.addSubview(layerView2)
        
        //enable clipping on the second layer
        dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 2)), dispatch_get_main_queue()) { () -> Void in
            self.layerView1.layer.masksToBounds = true;
        }
    }
}

class MaskLayerController: UIViewController {
    let msakLayer = CALayer()
    let imageLayer = CALayer()
    let imageView = UIImageView.init(image: R.image.igloo)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageSize = R.image.cone!.size
        msakLayer.contents = R.image.cone?.CGImage
        msakLayer.frame = CGRectMake(15, 50, imageSize.width, imageSize.height)
        self.view.layer.addSublayer(msakLayer)
        
        imageSize = R.image.igloo!.size
        imageLayer.contents = R.image.igloo?.CGImage
        imageLayer.frame = CGRectMake(CGRectGetMaxX(msakLayer.frame) + 5, 50, imageSize.width, imageSize.height)
        self.view.layer.addSublayer(imageLayer)
        
        imageView.frame = imageLayer.frame
        self.view.addSubview(imageView)
        let newMaskLayer = CALayer()
        newMaskLayer.contents = msakLayer.contents
        newMaskLayer.frame = imageView.bounds
        imageView.layer.mask = newMaskLayer
        imageView.center = CGPointMake(self.view.center.x, imageView.center.y + imageSize.height + 10)

    }

    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.whiteColor()

    }
}

class MiniAndMagnificationFilterController: UIViewController {
    
    var digitViews: [UIView] = [];
    var timer: NSTimer? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let digitsImage = R.image.digits
        for index in 0...5 {
            let subview = UIView.init(frame: CGRectMake(5.0 + CGFloat(index * 50), 70, 50, 100))
            
            //set contents
            subview.layer.contents = digitsImage!.CGImage;
            subview.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
            subview.layer.contentsGravity = kCAGravityResizeAspect;
            
            //use nearest-neighbor scaling
            view.layer.magnificationFilter = kCAFilterNearest;
            
            self.view.addSubview(subview)
            digitViews.append(subview)
        };
        
        let switcher = UISwitch()
        switcher.addTarget(self, action: "changeFilter:", forControlEvents: .ValueChanged)
        switcher.center = CGPointMake(self.view.center.x, digitViews[0].frame.maxY + 20)
        self.view.addSubview(switcher)
        
    }
    
    deinit {
        print(self.description + " deinit");
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //start timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        tick()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func setDigit(digit: Int,view: UIView) {
        view.layer.contentsRect = CGRectMake(CGFloat(digit) * 0.1, 0, 0.1, 1.0)
    }
    
    func changeFilter(switcher: UISwitch) {
        for index in 0...5 {
            //use nearest-neighbor scaling
            if switcher.on {
                digitViews[index].layer.magnificationFilter = kCAFilterNearest;
            } else {
                digitViews[index].layer.magnificationFilter = kCAFilterLinear;
            }
        };
        
       
    }
    
    func tick() {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = calendar?.components([.Hour,.Minute,.Second], fromDate: NSDate())
        
        setDigit((components?.hour)! / 10, view: digitViews[0])
        setDigit((components?.hour)! % 10, view: digitViews[1])
        
        setDigit((components?.minute)! / 10, view: digitViews[2])
        setDigit((components?.minute)! % 10, view: digitViews[3])
        
        setDigit((components?.second)! / 10, view: digitViews[4])
        setDigit((components?.second)! % 10, view: digitViews[5])
    }
}

class GroupOpacityController:UIViewController {

    let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = UIColor.clearColor()
        containerView.alpha = 1.0

        containerView.frame = self.view.bounds
        self.view.addSubview(containerView)
        
        let button1 = helloButton()
        button1.center = CGPointMake(50, 150);
        containerView.addSubview(button1)
        
        let button2 = helloButton()
        button2.tag = 100
        button2.center = CGPointMake(250, 150);
        button2.alpha = 0.5;
//        let helloLabel = button2.viewWithTag(111)!
//        helloLabel.alpha = 0.5
        
        containerView.addSubview(button2)
        
      
        let switcher = UISwitch()
        switcher.addTarget(self, action: "changeGroupOpacity:", forControlEvents: .ValueChanged)
        switcher.center = CGPointMake(self.view.center.x, button2.frame.maxY + 20)
        self.view.addSubview(switcher)
    }
    
    func changeGroupOpacity(switcher:UISwitch) {
        let button2: UIView = containerView.viewWithTag(100)!
        if switcher.on {
            //enable rasterization for the translucent button
            
            button2.layer.shouldRasterize = true;
            button2.layer.rasterizationScale = UIScreen.mainScreen().scale;
        } else {
            //enable rasterization for the translucent button
            button2.layer.shouldRasterize = true;
            button2.layer.rasterizationScale = UIScreen.mainScreen().scale;
        }
    }
    
    func helloButton() -> UIView {
        
        //create button
        var frame = CGRectMake(0, 0, 150, 50);
        let button = UIView.init(frame: frame)
        button.backgroundColor = UIColor.whiteColor();
        button.layer.cornerRadius = 10;
        
        //add label
        frame = CGRectMake(20, 10, 110, 30);
        let helloLabel = UILabel.init(frame: frame);
        helloLabel.text = "Hello World";
        helloLabel.backgroundColor = UIColor.whiteColor();
        helloLabel.textAlignment = .Center;
        helloLabel.tag = 111;
        button.addSubview(helloLabel)

        return button
    }
    
}


class ShadowViewController: UIViewController {
    let layerView1 = UIView()
    let layerView2 = UIView()
    let shadowView = UIView()
    let cone1 = UIImageView.init(image: R.image.cone)
    let cone2 = UIImageView.init(image: R.image.cone)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //为了不受裁剪影响，添加额外的阴影视图
        //add same shadow to shadowView (not layerView1)
        self.shadowView.layer.shadowOpacity = 0.5;
        self.shadowView.layer.shadowOffset = CGSizeMake(0.0, 5.0);
        self.shadowView.layer.shadowRadius = 5.0;
        self.view.addSubview(shadowView)
        
        //set the corner radius on our layers
        self.layerView1.layer.cornerRadius = 20.0;
        layerView1.backgroundColor = UIColor.whiteColor()
        layerView1.frame = CGRectMake(100, 100, 100, 100)
        
        shadowView.frame = layerView1.bounds
        //边框随着图层边界变化，而不是图层内容
        layerView1.layer.borderWidth = 5.0
        shadowView.addSubview(layerView1)
        
        self.layerView2.layer.cornerRadius = 20.0;
        layerView2.backgroundColor = UIColor.redColor()
        layerView2.frame = CGRectMake(-25, -25, 70, 70)
        layerView1.addSubview(layerView2)
        
        let switcher = UISwitch()
        switcher.addTarget(self, action: "changeAnchorPoint:", forControlEvents: .ValueChanged)
        switcher.center = CGPointMake(self.view.center.x, shadowView.frame.maxY + 20)
        self.view.addSubview(switcher)
        
        cone1.center = CGPointMake(self.view.center.x - 100, self.view.center.y)
        cone2.hidden = true
        cone1.hidden = true
        cone2.center = CGPointMake(self.view.center.x + 100, self.view.center.y)
        //enable layer shadows
        cone1.layer.shadowOpacity = 0.5;
        cone2.layer.shadowOpacity = 0.5;
        //create a square shadow
        let squarePath = CGPathCreateMutable();
        CGPathAddRect(squarePath, nil, self.cone1.bounds);
        cone1.layer.shadowPath = squarePath;
//        CGPathRelease(squarePath);
        
        //create a circular shadow
        let circlePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(circlePath, nil, self.cone2.bounds);
        self.cone2.layer.shadowPath = circlePath;
//        CGPathRelease(circlePath);
        
        self.view.addSubview(cone1)
        self.view.addSubview(cone2)
        
        //enable clipping on the second layer
        dispatch_after(dispatch_time( DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC * 2)), dispatch_get_main_queue()) { () -> Void in
            self.layerView1.layer.masksToBounds = true;
        }
    }
    
    func changeAnchorPoint(switcher: UISwitch) {
        if (switcher.on) {
            cone2.hidden = false
            cone1.hidden = false
            shadowView.hidden = true
        } else {
            cone2.hidden = true
            cone1.hidden = true
            shadowView.hidden = false
        }
    }
}

