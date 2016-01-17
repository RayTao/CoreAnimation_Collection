//
//  SpecialLayerController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/1/7.
//  Copyright © 2016年 ray. All rights reserved.
//
import UIKit
import GLKit

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
        
        let reflectionView = self.reflectionView()
        self.view.addSubview(reflectionView)
        
    }

    /**
     获取自定义的反射视图
    */
    func reflectionView() -> ReflectionView
    {
        let reflectionView = ReflectionView.init(frame:
            CGRectMake((self.view.frame.width - 160) / 2, 100, 160, 160))
        reflectionView.reflectionScale = 1.0
        let imageView = UIImageView.init(image: R.image.anchor)
        imageView.frame = reflectionView.bounds
        reflectionView.addSubview(imageView)
        
        return reflectionView
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
        layer.frame = CGRectMake((replicator.frame.width - 50.0) / 2.0, 100.0, 50.0, 50.0);
        layer.backgroundColor = UIColor.whiteColor().CGColor;
        replicator.addSublayer(layer);
        
        return replicator
    }
}

/// CAScrollLayer显示部分图层
class CAScrollLayerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = ScrollView.init(frame: CGRectMake(0, 0, 200, 200))
        scrollView.center = self.view.center
        let imageView = UIImageView.init(image: R.image.bigSnowman)
        imageView.frame = CGRectMake(0, 0, 400, 400)
        scrollView.addSubview(imageView)
        
        self.view.addSubview(scrollView)
    }
}

/// CATiledLayer: 将大图分解成小图,按需载入
class CATiledLayerViewController: UIViewController {

    let scrollView = UIScrollView()
    let tileLayer = CATiledLayer();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
    
        //add the tiled layer
        let scale = UIScreen.mainScreen().scale
        tileLayer.frame = CGRectMake(0, 0, 2048 / scale, 2048 / scale);
        tileLayer.contentsScale = scale
        tileLayer.delegate = self;
        self.scrollView.layer.addSublayer(tileLayer);
        
        //configure the scroll view
        self.scrollView.contentSize = tileLayer.frame.size;
        
        //draw layer
        tileLayer.setNeedsDisplay();
    }
    
    deinit
    {
        print(self.description + " deinit");
        self.tileLayer.delegate = nil
    }
    
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            //draw a thick red circle
            //determine tile coordinate
            let tiledLayer = layer as! CATiledLayer
            let bounds = CGContextGetClipBoundingBox(ctx);
            let scale = UIScreen.mainScreen().scale
            let x = Int(bounds.origin.x / tiledLayer.tileSize.width * scale);
            let y = Int(bounds.origin.y / tiledLayer.tileSize.height * scale);
            //load tile image
            let imageName = NSString.init(format: "Snowman_%02i_%02i", x, y);
            let tileImage = UIImage.init(named: imageName as String);
            print("imageName" + (imageName as String))
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                //draw tile
                UIGraphicsPushContext(ctx);
                tileImage?.drawInRect(bounds);
                UIGraphicsPopContext();
            })
        })
    }
}

/// CAEmitterLayer: 展示粒子效果的图层
class CAEmitterLayerViewController: UIViewController {
    let emitter = CAEmitterLayer();

    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.LandscapeRight.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.emitter.frame = self.view.bounds;
            self.setCAEmitterLayer(self.emitter)
            self.view.layer.addSublayer(self.emitter);
            
            let renderModeSegment = UISegmentedControl.init(items: [kCAEmitterLayerAdditive,kCAEmitterLayerBackToFront,kCAEmitterLayerOldestLast,kCAEmitterLayerOldestFirst,kCAEmitterLayerUnordered])
            renderModeSegment.center = CGPointMake(self.view.center.x, self.view.frame.maxY - 50)
            renderModeSegment.addTarget(self, action: "changeRenderMode:", forControlEvents: .ValueChanged)
            self.view.addSubview(renderModeSegment)
            
            let preservesDepthSegment = UISegmentedControl.init(items: ["preservesDepthSegment on","preservesDepth off"])
            preservesDepthSegment.center = CGPointMake(self.view.center.x, renderModeSegment.frame.maxY - 50)
            preservesDepthSegment.addTarget(self, action: "changePreservesDepth:", forControlEvents: .ValueChanged)
            self.view.addSubview(preservesDepthSegment)
        }
    }
    
    func changePreservesDepth(segment: UISegmentedControl) {
        let title = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)!
        if (title.hasSuffix("on")) {
            emitter.preservesDepth = true
        } else {
            emitter.preservesDepth = false
        }
    }
    
    func changeRenderMode(segment: UISegmentedControl) {
        let RenderMode = segment.titleForSegmentAtIndex(segment.selectedSegmentIndex)
        self.emitter.renderMode = RenderMode!
    }
    
    func setCAEmitterLayer(emitter: CAEmitterLayer) -> CAEmitterLayer {
        //configure emitter
        emitter.renderMode = kCAEmitterLayerAdditive;
        //        emitter.renderMode = kCAEmitterLayerUnordered
        //        emitter.preservesDepth = true
        emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0,
            emitter.frame.size.height / 2.0);
        
        //create a particle template
        let cell = CAEmitterCell();
        cell.contents = R.image.spark!.CGImage;
        cell.birthRate = 150;
        cell.lifetime = 5.0;
        //orange color
        cell.color = UIColor.init(red: 1, green: 0.5, blue: 0.2, alpha: 1.0).CGColor;
        cell.alphaSpeed = -0.4;
        cell.velocity = 50;
        cell.velocityRange = 50;
        cell.emissionRange = CGFloat(M_PI * 2.0);
        
        //add particle template to emitter
        emitter.emitterCells = [cell];
        
        return emitter
    }
    
    deinit
    {
        print(self.description + " deinit");
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
}

/**
*  CAEAGLLayer: 使用OpenGL高效绘制自定义图层
*/
class CAEAGLLayerViewController: UIViewController {
    let glView = UIView.init(frame: CGRectMake(0, 0, 200, 200))
    let glContext = EAGLContext.init(API: .OpenGLES2)
    let glLayer = CAEAGLLayer()
    var framebuffer: GLuint = 0
    var colorRenderbuffer: GLuint = 0
    var framebufferWidth: GLsizei = 0
    var framebufferHeight: GLsizei = 0
    let effect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        glView.center = self.view.center
        self.view.addSubview(glView)
        //set up context
        EAGLContext.setCurrentContext(self.glContext);
        
        //set up layer
        self.glLayer.frame = self.glView.bounds;
        self.glView.layer.addSublayer(self.glLayer);
        self.glLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
            kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8];
        
        //set up buffers
        self.setUpBuffers();
        
        //draw frame
        self.drawFrame();
    }

    func setUpBuffers() {
        //set up frame buffer
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer);
        
        //set up color render buffer
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer);
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorRenderbuffer);
        self.glContext.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: self.glLayer)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &framebufferWidth);
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &framebufferHeight);
        
        //check success
        if (glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GLenum(GL_FRAMEBUFFER_COMPLETE))
        {
            print("Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)));
        }
    }
    
    func drawFrame() {
        //bind framebuffer & set viewport
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), framebuffer);
        glViewport(0, 0, framebufferWidth, framebufferHeight);
        
        //bind shader program
        self.effect.prepareToDraw();
        
        //clear the screen
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT));
        glClearColor(0.0, 0.0, 0.0, 1.0);
        
        //set up vertices
        let vertices: [GLfloat] = [
            -0.5, -0.5, -1.0,
            0.0, 0.5, -1.0,
            0.5, -0.5, -1.0,]
        
        //set up colors
        let colors: [GLfloat] = [
            0.0, 0.0, 1.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0,]
        
        //draw triangle
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Position.rawValue));
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.Color.rawValue));
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Position.rawValue), 3, GLenum(GL_FLOAT),GLboolean(GL_FALSE), 0, vertices);
        glVertexAttribPointer(GLuint(GLKVertexAttrib.Color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, colors);
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3);
        
        //present render buffer
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorRenderbuffer);
        self.glContext.presentRenderbuffer(Int(GL_RENDERBUFFER))

    }

    func tearDownBuffers() {
        if (framebuffer != 0)
        {
            //delete framebuffer
            glDeleteFramebuffers(1, &framebuffer);
            framebuffer = 0;
        }
        
        if (colorRenderbuffer != 0)
        {
            //delete color render buffer
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
    }
    
    deinit {
        print(self.description + " deinit");

    }
}

import AVFoundation
/// AVPlayerLayer: 专门显示视屏的图层
class AVPlayerLayerViewController: UIViewController {
    let containerView = UIView.init(frame: CGRectMake(0, 0, 200, 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.center = self.view.center
        self.view.addSubview(containerView)
        
        //get video URL
        let URL = R.file.shipMp4
        
        //create player and player layer
        let player = AVPlayer.init(URL: URL!)
        let playerLayer = AVPlayerLayer()
        playerLayer.player = player
        
        //set player layer frame and attach it to our view
        playerLayer.frame = self.containerView.bounds;
        self.containerView.layer.addSublayer(playerLayer);
        
        //transform layer
        var transform = CATransform3DIdentity;
        transform.m34 = -1.0 / 500.0;
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_4), 1, 1, 0);
        playerLayer.transform = transform;

        
        //add rounded corners and border
        playerLayer.masksToBounds = true;
        playerLayer.cornerRadius = 20.0;
        playerLayer.borderColor = UIColor.redColor().CGColor;
        playerLayer.borderWidth = 5.0;
        
        //play the video
        playerLayer.player?.play()
    }
    
}

/// 给HelloGLKitViewController提供桥接
class GLKViewDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childGLKitViewVC = HelloGLKitViewController()
        self.addChildViewController(childGLKitViewVC)
        childGLKitViewVC.view.frame = self.view.bounds
        self.view.addSubview(childGLKitViewVC.view)
    }
}
