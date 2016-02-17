//
//  CAMediaTimingFunction.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/15.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class CAMediaTimingFunctionController: UIViewController {
    
    let colorView = UIView.init(frame: CGRectMake(0, 0, 100, 100))
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorLayer.frame = colorView.frame;
        self.colorLayer.position = CGPointMake(self.view.bounds.width / 2,
            self.view.bounds.height / 2);
        self.colorLayer.backgroundColor = UIColor.blueColor().CGColor;
        self.view.layer.addSublayer(self.colorLayer);
        
        colorView.backgroundColor = UIColor.redColor()
        colorView.center = self.view.center
        self.view.addSubview(colorView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //get the touch point
        let point = touches.first!.locationInView(self.view);
        
        //otherwise (slowly) move the layer to new position
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0);
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut))
        self.colorLayer.position = point;
        CATransaction.commit();
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                self.colorView.center = point;

            }, completion: nil)
    }

}

class KeyFrameMediaTimingViewController: UIViewController {
    
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
        //create a keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "backgroundColor";
        animation.duration = 4.5;
        animation.values = [
            UIColor.blueColor().CGColor,
            UIColor.redColor().CGColor,
            UIColor.greenColor().CGColor,
            UIColor.blueColor().CGColor
        ];
        
        //add timing function
        let fn = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        animation.timingFunctions = [fn, fn, fn];
        
        //apply animation to layer
        self.colorLayer.addAnimation(animation, forKey:nil);
    }
}

/// 用贝塞尔曲线画出MediaTimingFunction曲线图
class BezierMediaTimingFunctionController: UIViewController {

    let layerView = UIView.init(frame: CGRectMake(0, 0, 220, 220))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.center = self.view.center
        self.view.addSubview(layerView)
     
        let transformSegment = UISegmentedControl.init(items: [kCAMediaTimingFunctionLinear,kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseInEaseOut])
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: "switchFunction:", forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)
        
    }
    
    func switchFunction(segment: UISegmentedControl) {
        if layerView.layer.sublayers?.count > 0 {
            for sublayer in layerView.layer.sublayers! {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let title = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)!
        BezierMediaTimingFunctionController.drawBezier(CAMediaTimingFunction.init(name: title), inView: layerView)
        
    }
    
    
    class func drawBezier(function: CAMediaTimingFunction, inView: UIView) {

        //get control points
        var controlPoint1: [Float] = [0,0]
        var controlPoint2: [Float] = [0,0]
        function.getControlPointAtIndex(1, values: &controlPoint1)
        function.getControlPointAtIndex(2, values: &controlPoint2)
        
        //create curve
        let path = UIBezierPath.init()
        path.moveToPoint(CGPointZero)
        path.addCurveToPoint(CGPointMake(1.0, 1.0), controlPoint1: CGPointMake(CGFloat( controlPoint1[0]), CGFloat(controlPoint1[1])), controlPoint2: CGPointMake(CGFloat( controlPoint2[0]), CGFloat(controlPoint2[1])))
        
        //scale the path up to a reasonable size for display
        let width = min(inView.frame.width, inView.frame.height)
        path.applyTransform(CGAffineTransformMakeScale(width, width))
        
        //create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.redColor().CGColor;
        shapeLayer.fillColor = UIColor.clearColor().CGColor;
        shapeLayer.lineWidth = 4.0;
        shapeLayer.path = path.CGPath;
        inView.layer.addSublayer(shapeLayer);
        
        //flip geometry so that 0,0 is in the bottom-left
        inView.layer.geometryFlipped = true;
    }
    
} 

class CustomMediaTimingFunctionController: AnchorPointViewController {

    override func setAngle(angle: CGFloat, handView: UIView) {
        
        let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        //create transform animation
        let animation = CABasicAnimation();
        animation.keyPath = "transform";
        animation.fromValue = handView.layer.presentationLayer()?.valueForKey("transform");
        animation.toValue = NSValue(CATransform3D: transform);
        animation.duration = 0.5;
        animation.delegate = self;
        animation.timingFunction = CAMediaTimingFunction.init(controlPoints: 1, 0, 0.75, 1);
        
        //apply animation
        handView.layer.transform = transform;
        handView.layer.addAnimation(animation, forKey:nil);
    }

}

class BallViewController: UIViewController {

    let ballView = UIImageView.init(image: R.image.ball)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(ballView)
        animate()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.animate()
    }
    
    func getInterpolate(from: CGFloat, to: CGFloat, time: CGFloat) -> CGFloat {
        return (to - from) * time + from;
    }
    
    func bounceEaseOut(t: Double) -> Double {
    
        if (t < 4/11.0)
        {
            return (121 * t * t)/16.0;
        }
        else if (t < 8/11.0)
        {
            return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
        }
        else if (t < 9/10.0)
        {
            return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
        }
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
    
    func interpolate(fromeValue: CGPoint,toValue: CGPoint,time: Double) -> NSValue {
    
        var resultValue = NSValue.init(CGPoint: CGPointMake(0,0))
        let result = CGPointMake(getInterpolate(fromeValue.x, to: toValue.x, time: CGFloat(time)),
             getInterpolate(fromeValue.y, to: toValue.y, time: CGFloat(time)));
        resultValue = NSValue.init(CGPoint: result)
        
        return resultValue
    }
    
    func animate() {
        //reset ball to top of screen
        self.ballView.center = CGPointMake(150, 32);
        
        //set up animation parameters
        let fromValue = CGPointMake(150, 32);
        let toValue = CGPointMake(150, 268)
        let duration = 1.0;
        
        //generate keyframes
        let numFrames = duration * 60;
        let frames = NSMutableArray();
        for (var i = 0.0; i < numFrames; i++) {
            var time = 1.0/numFrames * i;
            //apply easing
            time = bounceEaseOut(time);
            
            frames.addObject(interpolate(fromValue, toValue: toValue, time: time))
        }
        
        //create keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position";
        animation.duration = 1.0;
        animation.delegate = self;
//        animation.values = [
//        NSValue.init(CGPoint: CGPointMake(150,32)),
//        NSValue.init(CGPoint: CGPointMake(150, 268)),
//        NSValue.init(CGPoint: CGPointMake(150, 140)),
//        NSValue.init(CGPoint: CGPointMake(150, 268)),
//        NSValue.init(CGPoint: CGPointMake(150, 220)),
//        NSValue.init(CGPoint: CGPointMake(150, 268)),
//        NSValue.init(CGPoint: CGPointMake(150, 250)),
//        NSValue.init(CGPoint: CGPointMake(150, 268))
//        ];
//        animation.timingFunctions = [
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseIn),
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseOut),
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseIn),
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseOut),
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseIn),
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseOut),
//        CAMediaTimingFunction.init(name:kCAMediaTimingFunctionEaseIn)
//        ];
//        animation.keyTimes = [0.0, 0.3, 0.5, 0.7, 0.8, 0.9, 0.95, 1.0];
        
        animation.values = frames as [AnyObject];
        
        //apply animation
        self.ballView.layer.position = CGPointMake(150, 268);
        self.ballView.layer.addAnimation(animation, forKey:nil);
    
    }
}


