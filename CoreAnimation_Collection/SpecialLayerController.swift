//
import GLKit
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
        
        self.shapeLayer.strokeColor = UIColor.red.cgColor
        self.shapeLayer.fillColor = UIColor.clear.cgColor
        self.shapeLayer.lineWidth = 5
        self.shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        self.shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        // add it to our view
        self.view.layer.addSublayer(self.shapeLayer)
        
        let transformSegment = UISegmentedControl(items: ["火柴人", "圆角"])
        transformSegment.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
        transformSegment.addTarget(self, action: #selector(CAShapeLayerController.changeOption(_:)), for: .valueChanged)
        self.view.addSubview(transformSegment)
        
        transformSegment.selectedSegmentIndex = 0
        self.changeOption(transformSegment)
    }
    
    @objc func changeOption(_ segment: UISegmentedControl) {
        let selectedIndex = segment.selectedSegmentIndex
        
        // create path
        var path = UIBezierPath()
        if selectedIndex == 0 {
            path.move(to: CGPoint(x: 175, y: 100))
            path.addArc(withCenter: CGPoint(x: 150, y: 100), radius: 25, startAngle: 0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
            path.move(to: CGPoint(x: 150, y: 125))
            path.addLine(to: CGPoint(x: 150, y: 175))
            path.addLine(to: CGPoint(x: 125, y: 225))
            path.move(to: CGPoint(x: 150, y: 175))
            path.addLine(to: CGPoint(x: 175, y: 225))
            path.move(to: CGPoint(x: 100, y: 150))
            path.addLine(to: CGPoint(x: 200, y: 150))
        } else {
            let rect = CGRect(x: 50, y: 70, width: 100, height: 100)
            let radii = CGSize(width: 20, height: 20)
            let corners = UIRectCorner(rawValue: 3)
            path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
        }
        
        self.shapeLayer.path = path.cgPath
    }
}

/// CATextLayer处理文本的图层
class CATextLayerController: UIViewController {
    let label = LayerLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a text layer
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 50, y: 65, width: 200, height: 200)
        self.view.layer.addSublayer(textLayer)
        
        // uncomment the line below to fix pixelation on Retina screens
        textLayer.contentsScale = UIScreen.main.scale
        
        // set text attributes
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.justified
        textLayer.isWrapped = true
        
        // choose some text
        let text = "Lorem ipsum dolor sit amet, consectetur adipiscing" + "\t elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar" + "\t leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc" + "\t elementum, libero ut porttitor dictum, diam odio congue lacus, vel" + "\t fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet" + "\t lobortis"
        
        // create attributed string
        let string = NSMutableAttributedString(string: text)
        
        // choose a font
        let font = UIFont.systemFont(ofSize: 15)
        
        // set layer font
        let fontName = font.fontName as CFString
        let fontRef = CGFont(fontName)
        textLayer.font = fontRef
        textLayer.fontSize = font.pointSize
        //        CGFontRelease(fontRef);
        
        // set text attributes
        var attribs: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black.cgColor, .font: font]
        string.setAttributes(attribs, range: NSMakeRange(6, 5))
        
        attribs = [
            .foregroundColor: UIColor.red.cgColor,
            .underlineStyle: CTUnderlineStyle.single,
            .font: font
        ]
        string.setAttributes(attribs, range: NSMakeRange(6, 5))
        
        // set layer text
        textLayer.string = string
        
        self.label.font = font
        self.label.attributedText = string.copy() as? NSAttributedString
        
        self.label.frame = textLayer.frame
        self.label.center = CGPoint(x: self.label.center.x, y: self.view.frame.maxY - 115)
        self.view.addSubview(self.label)
    }
}

/// CATransformLayer用于构造一个层级的3D结构
class CATransformLayerViewController: UIViewController {
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.containerView.center = self.view.center
        
        // set up the perspective transform
        var pt = CATransform3DIdentity
        pt.m34 = -1.0 / 500.0
        self.containerView.layer.sublayerTransform = pt
        
        // set up the transform for cube 1 and add it
        var c1t = CATransform3DIdentity
        c1t = CATransform3DTranslate(c1t, -100, 0, 0)
        let cube1 = self.cubeWithTransform(c1t)
        self.containerView.layer.addSublayer(cube1)
        
        // set up the transform for cube 2 and add it
        var c2t = CATransform3DIdentity
        c2t = CATransform3DTranslate(c2t, 100, 0, 0)
        c2t = CATransform3DRotate(c2t, -CGFloat(Double.pi / 4), 1, 0, 0)
        c2t = CATransform3DRotate(c2t, -CGFloat(Double.pi / 4), 0, 1, 0)
        let cube2 = self.cubeWithTransform(c2t)
        self.containerView.layer.addSublayer(cube2)
    }
    
    func faceWithTransform(_ transform: CATransform3D) -> CALayer {
        // create cube face layer
        let face = CALayer()
        face.frame = CGRect(x: -50, y: -50, width: 100, height: 100)
        
        // apply a random color
        let red = CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX))
        let green = CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX))
        let blue = CGFloat(CGFloat(arc4random()) / CGFloat(RAND_MAX))
        face.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor
        
        // apply the transform and return
        face.transform = transform
        return face
    }
    
    func cubeWithTransform(_ transform: CATransform3D) -> CALayer {
        // create cube layer
        let cube = CATransformLayer()
        
        // add cube face 1
        var ct = CATransform3DMakeTranslation(0, 0, 50)
        cube.addSublayer(self.faceWithTransform(ct))
        
        // add cube face 2
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, CGFloat(Double.pi / 2), 0, 1, 0)
        cube.addSublayer(self.faceWithTransform(ct))
        
        // add cube face 3
        ct = CATransform3DMakeTranslation(0, -50, 0)
        ct = CATransform3DRotate(ct, CGFloat(Double.pi / 2), 1, 0, 0)
        cube.addSublayer(self.faceWithTransform(ct))
        
        // add cube face 4
        ct = CATransform3DMakeTranslation(0, 50, 0)
        ct = CATransform3DRotate(ct, -CGFloat(Double.pi / 2), 1, 0, 0)
        cube.addSublayer(self.faceWithTransform(ct))
        
        // add cube face 5
        ct = CATransform3DMakeTranslation(-50, 0, 0)
        ct = CATransform3DRotate(ct, -CGFloat(Double.pi / 2), 0, 1, 0)
        cube.addSublayer(self.faceWithTransform(ct))
        
        // add cube face 6
        ct = CATransform3DMakeTranslation(0, 0, -50)
        ct = CATransform3DRotate(ct, CGFloat(Double.pi), 0, 1, 0)
        cube.addSublayer(self.faceWithTransform(ct))
        
        // center the cube layer within the container
        let containerSize = self.containerView.bounds.size
        cube.position = CGPoint(x: containerSize.width / 2.0,
                                y: containerSize.height / 2.0)
        
        // apply the transform and return
        cube.transform = transform
        return cube
    }
}

/// CAGradientLayer渐变图层
class CAGradientLayerViewController: UIViewController {
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    var gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.containerView.center = self.view.center
        
        self.gradientLayer = self.catercornerGradient()
        self.containerView.layer.addSublayer(self.gradientLayer)
    }
    
    /**
     获取对角线渐变图层
     */
    func catercornerGradient() -> CAGradientLayer {
        // create gradient layer and add it to our container view
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.containerView.bounds
        
        // set gradient colors
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor,
                                UIColor.blue.cgColor]
        
        // starPoint endPoint代表渐变范围和方向
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        // locations表示的是颜色在Layer坐标系相对位置处要开始进行渐变颜色了.
        // 默认是nil,整个图层平均渐变例如[0,0.5,1]
        gradientLayer.locations = [0.25, 0.5, 0.75]
        
        return gradientLayer
    }
}

/// CAReplicatorLayer: 高效生产相似的图层
class CAReplicatorLayerViewController: UIViewController {
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.containerView)
        self.containerView.center = self.view.center
        self.containerView.layer.addSublayer(self.replicatorLayer())
        
        let reflectionView = self.reflectionView()
        self.view.addSubview(reflectionView)
    }
    
    /**
     获取自定义的反射视图
     */
    func reflectionView() -> ReflectionView {
        let reflectionView = ReflectionView(frame:
            CGRect(x: (self.view.frame.width - 160) / 2, y: 100, width: 160, height: 160))
        reflectionView.reflectionScale = 1.0
        let imageView = UIImageView(image: R.image.anchor())
        imageView.frame = reflectionView.bounds
        reflectionView.addSubview(imageView)
        
        return reflectionView
    }
    
    func replicatorLayer() -> CAReplicatorLayer {
        // create a replicator layer and add it to our view
        let replicator = CAReplicatorLayer()
        replicator.frame = self.containerView.bounds
        
        // configure the replicator
        replicator.instanceCount = 10
        
        // apply a transform for each instance
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 100, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi) / 5.0, 0, 0, 1)
        transform = CATransform3DTranslate(transform, 0, -100, 0)
        replicator.instanceTransform = transform
        
        // apply a color shift for each instance
        replicator.instanceBlueOffset = -0.1
        replicator.instanceGreenOffset = -0.1
        
        // create a sublayer and place it inside the replicator
        let layer = CALayer()
        layer.frame = CGRect(x: (replicator.frame.width - 50.0) / 2.0, y: 100.0, width: 50.0, height: 50.0)
        layer.backgroundColor = UIColor.white.cgColor
        replicator.addSublayer(layer)
        
        return replicator
    }
}

/// CAScrollLayer显示部分图层
class CAScrollLayerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scrollView = ScrollView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        scrollView.center = self.view.center
        let imageView = UIImageView(image: R.image.bigSnowman())
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        scrollView.addSubview(imageView)
        
        self.view.addSubview(scrollView)
    }
}

/// CATiledLayer: 将大图分解成小图,按需载入
class CATiledLayerViewController: UIViewController, CALayerDelegate {
    let scrollView = UIScrollView()
    let tileLayer = FastTileLayer()
    
    class FastTileLayer: CATiledLayer {
        override class func fadeDuration() -> CFTimeInterval {
            return 0.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = self.view.bounds
        self.view.addSubview(self.scrollView)
        
        // add the tiled layer
        let scale = UIScreen.main.scale
        self.tileLayer.frame = CGRect(x: 0, y: 0, width: 2048 / scale, height: 2048 / scale)
        self.tileLayer.contentsScale = scale
        self.tileLayer.delegate = self
        self.scrollView.layer.addSublayer(self.tileLayer)
        
        // configure the scroll view
        self.scrollView.contentSize = self.tileLayer.frame.size
        
        // draw layer
        self.tileLayer.setNeedsDisplay()
    }
    
    deinit {
        print(self.description + " deinit")
        self.tileLayer.delegate = nil
    }
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        DispatchQueue.global(qos: .default).sync(execute: { () -> Void in
            
            // draw a thick red circle
            // determine tile coordinate
            let tiledLayer = layer as! CATiledLayer
            let bounds = ctx.boundingBoxOfClipPath
            let scale = UIScreen.main.scale
            let x = Int(bounds.origin.x / tiledLayer.tileSize.width * scale)
            let y = Int(bounds.origin.y / tiledLayer.tileSize.height * scale)
            // load tile image
            let imageName = NSString(format: "Snowman_%02i_%02i", x, y)
            let tileImage = UIImage(named: imageName as String)
            print("imageName" + (imageName as String))
            DispatchQueue.main.sync(execute: { () -> Void in
                // draw tile
                UIGraphicsPushContext(ctx)
                tileImage?.draw(in: bounds)
                UIGraphicsPopContext()
            })
        })
    }
}

/// CAEmitterLayer: 展示粒子效果的图层
class CAEmitterLayerViewController: UIViewController {
    let emitter = CAEmitterLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        DispatchQueue.main.async { () -> Void in
            
            self.emitter.frame = self.view.bounds
            _ = self.setCAEmitterLayer(self.emitter)
            self.view.layer.addSublayer(self.emitter)
            
            let renderModeSegment = UISegmentedControl(items: [CAEmitterLayerRenderMode.additive, CAEmitterLayerRenderMode.backToFront, CAEmitterLayerRenderMode.oldestLast, CAEmitterLayerRenderMode.oldestFirst, CAEmitterLayerRenderMode.unordered])
            renderModeSegment.center = CGPoint(x: self.view.center.x, y: self.view.frame.maxY - 50)
            renderModeSegment.addTarget(self, action: #selector(CAEmitterLayerViewController.changeRenderMode(_:)), for: .valueChanged)
            self.view.addSubview(renderModeSegment)
            
            let preservesDepthSegment = UISegmentedControl(items: ["preservesDepthSegment on", "preservesDepth off"])
            preservesDepthSegment.center = CGPoint(x: self.view.center.x, y: renderModeSegment.frame.maxY - 50)
            preservesDepthSegment.addTarget(self, action: #selector(CAEmitterLayerViewController.changePreservesDepth(_:)), for: .valueChanged)
            self.view.addSubview(preservesDepthSegment)
        }
    }
    
    @objc func changePreservesDepth(_ segment: UISegmentedControl) {
        let title = segment.titleForSegment(at: segment.selectedSegmentIndex)!
        if (title.hasSuffix("on")) {
            self.emitter.preservesDepth = true
        } else {
            self.emitter.preservesDepth = false
        }
    }
    
    @objc func changeRenderMode(_ segment: UISegmentedControl) {
        let RenderMode = segment.titleForSegment(at: segment.selectedSegmentIndex)
        self.emitter.renderMode = CAEmitterLayerRenderMode(rawValue: RenderMode!)
    }
    
    func setCAEmitterLayer(_ emitter: CAEmitterLayer) -> CAEmitterLayer {
        // configure emitter
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        //        emitter.renderMode = kCAEmitterLayerUnordered
        //        emitter.preservesDepth = true
        emitter.emitterPosition = CGPoint(x: emitter.frame.size.width / 2.0,
                                          y: emitter.frame.size.height / 2.0)
        
        // create a particle template
        let cell = CAEmitterCell()
        cell.contents = R.image.spark()!.cgImage
        cell.birthRate = 150
        cell.lifetime = 5.0
        // orange color
        cell.color = UIColor(red: 1, green: 0.5, blue: 0.2, alpha: 1.0).cgColor
        cell.alphaSpeed = -0.4
        cell.velocity = 50
        cell.velocityRange = 50
        cell.emissionRange = CGFloat(Double.pi * 2.0)
        
        // add particle template to emitter
        emitter.emitterCells = [cell]
        
        return emitter
    }
    
    deinit {
        print(self.description + " deinit")
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
}

/**
 *  CAEAGLLayer: 使用OpenGL高效绘制自定义图层
 */
class CAEAGLLayerViewController: UIViewController {
    let glView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let glContext = EAGLContext(api: .openGLES2)
    let glLayer = CAEAGLLayer()
    var framebuffer: GLuint = 0
    var colorRenderbuffer: GLuint = 0
    var framebufferWidth: GLsizei = 0
    var framebufferHeight: GLsizei = 0
    let effect = GLKBaseEffect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.glView.center = self.view.center
        self.view.addSubview(self.glView)
        // set up context
        EAGLContext.setCurrent(self.glContext)
        
        // set up layer
        self.glLayer.frame = self.glView.bounds
        self.glView.layer.addSublayer(self.glLayer)
        self.glLayer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking: false,
                                           kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8]
        
        // set up buffers
        self.setUpBuffers()
        
        // draw frame
        self.drawFrame()
    }
    
    func setUpBuffers() {
        // set up frame buffer
        glGenFramebuffers(1, &self.framebuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), self.framebuffer)
        
        // set up color render buffer
        glGenRenderbuffers(1, &self.colorRenderbuffer)
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), self.colorRenderbuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), self.colorRenderbuffer)
        self.glContext?.renderbufferStorage(Int(GL_RENDERBUFFER), from: self.glLayer)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_WIDTH), &self.framebufferWidth)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GLenum(GL_RENDERBUFFER_HEIGHT), &self.framebufferHeight)
        
        // check success
        if (glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)) != GLenum(GL_FRAMEBUFFER_COMPLETE)) {
            print("Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GLenum(GL_FRAMEBUFFER)))
        }
    }
    
    func drawFrame() {
        // bind framebuffer & set viewport
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), self.framebuffer)
        glViewport(0, 0, self.framebufferWidth, self.framebufferHeight)
        
        // bind shader program
        self.effect.prepareToDraw()
        
        // clear the screen
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glClearColor(0.0, 0.0, 0.0, 1.0)
        
        // set up vertices
        let vertices: [GLfloat] = [
            -0.5, -0.5, -1.0,
            0.0, 0.5, -1.0,
            0.5, -0.5, -1.0
        ]
        
        // set up colors
        let colors: [GLfloat] = [
            0.0, 0.0, 1.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            1.0, 0.0, 0.0, 1.0
        ]
        
        // draw triangle
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.position.rawValue))
        glEnableVertexAttribArray(GLuint(GLKVertexAttrib.color.rawValue))
        glVertexAttribPointer(GLuint(GLKVertexAttrib.position.rawValue), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, vertices)
        glVertexAttribPointer(GLuint(GLKVertexAttrib.color.rawValue), 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, colors)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
        
        // present render buffer
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), self.colorRenderbuffer)
        self.glContext?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }
    
    func tearDownBuffers() {
        if (self.framebuffer != 0) {
            // delete framebuffer
            glDeleteFramebuffers(1, &self.framebuffer)
            self.framebuffer = 0
        }
        
        if (self.colorRenderbuffer != 0) {
            // delete color render buffer
            glDeleteRenderbuffers(1, &self.colorRenderbuffer)
            self.colorRenderbuffer = 0
        }
    }
    
    deinit {
        print(self.description + " deinit")
    }
}

import AVFoundation
/// AVPlayerLayer: 专门显示视屏的图层
class AVPlayerLayerViewController: UIViewController {
    let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.center = self.view.center
        self.view.addSubview(self.containerView)
        
        // get video URL
        let URL = R.file.shipMp4()
        
        // create player and player layer
        let player = AVPlayer(url: URL! as URL)
        let playerLayer = AVPlayerLayer()
        playerLayer.player = player
        
        // set player layer frame and attach it to our view
        playerLayer.frame = self.containerView.bounds
        self.containerView.layer.addSublayer(playerLayer)
        
        // transform layer
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 500.0
        transform = CATransform3DRotate(transform, -CGFloat(Double.pi / 4), 1, 1, 0)
        playerLayer.transform = transform
        
        // add rounded corners and border
        playerLayer.masksToBounds = true
        playerLayer.cornerRadius = 20.0
        playerLayer.borderColor = UIColor.red.cgColor
        playerLayer.borderWidth = 5.0
        
        // play the video
        playerLayer.player?.play()
    }
}

/// 给HelloGLKitViewController提供桥接
class GLKViewDemoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let childGLKitViewVC = HelloGLKitViewController()
        self.addChild(childGLKitViewVC)
        childGLKitViewVC.view.frame = self.view.bounds
        self.view.addSubview(childGLKitViewVC.view)
    }
}
