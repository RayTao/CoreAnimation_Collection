//
//  SpecialLayerController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/7.
//  Copyright © 2016年 ray. All rights reserved.
//
import UIKit

/// CAShapeLayer处理不规则形状的图层
class CAShapeLayerController: UIViewController {

    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shapeLayer.strokeColor = UIColor.redColor().CGColor;
        shapeLayer.fillColor = UIColor.clearColor().CGColor;
        shapeLayer.lineWidth = 5;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineCap = kCALineCapRound;
        
        //add it to our view
        self.view.layer.addSublayer(shapeLayer);
        
        let transformSegment = UISegmentedControl.init(items: ["火柴人","圆角"])
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: "changeOption:", forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)
        
        transformSegment.selectedSegmentIndex = 0
        changeOption(transformSegment)
    }
    
    func changeOption(segment: UISegmentedControl) {
        let selectedIndex = segment.selectedSegmentIndex
        
        //create path
        var path = UIBezierPath();
        if selectedIndex == 0 {
            path.moveToPoint(CGPointMake(175, 100))
            path.addArcWithCenter(CGPointMake(150, 100) , radius: 25, startAngle: 0, endAngle:CGFloat(2.0 * M_PI), clockwise: true);
            path.moveToPoint(CGPointMake(150, 125))
            path.addLineToPoint(CGPointMake(150, 175))
            path.addLineToPoint(CGPointMake(125, 225))
            path.moveToPoint(CGPointMake(150, 175))
            path.addLineToPoint(CGPointMake(175, 225))
            path.moveToPoint(CGPointMake(100, 150))
            path.addLineToPoint(CGPointMake(200, 150))
        } else {
            let rect = CGRectMake(50, 70, 100, 100)
            let radii = CGSizeMake(20, 20)
            let corners = UIRectCorner.init(rawValue: 3)
            path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        }
        
        shapeLayer.path = path.CGPath
    }
}

/// CATextLayer处理文本的图层
class CATextLayerController: UIViewController {

    let label = LayerLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create a text layer
        let textLayer = CATextLayer();
        textLayer.frame = CGRectMake(50, 65, 200, 200);
        self.view.layer.addSublayer(textLayer)
        
        //uncomment the line below to fix pixelation on Retina screens
        textLayer.contentsScale = UIScreen.mainScreen().scale;
        
        //set text attributes
        textLayer.foregroundColor = UIColor.blackColor().CGColor;
        textLayer.alignmentMode = kCAAlignmentJustified;
        textLayer.wrapped = true;
        
        //choose some text
        let text = "Lorem ipsum dolor sit amet, consectetur adipiscing" + "\t elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar" + "\t leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc" + "\t elementum, libero ut porttitor dictum, diam odio congue lacus, vel" + "\t fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet" + "\t lobortis"
        
        //create attributed string
        let string = NSMutableAttributedString.init(string: text)
        
        //choose a font
        let font = UIFont.systemFontOfSize(15);
        
        //set layer font
        let fontName = font.fontName;
        let fontRef = CGFontCreateWithFontName(fontName);
        textLayer.font = fontRef;
        textLayer.fontSize = font.pointSize;
        //        CGFontRelease(fontRef);
        
        //set text attributes
        var attribs = [String(kCTForegroundColorAttributeName):
            UIColor.blackColor().CGColor,
            String(kCTFontAttributeName): font];
        string.setAttributes(attribs as? [String : AnyObject], range: NSMakeRange(6,5))
        
        attribs = [
            String(kCTForegroundColorAttributeName): UIColor.redColor().CGColor,
            String(kCTUnderlineStyleAttributeName): NSNumber(int: CTUnderlineStyle.Single.rawValue),
            String(kCTFontAttributeName): font
        ];
        string.setAttributes(attribs as? [String : AnyObject], range: NSMakeRange(6,5))

        
        //set layer text
        textLayer.string = string;
        
        label.font = font
        label.attributedText = string.copy() as? NSAttributedString
        
        label.frame = textLayer.frame
        label.center = CGPointMake(label.center.x, self.view.frame.maxY - 115)
        self.view.addSubview(label)
    }
}

/// CATransformLayer用于构造一个层级的3D结构
class CATransformLayerViewController: UIViewController {

    let containerView = UIView.init(frame: CGRectMake(0, 0, 300, 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(containerView)
        containerView.center = self.view.center
        
        //set up the perspective transform
        var pt = CATransform3DIdentity;
        pt.m34 = -1.0 / 500.0;
        self.containerView.layer.sublayerTransform = pt;
        
        //set up the transform for cube 1 and add it
        var c1t = CATransform3DIdentity;
        c1t = CATransform3DTranslate(c1t, -100, 0, 0);
        let cube1 = self.cubeWithTransform(c1t);
        self.containerView.layer.addSublayer(cube1);
        
        //set up the transform for cube 2 and add it
        var c2t = CATransform3DIdentity;
        c2t = CATransform3DTranslate(c2t, 100, 0, 0);
        c2t = CATransform3DRotate(c2t, -CGFloat(M_PI_4), 1, 0, 0);
        c2t = CATransform3DRotate(c2t, -CGFloat(M_PI_4), 0, 1, 0);
        let cube2 = self.cubeWithTransform(c2t);
        self.containerView.layer.addSublayer(cube2);
    }

    func faceWithTransform(transform: CATransform3D) -> CALayer
    {
        //create cube face layer
        let face = CALayer();
        face.frame = CGRectMake(-50, -50, 100, 100);
        
        //apply a random color
        let red = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
        face.backgroundColor = UIColor.init(red: red, green: green, blue: blue, alpha: 1.0).CGColor;
        
        //apply the transform and return
        face.transform = transform;
        return face;
    }
    
    func cubeWithTransform(transform: CATransform3D) -> CALayer
    {
        //create cube layer
        let cube = CATransformLayer();
        
        //add cube face 1
        var ct = CATransform3DMakeTranslation(0, 0, 50);
        cube.addSublayer(self.faceWithTransform(ct));
        
        //add cube face 2
        ct = CATransform3DMakeTranslation(50, 0, 0);
        ct = CATransform3DRotate(ct, CGFloat(M_PI_2), 0, 1, 0);
        cube.addSublayer(self.faceWithTransform(ct));
        
        //add cube face 3
        ct = CATransform3DMakeTranslation(0, -50, 0);
        ct = CATransform3DRotate(ct, CGFloat(M_PI_2), 1, 0, 0);
        cube.addSublayer(self.faceWithTransform(ct));
        
        //add cube face 4
        ct = CATransform3DMakeTranslation(0, 50, 0);
        ct = CATransform3DRotate(ct, -CGFloat(M_PI_2), 1, 0, 0);
        cube.addSublayer(self.faceWithTransform(ct));
        
        //add cube face 5
        ct = CATransform3DMakeTranslation(-50, 0, 0);
        ct = CATransform3DRotate(ct, -CGFloat(M_PI_2), 0, 1, 0);
        cube.addSublayer(self.faceWithTransform(ct));
        
        //add cube face 6
        ct = CATransform3DMakeTranslation(0, 0, -50);
        ct = CATransform3DRotate(ct, CGFloat(M_PI), 0, 1, 0);
        cube.addSublayer(self.faceWithTransform(ct));
        
        //center the cube layer within the container
        let containerSize = self.containerView.bounds.size;
        cube.position = CGPointMake(containerSize.width / 2.0,
        containerSize.height / 2.0);
        
        //apply the transform and return
        cube.transform = transform;
        return cube;
    }

}

/// CAGradientLayer渐变图层
class CAGradientLayerViewController: UIViewController {
    let containerView = UIView.init(frame: CGRectMake(0, 0, 300, 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(containerView)
        containerView.center = self.view.center
        
        self.containerView.layer.addSublayer(catercornerGradient());
//        self.containerView.layer.addSublayer(locationsGradient());

    
    }
    
    /**
     获取对角线渐变图层
     */
    func catercornerGradient() -> CAGradientLayer
    {
        //create gradient layer and add it to our container view
        let gradientLayer = CAGradientLayer();
        gradientLayer.frame = self.containerView.bounds;
        
        //set gradient colors
        gradientLayer.colors = [UIColor.redColor().CGColor,
        UIColor.blueColor().CGColor];
        
        //set gradient start and end points
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        
        return gradientLayer;
    }
    
    /**
     多重渐变图层,定位颜色区域
     */
    func locationsGradient() -> CAGradientLayer
    {
        let gradientLayer = catercornerGradient()
        //set gradient colors
        gradientLayer.colors = [UIColor.redColor().CGColor,UIColor.yellowColor().CGColor,
            UIColor.blueColor().CGColor];

        
        //set locations
        gradientLayer.locations = [0.0, 0.25, 0.5];
        
        return gradientLayer
    }
}

/// CAReplicatorLayer: 高效生产相似的图层
class CAReplicatorLayerViewController: UIViewController {
    
    let containerView = UIView.init(frame: CGRectMake(0, 0, 300, 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(containerView)
        containerView.center = self.view.center
        
        self.containerView.layer.addSublayer(replicatorLayer());
        
        
    }

    func replicatorLayer() -> CAReplicatorLayer
    {
        //create a replicator layer and add it to our view
        let replicator = CAReplicatorLayer();
        replicator.frame = self.containerView.bounds;
        
        //configure the replicator
        replicator.instanceCount = 10;
        
        //apply a transform for each instance
        var transform = CATransform3DIdentity;
        transform = CATransform3DTranslate(transform, 0, 100, 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI) / 5.0, 0, 0, 1);
        transform = CATransform3DTranslate(transform, 0, -100, 0);
        replicator.instanceTransform = transform;
        
        //apply a color shift for each instance
        replicator.instanceBlueOffset = -0.1;
        replicator.instanceGreenOffset = -0.1;
        
        //create a sublayer and place it inside the replicator
        let layer = CALayer();
        layer.frame = CGRectMake(100.0, 100.0, 50.0, 50.0);
        layer.backgroundColor = UIColor.whiteColor().CGColor;
        replicator.addSublayer(layer);
        
        return replicator
    }


}


