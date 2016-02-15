//
//  ExplicitAnimationViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/17.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class PropertyAnimationViewController: UIViewController {

    let layerView = UIView.init(frame: CGRectMake(0, 0, 200, 200))
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.center = self.view.center
        self.view.addSubview(layerView)
        
        colorLayer.frame = CGRectMake(50, 50, 100, 100)
        self.colorLayer.backgroundColor = UIColor.blueColor().CGColor;
        layerView.layer.addSublayer(colorLayer)
        
        let changeColorBtn = UIButton.init(frame: CGRectMake(layerView.bounds.width/2-60,
            layerView.bounds.maxY - 40, 120, 31))
        changeColorBtn.addTarget(self, action: "changeColor", forControlEvents: .TouchUpInside)
        changeColorBtn.layer.borderColor = UIColor.darkGrayColor().CGColor
        changeColorBtn.layer.borderWidth = 1.0
        changeColorBtn.setTitle("change Color", forState: .Normal)
        changeColorBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        layerView.addSubview(changeColorBtn)
        
    }
    
    func changeColor() {
        //randomize the layer background color
        let red = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        
        //create a basic animation
        let animation = CABasicAnimation();
        animation.keyPath = "backgroundColor";
        animation.toValue = randomColor.CGColor;
        animation.duration = 2.0
        animation.delegate = self;
        
        //uncomment the two lines below to solve the snap-back problem
        //animation.fromValue = self.colorLayer.backgroundColor;
        //self.colorLayer.backgroundColor = color.CGColor;
        
        //apply animation to layer
        self.colorLayer.addAnimation(animation, forKey: nil)
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //set the backgroundColor property to match animation toValue
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.colorLayer.backgroundColor = (anim as! CABasicAnimation).toValue as! CGColor?
        CATransaction.commit()
        
    }
}

class CAKeyframeAnimationViewController: PropertyAnimationViewController {

    let animationKey = "rotateAnimation"
    let shipLayer = CALayer();
    let bezierPath = UIBezierPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a path
        bezierPath.moveToPoint(CGPointMake(0, 150));
        bezierPath.addCurveToPoint(CGPointMake(300, 150),
            controlPoint1:CGPointMake(75, 0),
            controlPoint2:CGPointMake(225, 300));
        
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.CGPath;
        pathLayer.fillColor = UIColor.clearColor().CGColor;
        pathLayer.strokeColor = UIColor.redColor().CGColor;
        pathLayer.lineWidth = 3.0;
        self.view.layer.addSublayer(pathLayer);
        
        //add the ship
        shipLayer.frame = CGRectMake(0, 0, 64, 64);
        shipLayer.position = CGPointMake(0, 150);
        shipLayer.contents = R.image.ship?.CGImage
        self.view.layer.addSublayer(shipLayer)
        
        start()
    }

    func start() {
        //create the keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "position";
        animation.duration = 4.0;
        animation.path = bezierPath.CGPath;
        animation.rotationMode = "auto"
        shipLayer.addAnimation(animation, forKey:animationKey);
        
    }
    
    override func changeColor() {
        //create a keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "backgroundColor";
        animation.duration = 2.0;
        animation.values = [
        UIColor.blueColor().CGColor,
        UIColor.redColor().CGColor,
        UIColor.greenColor().CGColor,
        UIColor.blueColor().CGColor
        ];
        
        //apply animation to layer
        self.colorLayer.addAnimation(animation, forKey:nil);
    }
}

class RotationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        let shipLayer = CALayer();
        shipLayer.frame = CGRectMake(0, 0, 128, 128);
        shipLayer.position = CGPointMake(150, 150);
        shipLayer.contents = R.image.ship?.CGImage
        self.view.layer.addSublayer(shipLayer);
        
        //animate the ship rotation
        let animation = CABasicAnimation();
        animation.keyPath = "transform.rotation.x";
        animation.duration = 2.0;
        animation.byValue = (M_PI * 2);
        shipLayer.addAnimation(animation, forKey:nil);
        
    }

}

/// CAAnimationGroup：将一组动画组合起来
class AnimationGroupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a path
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 150));
        bezierPath.addCurveToPoint(CGPointMake(300, 150),
            controlPoint1:CGPointMake(75, 0),
            controlPoint2:CGPointMake(225, 300));
       
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.CGPath;
        pathLayer.fillColor = UIColor.clearColor().CGColor;
        pathLayer.strokeColor = UIColor.redColor().CGColor;
        pathLayer.lineWidth = 3.0;
        self.view.layer.addSublayer(pathLayer);
        
        //add a colored layer
        let colorLayer = CALayer();
        colorLayer.frame = CGRectMake(0, 0, 64, 64);
        colorLayer.position = CGPointMake(0, 150);
        colorLayer.backgroundColor = UIColor.greenColor().CGColor;
        self.view.layer.addSublayer(colorLayer);
        
        //create the keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "position";
        animation.duration = 4.0;
        animation.path = bezierPath.CGPath;
        animation.rotationMode = "auto"

        let animation2 = CABasicAnimation()
        animation2.keyPath = "backgroundColor"
        animation2.toValue = UIColor.redColor().CGColor
        
        //create group animation
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, animation2];
        groupAnimation.duration = 4.0;
        
        //add the animation to the color layer
        colorLayer.addAnimation(groupAnimation, forKey:nil);
        
    }
}

/// CATransition: 转场动画
class TransitionViewController: UIViewController {
    
    let imageView = UIImageView.init(image: R.image.spaceship)
    let images = [R.image.anchor, R.image.cone,
        R.image.igloo, R.image.spaceship]
    let animationKey = "transition"
    var transitionDirection = kCATransitionFromLeft;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        
        let transformSegment = UISegmentedControl.init(items: [kCATransitionFade,kCATransitionPush,kCATransitionMoveIn,kCATransitionReveal])
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: "switchImage:", forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)

        let directionSegment = UISegmentedControl.init(items: [kCATransitionFromTop,kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromRight])
        directionSegment.center = CGPointMake(self.view.center.x, transformSegment.frame.minY - 50)
        directionSegment.apportionsSegmentWidthsByContent = true
        directionSegment.addTarget(self, action: "switchDirection:", forControlEvents: .ValueChanged)
        self.view.addSubview(directionSegment)
        
    }

    func switchDirection(segment: UISegmentedControl) {
    
        self.transitionDirection = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)!;
    }
    
    func switchImage(segment: UISegmentedControl) {
        
        if let animation = self.imageView.layer.animationForKey(animationKey) {
            let transition = animation as! CATransition
            transition.type = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)!;
            transition.subtype = transitionDirection
        } else {
            //set up crossfade transition
            let transition = CATransition();
            transition.type = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)!;
            transition.subtype = transitionDirection

            //apply transition to imageview backing layer
            self.imageView.layer.addAnimation(transition, forKey:animationKey);
        }
        
        //cycle to next image
        let currentImage = self.imageView.image;
        var index = self.images.indexOf({ (indexImage) -> Bool in
            indexImage == currentImage
        })!
        index = (index + 1) % self.images.count;
        self.imageView.image = self.images[index];
        
    }

}

class LayerTreeTransitionController: UIViewController {

    let animationKey = "LayerTree"
    let properVC = PropertyAnimationViewController()
    let keyFrameVC = RotationViewController()
    var subLayer: CALayer = CALayer.init()
    var change = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        properVC.view.bounds = self.view.frame
        keyFrameVC.view.bounds = self.view.frame
        
        subLayer = keyFrameVC.view.layer
        self.view.layer.addSublayer(subLayer)
        
        let button = UIButton.init(frame: CGRectMake(0, 0, 200, 45))
        button.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        button.setTitle("changeChildViewController", forState: .Normal)
        button.addTarget(self, action: "changeAni", forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
    }

    func changeAni() {
        change = !change
        
        //set up crossfade transition
        let transition = CATransition();
        transition.type = kCATransitionPush;
        self.view.layer.addAnimation(transition, forKey: nil)
        
        for index in 0..<self.view.layer.sublayers!.count {
            if self.view.layer.sublayers![index] == subLayer {
                if change {
                    self.view.layer.sublayers![index] = keyFrameVC.view.layer
                    subLayer = keyFrameVC.view.layer

                } else {
                    self.view.layer.sublayers![index] = properVC.view.layer
                    subLayer = properVC.view.layer

                }
            }
        }
    }
    
    deinit {
        print(self.description + " deinit");
    }
    
}

class CustomTransitionController: UIViewController {

    let button = UIButton.init(frame: CGRectMake(0, 0, 200, 45))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.center = self.view.center
        button.setTitle("performTransition", forState: .Normal)
        button.addTarget(self, action: "performTransition", forControlEvents: .TouchUpInside)
        button
        self.view.addSubview(button)
        
    }
    
    
    func performTransition() {
        button.enabled = false
        
        //preserve the current view snapshot
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0.0);
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        let coverImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //insert snapshot view in front of this one
        let coverView = UIImageView.init(image: coverImage)
        coverView.frame = self.view.bounds;
        self.view.addSubview(coverView);
        
        //update the view (we'll simply randomize the layer background color)
        let red = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            self.view.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        
        //perform animation (anything you like)
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            //scale, rotate and fade the view
            var transform = CGAffineTransformMakeScale(0.01, 0.01);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
            coverView.transform = transform;
            coverView.alpha = 0.0;
            
            }) { (finished) -> Void in
                coverView.removeFromSuperview()
                self.button.enabled = true

        }
    }
}

class StopAnimationController: CAKeyframeAnimationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stopbutton = UIButton.init(frame: CGRectMake(0, 0, 200, 45))
        stopbutton.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        stopbutton.setTitle("stop", forState: .Normal)
        stopbutton.backgroundColor = UIColor.blueColor()
        stopbutton.addTarget(self, action: "stop", forControlEvents: .TouchUpInside)
        self.view.addSubview(stopbutton)
        
        let startbutton = UIButton.init(frame: CGRectMake(0, 0, 200, 45))
        startbutton.center = CGPointMake(self.view.center.x, stopbutton.frame.minY - 50)
        startbutton.setTitle("start", forState: .Normal)
        startbutton.backgroundColor = UIColor.purpleColor()
        startbutton.addTarget(self, action: "start", forControlEvents: .TouchUpInside)
        self.view.addSubview(startbutton)
    }

    func stop() {
        self.shipLayer.removeAnimationForKey(animationKey)
    }

}





