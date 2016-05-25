//
//  TransformController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/6.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit
import GLKit

class AffineTransformController: UIViewController {

    let layerView = UIImageView.init(image: R.image.snowman)
    let transformSegment = UISegmentedControl.init(items: ["rotation45","combineTransform","MakeShear"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSize = layerView.image?.size
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.frame = CGRectMake(50, 50, (imageSize?.width)!, (imageSize?.height)!)
        self.view.addSubview(layerView)
        
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(AffineTransformController.changeTransform(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)
        
        
        transformSegment.selectedSegmentIndex = 0
        changeTransform(transformSegment)
    }
    
    func changeTransform(segment: UISegmentedControl) {
        let selecedIndex = segment.selectedSegmentIndex
        let title = segment.titleForSegmentAtIndex(selecedIndex)!
        var transform = CGAffineTransformIdentity;

        if (title.hasPrefix("rotation45")) {
            transform = rotation45Transform()
        } else if (title.hasPrefix("combineTransform")){
            transform = combineTransform()
        } else if (title.hasPrefix("CGAffineTrans")){
            transform = CGAffineTransformMakeShear(1.0, y: 0.0);
        }

        //apply transform to layer
        self.layerView.layer.setAffineTransform(transform);
    }
    
    func rotation45Transform() -> CGAffineTransform {
        //rotate the layer 45 degrees
       return CGAffineTransformMakeRotation(CGFloat(M_PI_4))
    }
    
    func combineTransform() -> CGAffineTransform {
        var transform = CGAffineTransformIdentity;
        
        //scale by 50%
        transform = CGAffineTransformScale(transform, 0.5, 0.5);
        
        //rotate by 30 degrees
        transform = CGAffineTransformRotate(transform, CGFloat( M_PI / 180.0 * 30.0));
        
        //translate by 200 points
        transform = CGAffineTransformTranslate(transform, 200, 0);
        return transform
    }
    
    func CGAffineTransformMakeShear(x: CGFloat,y: CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransformIdentity;
        transform.c = -x;
        transform.b = y;
        return transform;
    }
    
}

/// 设置M34实现透视投影
class CATransform3DM34Controller: UIViewController {

    let layerView = UIImageView.init(image: R.image.snowman)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSize = layerView.image?.size
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.frame = CGRectMake(50, 90, (imageSize?.width)!, (imageSize?.height)!)
        self.view.addSubview(layerView)
        
        let transformSegment = UISegmentedControl.init(items: ["透视off","透视on"])
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(CATransform3DM34Controller.changeSwitch(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)

    }
    
    func changeSwitch(segment: UISegmentedControl) {
        
        var transform = CATransform3DIdentity;
        if (segment.selectedSegmentIndex != 0) {
            transform.m34 = -1.0 / 500.0
        }
        //rotate by 45 degrees along the Y axis
        transform = CATransform3DRotate(transform, CGFloat(M_PI_4), 0, 1, 0);
        self.layerView.layer.transform = transform;
    
    
    }
}

/// 设置sublayertransform对子视图、图层做变换，保证所有图层公用一个灭点
class SublayerTransformController: UIViewController {
    
    let containerView = UIView()
    let layerView1 = UIImageView.init(frame: CGRectMake(20, 65, 140, 140))
    let layerView2 = UIImageView.init(frame: CGRectMake(165, 65, 140, 140))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.frame = self.view.bounds
        layerView1.image = R.image.snowman
        layerView2.image = R.image.snowman
        layerView1.backgroundColor = UIColor.whiteColor()
        layerView2.backgroundColor = layerView1.backgroundColor
        layerView1.center.y = containerView.center.y
        layerView2.center.y = containerView.center.y
        containerView.addSubview(layerView1)
        containerView.addSubview(layerView2)
        self.view.addSubview(self.containerView)
        
        
        //apply perspective transform to container
        var perspective = CATransform3DIdentity;
        perspective.m34 = -1.0 / 500.0;
        self.containerView.layer.sublayerTransform = perspective;
        
        //rotate layerView1 by 45 degrees along the Y axis
        let transform1 = CATransform3DMakeRotation(CGFloat(M_PI_4), 0, 1, 0);
        self.layerView1.layer.transform = transform1;
        
        //rotate layerView2 by 45 degrees along the Y axis
        let transform2 = CATransform3DMakeRotation(-CGFloat(M_PI_4), 0, 1, 0);
        self.layerView2.layer.transform = transform2;
    }
}

/// DoubleSided 决定视图是否需要绘制背面
class DoubleSidedController: UIViewController {
    
    let layerView = UIImageView.init(image: R.image.snowman)
    let transformSegment = UISegmentedControl.init(items: ["DoubleSided off","DoubleSided on"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSize = layerView.image?.size
        layerView.backgroundColor = UIColor.whiteColor()
        layerView.frame = CGRectMake(50, 90, (imageSize?.width)!, (imageSize?.height)!)
        
        self.view.addSubview(layerView)
        
        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(CATransform3DM34Controller.changeSwitch(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)
        
    }

    func changeSwitch(segment: UISegmentedControl) {
        
        var transform = CATransform3DIdentity;
        if (segment.selectedSegmentIndex != 0) {
            self.layerView.layer.doubleSided = true
        } else {
            self.layerView.layer.doubleSided = false
        }
        //rotate by 45 degrees along the Y axis
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0);
        self.layerView.layer.transform = transform;
    }
}

/// 通过旋转展现扁平化特性
class flattenController: UIViewController {
    
    let outerView = UIView.init(frame: CGRectMake(0, 0, 200, 200))
    let innerView = UIView.init(frame: CGRectMake(50, 50, 100, 100))

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.addSubview(outerView)
        outerView.addSubview(innerView)
        
        outerView.backgroundColor = UIColor.whiteColor()
        innerView.backgroundColor = UIColor.redColor()
        outerView.center = self.view.center
        
        let transformSegment = UISegmentedControl.init(items: ["RotateZ ","RotateY","RotateX","Normal"])

        transformSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(CATransform3DM34Controller.changeSwitch(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(transformSegment)
        
    }
    
    func changeSwitch(segment: UISegmentedControl) {
        let selectedIndex = segment.selectedSegmentIndex
        var outer = CATransform3DIdentity;
        var inner = CATransform3DIdentity;
        
        if selectedIndex == 0 {
            outer = CATransform3DRotate(outer,CGFloat(M_PI_4), 0, 0, 1);
            inner = CATransform3DRotate(inner,-CGFloat(M_PI_4), 0, 0, 1);
        } else if selectedIndex == 1 {
            outer.m34 = -1.0 / 500.0;
            inner.m34 = -1.0 / 500.0;
            outer = CATransform3DRotate(outer,CGFloat(M_PI_4), 0, 1, 0);
            inner = CATransform3DRotate(inner,-CGFloat(M_PI_4), 0, 1, 0);
            
        } else if selectedIndex == 2 {
            outer.m34 = -1.0 / 500.0;
            inner.m34 = -1.0 / 500.0;
            outer = CATransform3DRotate(outer,CGFloat(M_PI_4), 1, 0, 0);
            inner = CATransform3DRotate(inner,-CGFloat(M_PI_4), 1, 0, 0);
         
        }

        self.outerView.layer.transform = outer;
        self.innerView.layer.transform = inner;
    }
}

/// 通过3D布局和计算光源阴影展现固体特征
class Object3DController: UIViewController {
    
    let containerView = UIView.init(frame: CGRectMake(0, 0, 300, 300))
    var faces: [UIView] = []
    let switching = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        switching.center = CGPoint(x: self.view.center.x,y: self.view.frame.maxY - 50)
        switching.addTarget(self, action: #selector(Object3DController.rotation(_:)), forControlEvents: .ValueChanged)

        self.view.addSubview(switching)
        self.view.addSubview(containerView)
        containerView.center = self.view.center
    
        for i in 0...5 {
            let cubeFace = UIView.init(frame: CGRectMake(0, 0, 200, 200))
            cubeFace.backgroundColor = UIColor.whiteColor()
            let label = UIButton.init(frame: CGRectMake(50, 50, 100, 100))
            label.setTitle(String(i + 1), forState: .Normal)
            let color = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            let color1 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            let color2 = CGFloat(CGFloat(random())/CGFloat(RAND_MAX))
            label.setTitleColor(UIColor(red: color, green: color1, blue: color2, alpha: 1), forState: .Normal)
            label.titleLabel?.font = UIFont.systemFontOfSize(22.0)
            if i == 2 {
                cubeFace.userInteractionEnabled = true
                label.layer.borderColor = UIColor.purpleColor().CGColor
                label.layer.borderWidth = 1.0
                label.addTarget(self, action: #selector(Object3DController.changeBackgroundcolor(_:)), forControlEvents: .TouchUpInside)
            } else {
                cubeFace.userInteractionEnabled = false
            }
            
            cubeFace.addSubview(label)
            faces.append(cubeFace)
        }
        
        
        //add cube face 1
        var transform = CATransform3DMakeTranslation(0, 0, 100);
        addFace(0, transform: transform)
        
        //add cube face 2
        transform = CATransform3DMakeTranslation(100, 0, 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0);
        addFace(1, transform: transform)
        
        //add cube face 3
        //move this code after the setup for face no. 6 to enable button
        transform = CATransform3DMakeTranslation(0, -100, 0);
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 1, 0, 0);
        addFace(2, transform: transform)
        
        //add cube face 4
        transform = CATransform3DMakeTranslation(0, 100, 0);
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 1, 0, 0);
        addFace(3, transform: transform)
        
        //add cube face 5
        transform = CATransform3DMakeTranslation(-100, 0, 0);
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 0, 1, 0);
        addFace(4, transform: transform)
        
        //add cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -100);
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0);
        addFace(5, transform: transform)
    }
    
    func changeBackgroundcolor(changedButton: UIButton) {
        changedButton.backgroundColor = UIColor.blueColor()
    }
    
    func addFace(index: Int,transform: CATransform3D) {
        self.containerView.addSubview(self.faces[index])
        
        let containerSize = self.containerView.bounds.size;
        self.faces[index].center = CGPointMake(containerSize.width / 2.0,
            containerSize.height / 2.0);
        
        self.faces[index].layer.transform = transform
        //apply lighting
        self.applyLightingToFace(self.faces[index].layer)
    }
    
    func matrixFrom3DTransformation(transform: CATransform3D) -> GLKMatrix4 {
    
        let matrix = GLKMatrix4Make(Float(transform.m11), Float(transform.m12), Float(transform.m13), Float(transform.m14),
        Float(transform.m21), Float(transform.m22), Float(transform.m23), Float(transform.m24),
        Float(transform.m31), Float(transform.m32), Float(transform.m33), Float(transform.m34),
        Float(transform.m41), Float(transform.m42), Float(transform.m43), Float(transform.m44));
        
        return matrix;
    }
    
    func applyLightingToFace(face: CALayer) {
        //add lighting layer
        let layer = CALayer()
        layer.frame = face.bounds;
        face.addSublayer(layer);
        
        //convert face transform to matrix
        //(GLKMatrix4 has the same structure as CATransform3D)
        let transform = face.transform;
        let matrix4 = matrixFrom3DTransformation(transform)
        let matrix3 = GLKMatrix4GetMatrix3(matrix4);
        
        //get face normal
        var normal = GLKVector3Make(0, 0, 1);
        normal = GLKMatrix3MultiplyVector3(matrix3, normal);
        normal = GLKVector3Normalize(normal);
        
            
        //get dot product with light direction
        let light = GLKVector3Normalize(GLKVector3Make( 0, 1, -0.5));
        let dotProduct = GLKVector3DotProduct(light, normal);
        
        //set lighting layer opacity
        let shadow: CGFloat = 1.0 + CGFloat(dotProduct) - 0.5;
        let color = UIColor.init(white: 0, alpha: shadow)
        layer.backgroundColor = color.CGColor;
    }
    
    func rotation(switcher: UISwitch) {
        //set up the container sublayer transform
        var perspective = CATransform3DIdentity;
        if switcher.on {
            perspective.m34 = -1.0 / 500.0;
            perspective = CATransform3DRotate(perspective, -CGFloat(M_PI_4), 1, 0, 0);
            perspective = CATransform3DRotate(perspective, -CGFloat(M_PI_4), 0, 1, 0);
        }
        self.containerView.layer.sublayerTransform = perspective;
    }
    
}
