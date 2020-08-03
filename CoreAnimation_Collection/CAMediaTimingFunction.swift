//
//  CAMediaTimingFunction.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/15.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CAMediaTimingFunctionController: UIViewController {
    
    let colorView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    let colorLayer = CALayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorLayer.frame = colorView.frame;
        self.colorLayer.position = CGPoint(x: self.view.bounds.width / 2,
            y: self.view.bounds.height / 2);
        self.colorLayer.backgroundColor = UIColor.blue.cgColor;
        self.view.layer.addSublayer(self.colorLayer);
        
        colorView.backgroundColor = UIColor.red
        colorView.center = self.view.center
        self.view.addSubview(colorView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //get the touch point
        let point = touches.first!.location(in: self.view);
        
        //otherwise (slowly) move the layer to new position
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0);
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut))
        self.colorLayer.position = point;
        CATransaction.commit();
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.colorView.center = point;

            }, completion: nil)
    }

}

class KeyFrameMediaTimingViewController: UIViewController {
    
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
        changeColorBtn.addTarget(self, action: #selector(KeyFrameMediaTimingViewController.changeColor), for: .touchUpInside)
        changeColorBtn.layer.borderColor = UIColor.darkGray.cgColor
        changeColorBtn.layer.borderWidth = 1.0
        changeColorBtn.setTitle("change Color", for: .normal)
        changeColorBtn.setTitleColor(UIColor.blue, for: .normal)
        layerView.addSubview(changeColorBtn)
        
    }
    
    @objc func changeColor() {
        //create a keyframe animation
        let animation = CAKeyframeAnimation();
        animation.keyPath = "backgroundColor";
        animation.duration = 4.5;
        animation.values = [
            UIColor.blue.cgColor,
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ];
        
        //add timing function
        let fn = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
        animation.timingFunctions = [fn, fn, fn];
        
        //apply animation to layer
        self.colorLayer.add(animation, forKey:nil);
    }
}

/// 用贝塞尔曲线画出MediaTimingFunction曲线图
class BezierMediaTimingFunctionController: UIViewController {

    let layerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        self.view.addSubview(layerView)
     
        let transformSegment = UISegmentedControl.init(items: [CAMediaTimingFunctionName.linear,CAMediaTimingFunctionName.easeOut,CAMediaTimingFunctionName.easeIn,CAMediaTimingFunctionName.easeInEaseOut])
        transformSegment.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(BezierMediaTimingFunctionController.switchFunction(_:)), for: .valueChanged)
        self.view.addSubview(transformSegment)
        
    }
    
    @objc func switchFunction(_ segment: UISegmentedControl) {
        if layerView.layer.sublayers?.count > 0 {
            for sublayer in layerView.layer.sublayers! {
                sublayer.removeFromSuperlayer()
            }
        }
        
        let title = segment.titleForSegment(at: segment.selectedSegmentIndex)!
        BezierMediaTimingFunctionController.drawBezier(CAMediaTimingFunction.init(name: CAMediaTimingFunctionName(rawValue: title)), inView: layerView)
        
    }
    
    
    class func drawBezier(_ function: CAMediaTimingFunction, inView: UIView) {

        //get control points
        var controlPoint1: [Float] = [0,0]
        var controlPoint2: [Float] = [0,0]
        function.getControlPoint(at: 1, values: &controlPoint1)
        function.getControlPoint(at: 2, values: &controlPoint2)
        
        //create curve
        let path = UIBezierPath.init()
        path.move(to: CGPoint.zero)
        path.addCurve(to: CGPoint(x: 1.0, y: 1.0), controlPoint1: CGPoint(x: CGFloat( controlPoint1[0]), y: CGFloat(controlPoint1[1])), controlPoint2: CGPoint(x: CGFloat( controlPoint2[0]), y: CGFloat(controlPoint2[1])))
        
        //scale the path up to a reasonable size for display
        let width = min(inView.frame.width, inView.frame.height)
        path.apply(CGAffineTransform(scaleX: width, y: width))
        
        //create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.red.cgColor;
        shapeLayer.fillColor = UIColor.clear.cgColor;
        shapeLayer.lineWidth = 4.0;
        shapeLayer.path = path.cgPath;
        inView.layer.addSublayer(shapeLayer);
        
        //flip geometry so that 0,0 is in the bottom-left
        inView.layer.isGeometryFlipped = true;
    }
    
} 

class CustomMediaTimingFunctionController: AnchorPointViewController, CAAnimationDelegate {

    override func setAngle(_ angle: CGFloat, handView: UIView) {
        
        let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        //create transform animation
        let animation = CABasicAnimation();
        animation.keyPath = "transform";
        animation.fromValue = handView.layer.presentation()?.value(forKey: "transform");
        animation.toValue = NSValue(caTransform3D: transform);
        animation.duration = 0.5;
        animation.delegate = self;
        animation.timingFunction = CAMediaTimingFunction.init(controlPoints: 1, 0, 0.75, 1);
        
        //apply animation
        handView.layer.transform = transform;
        handView.layer.add(animation, forKey:nil);
    }

}

class BallViewController: UIViewController, CAAnimationDelegate {

    let ballView = UIImageView.init(image: R.image.ball())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(ballView)
        animate()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.animate()
    }
    
    func getInterpolate(_ from: CGFloat, to: CGFloat, time: CGFloat) -> CGFloat {
        return (to - from) * time + from;
    }
    
    func bounceEaseOut(_ t: Double) -> Double {
    
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
    
    func interpolate(_ fromeValue: CGPoint,toValue: CGPoint,time: Double) -> NSValue {
    
        var resultValue = NSValue.init(cgPoint: CGPoint(x: 0,y: 0))
        let result = CGPoint(x: getInterpolate(fromeValue.x, to: toValue.x, time: CGFloat(time)),
             y: getInterpolate(fromeValue.y, to: toValue.y, time: CGFloat(time)));
        resultValue = NSValue.init(cgPoint: result)
        
        return resultValue
    }
    
    func animate() {
        //reset ball to top of screen
        self.ballView.center = CGPoint(x: 150, y: 32);
        
        //set up animation parameters
        let fromValue = CGPoint(x: 150, y: 32);
        let toValue = CGPoint(x: 150, y: 268)
        let duration = 1.0;
        
        //generate keyframes
        let numFrames = duration * 60;
        let frames = NSMutableArray();
        for i in 0 ..< Int(numFrames) {
            var time = 1.0/numFrames * Double(i);
            //apply easing
            time = bounceEaseOut(time);
            
            frames.add(interpolate(fromValue, toValue: toValue, time: time))
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
        self.ballView.layer.position = CGPoint(x: 150, y: 268);
        self.ballView.layer.add(animation, forKey:nil);
    
    }
}


