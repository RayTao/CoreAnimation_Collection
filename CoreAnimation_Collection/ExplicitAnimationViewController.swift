//
//  ExplicitAnimationViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/17.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class PropertyAnimationViewController: UIViewController, CAAnimationDelegate {

    let layerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        self.view.addSubview(layerView)
        
        colorLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        self.colorLayer.backgroundColor = UIColor.blue.cgColor;
        layerView.layer.addSublayer(colorLayer)
        
        let changeColorBtn = UIButton.init(frame: CGRect(x: layerView.bounds.width/2-60,
            y: layerView.bounds.maxY - 40, width: 120, height: 31))
        changeColorBtn.addTarget(self, action: #selector(PropertyAnimationViewController.changeColor), for: .touchUpInside)
        changeColorBtn.layer.borderColor = UIColor.darkGray.cgColor
        changeColorBtn.layer.borderWidth = 1.0
        changeColorBtn.setTitle("change Color", for: UIControlState())
        changeColorBtn.setTitleColor(UIColor.blue, for: UIControlState())
        layerView.addSubview(changeColorBtn)
        
    }
    
    func changeColor() {
        //randomize the layer background color
        let red = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let randomColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        
        //create a basic animation
        let animation = CABasicAnimation();
        animation.keyPath = "backgroundColor";
        animation.toValue = randomColor.cgColor;
        animation.duration = 2.0
        animation.delegate = self;
        
        //uncomment the two lines below to solve the snap-back problem
        //animation.fromValue = self.colorLayer.backgroundColor;
        //self.colorLayer.backgroundColor = color.CGColor;
        
        //apply animation to layer
        self.colorLayer.add(animation, forKey: nil)
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
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
        bezierPath.move(to: CGPoint(x: 0, y: 150));
        bezierPath.addCurve(to: CGPoint(x: 300, y: 150),
            controlPoint1:CGPoint(x: 75, y: 0),
            controlPoint2:CGPoint(x: 225, y: 300));
        
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath;
        pathLayer.fillColor = UIColor.clear.cgColor;
        pathLayer.strokeColor = UIColor.red.cgColor;
        pathLayer.lineWidth = 3.0;
        self.view.layer.addSublayer(pathLayer);
        
        //add the ship
        shipLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64);
        shipLayer.position = CGPoint(x: 0, y: 150);
        shipLayer.contents = R.image.ship()?.cgImage
        self.view.layer.addSublayer(shipLayer)
        
        start()
    }

    func start() {
        //create the keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "position";
        animation.duration = 4.0;
        animation.path = bezierPath.cgPath;
        animation.rotationMode = "auto"
        shipLayer.add(animation, forKey:animationKey);
        
    }
    
    override func changeColor() {
        //create a keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "backgroundColor";
        animation.duration = 2.0;
        animation.values = [
        UIColor.blue.cgColor,
        UIColor.red.cgColor,
        UIColor.green.cgColor,
        UIColor.blue.cgColor
        ];
        
        //apply animation to layer
        self.colorLayer.add(animation, forKey:nil);
    }
}

class RotationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the ship
        let shipLayer = CALayer();
        shipLayer.frame = CGRect(x: 0, y: 0, width: 128, height: 128);
        shipLayer.position = CGPoint(x: 150, y: 150);
        shipLayer.contents = R.image.ship()?.cgImage
        self.view.layer.addSublayer(shipLayer);
        
        //animate the ship rotation
        let animation = CABasicAnimation();
        animation.keyPath = "transform.rotation.x";
        animation.duration = 2.0;
        animation.byValue = (Double.pi * 2);
        shipLayer.add(animation, forKey:nil);
        
    }

}

/// CAAnimationGroup：将一组动画组合起来
class AnimationGroupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a path
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 150));
        bezierPath.addCurve(to: CGPoint(x: 300, y: 150),
            controlPoint1:CGPoint(x: 75, y: 0),
            controlPoint2:CGPoint(x: 225, y: 300));
       
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath;
        pathLayer.fillColor = UIColor.clear.cgColor;
        pathLayer.strokeColor = UIColor.red.cgColor;
        pathLayer.lineWidth = 3.0;
        self.view.layer.addSublayer(pathLayer);
        
        //add a colored layer
        let colorLayer = CALayer();
        colorLayer.frame = CGRect(x: 0, y: 0, width: 64, height: 64);
        colorLayer.position = CGPoint(x: 0, y: 150);
        colorLayer.backgroundColor = UIColor.green.cgColor;
        self.view.layer.addSublayer(colorLayer);
        
        //create the keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "position";
        animation.duration = 4.0;
        animation.path = bezierPath.cgPath;
        animation.rotationMode = "auto"

        let animation2 = CABasicAnimation()
        animation2.keyPath = "backgroundColor"
        animation2.toValue = UIColor.red.cgColor
        
        //create group animation
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, animation2];
        groupAnimation.duration = 4.0;
        
        //add the animation to the color layer
        colorLayer.add(groupAnimation, forKey:nil);
        
    }
}

/// CATransition: 转场动画
class TransitionViewController: UIViewController {
    
    let imageView = UIImageView.init(image: R.image.spaceship())
    let images = [R.image.anchor()!, R.image.cone()!,
        R.image.igloo()!, R.image.spaceship()!]
    let animationKey = "transition"
    var transitionDirection = kCATransitionFromLeft;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.center = self.view.center
        self.view.addSubview(imageView)
        
        let transformSegment = UISegmentedControl.init(items: [kCATransitionFade,kCATransitionPush,kCATransitionMoveIn,kCATransitionReveal])
        transformSegment.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(TransitionViewController.switchImage(_:)), for: .valueChanged)
        self.view.addSubview(transformSegment)

        let directionSegment = UISegmentedControl.init(items: [kCATransitionFromTop,kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromRight])
        directionSegment.center = CGPoint(x: self.view.center.x, y: transformSegment.frame.minY - 50)
        directionSegment.apportionsSegmentWidthsByContent = true
        directionSegment.addTarget(self, action: #selector(TransitionViewController.switchDirection(_:)), for: .valueChanged)
        self.view.addSubview(directionSegment)
        
    }

    func switchDirection(_ segment: UISegmentedControl) {
    
        self.transitionDirection = segment.titleForSegment(at: segment.selectedSegmentIndex)!;
    }
    
    func switchImage(_ segment: UISegmentedControl) {
        
        if let animation = self.imageView.layer.animation(forKey: animationKey) {
            let transition = animation as! CATransition
            transition.type = segment.titleForSegment(at: segment.selectedSegmentIndex)!;
            transition.subtype = transitionDirection
        } else {
            //set up crossfade transition
            let transition = CATransition();
            transition.type = segment.titleForSegment(at: segment.selectedSegmentIndex)!;
            transition.subtype = transitionDirection

            //apply transition to imageview backing layer
            self.imageView.layer.add(transition, forKey:animationKey);
        }
        
        //cycle to next image
        let currentImage = self.imageView.image;
        var index = self.images.index { (indexImage) -> Bool in
            indexImage == currentImage
        }!
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
        
        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        button.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        button.setTitle("changeChildViewController", for: UIControlState())
        button.addTarget(self, action: #selector(LayerTreeTransitionController.changeAni), for: .touchUpInside)
        self.view.addSubview(button)
    }

    func changeAni() {
        change = !change
        
        //set up crossfade transition
        let transition = CATransition();
        transition.type = kCATransitionPush;
        self.view.layer.add(transition, forKey: nil)
        
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

    let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.center = self.view.center
        button.setTitle("performTransition", for: UIControlState())
        button.addTarget(self, action: #selector(CustomTransitionController.performTransition), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    
    
    func performTransition() {
        button.isEnabled = false
        
        //preserve the current view snapshot
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 0.0);
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!);
        let coverImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //insert snapshot view in front of this one
        let coverView = UIImageView.init(image: coverImage)
        coverView.frame = self.view.bounds;
        self.view.addSubview(coverView);
        
        //update the view (we'll simply randomize the layer background color)
        let red = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX))
            self.view.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0)
        
        //perform animation (anything you like)
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            //scale, rotate and fade the view
            var transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
            transform = transform.rotated(by: CGFloat(Double.pi / 2));
            coverView.transform = transform;
            coverView.alpha = 0.0;
            
            }, completion: { (finished) -> Void in
                coverView.removeFromSuperview()
                self.button.isEnabled = true

        }) 
    }
}

class StopAnimationController: CAKeyframeAnimationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stopbutton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        stopbutton.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        stopbutton.setTitle("stop", for: UIControlState())
        stopbutton.backgroundColor = UIColor.blue
        stopbutton.addTarget(self, action: #selector(StopAnimationController.stop), for: .touchUpInside)
        self.view.addSubview(stopbutton)
        
        let startbutton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 45))
        startbutton.center = CGPoint(x: self.view.center.x, y: stopbutton.frame.minY - 50)
        startbutton.setTitle("start", for: UIControlState())
        startbutton.backgroundColor = UIColor.purple
        startbutton.addTarget(self, action: #selector(CAKeyframeAnimationViewController.start), for: .touchUpInside)
        self.view.addSubview(startbutton)
    }

    func stop() {
        self.shipLayer.removeAnimation(forKey: animationKey)
    }

}





