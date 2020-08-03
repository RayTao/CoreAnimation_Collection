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
    let contentsGravitys:[CALayerContentsGravity] = [.center,.top,.bottom,.left,.right,.topLeft,.topRight,.bottomLeft,.bottomRight,.resize,.resizeAspect,.resizeAspectFill]
    var segmentContentsArray: [UISegmentedControl]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = CALayerContentsGravity.center
        // Do any additional setup after loading the view.
        //create sublayer
        layerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.white
        self.view.addSubview(layerView)
        
        for il in 0 ..< contentsGravitys.count/4
        {
            let i = il*4
            
            var array = [contentsGravitys[i],contentsGravitys[i+1],contentsGravitys[i+2]]
            if i+3 < contentsGravitys.count {
                array.append(contentsGravitys[i+3])
            }
            let segmentContents = UISegmentedControl.init(items: array)
            segmentContents.apportionsSegmentWidthsByContent = true
            segmentContents.center = CGPoint(x: layerView.center.x, y: layerView.center.y + 150.0 + CGFloat(40 * i / 4))
            segmentContents.addTarget(self, action: #selector(ContentsGravitysViewController.contentsGravitysChange(_:)), for: .valueChanged)
            self.view.addSubview(segmentContents)
        }
        
        if let image = R.image.snowman() {
            //add it directly to our view's layer
            self.layerView.layer.contents = image.cgImage;
        }
    }

    @objc func contentsGravitysChange(_ segment: UISegmentedControl) {
        let contentsGravity = segment.titleForSegment(at: segment.selectedSegmentIndex)
        self.layerView.layer.contentsGravity = CALayerContentsGravity(rawValue: contentsGravity!);

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
        layerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.white
        self.view.addSubview(layerView)
        
        if let image = R.image.snowman() {
            //add it directly to our view's layer
            self.layerView.layer.contents = image.cgImage;
        }
        
        //center the image
        self.layerView.layer.contentsGravity = CALayerContentsGravity.center;

        maskSegmentContents.apportionsSegmentWidthsByContent = true
        maskSegmentContents.center = CGPoint(x: layerView.center.x, y: layerView.center.y + 150.0)
        maskSegmentContents.addTarget(self, action: #selector(ContentsGravitysViewController.contentsGravitysChange(_:)), for: .valueChanged)
        self.view.addSubview(maskSegmentContents)
        
        scaleSegmentContents.apportionsSegmentWidthsByContent = true
        scaleSegmentContents.center = CGPoint(x: layerView.center.x, y: layerView.center.y + 150.0 + 40)
        scaleSegmentContents.addTarget(self, action: #selector(ContentsGravitysViewController.contentsGravitysChange(_:)), for: .valueChanged)
        self.view.addSubview(scaleSegmentContents)

    }
    
    func contentsGravitysChange(_ segment: UISegmentedControl) {
        let image = R.image.snowman()
        let onOrOff = segment.titleForSegment(at: segment.selectedSegmentIndex)!
        if (onOrOff.hasSuffix("On")) {
            if segment == self.maskSegmentContents {
                self.layerView.layer.masksToBounds = true;
            } else {
                self.layerView.layer.contentsScale = image!.scale;
                
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

    fileprivate let coneView = UIView.init(frame: CGRect(x: 10, y: 10 + 60, width: 128, height: 128))
    fileprivate let shipView = UIView.init(frame: CGRect(x: 148, y: 10 + 60, width: 128, height: 128))
    fileprivate let iglooVIew = UIView.init(frame: CGRect(x: 10, y: 148 + 60, width: 128, height: 128))
    fileprivate let anchorView = UIView.init(frame: CGRect(x: 148, y: 148 + 60, width: 128, height: 128))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(coneView)
        self.view.addSubview(shipView)
        self.view.addSubview(iglooVIew)
        self.view.addSubview(anchorView)
        for index in 0..<self.view.subviews.count {
            let subview = self.view.subviews[index]
            subview.backgroundColor = UIColor.white
        }
        
        if let image = R.image.sprites() {
            self.addSpriteImage(image, contentRect: CGRect(x: 0, y: 0, width: 0.5, height: 0.5),toLayer: iglooVIew.layer)
            self.addSpriteImage(image, contentRect: CGRect(x: 0.5, y: 0, width: 0.5, height: 0.5),toLayer: coneView.layer)
            self.addSpriteImage(image, contentRect: CGRect(x: 0, y: 0.5, width: 0.5, height: 0.5),toLayer: anchorView.layer)
            self.addSpriteImage(image, contentRect: CGRect(x: 0.5, y: 0.5, width: 0.5, height: 0.5),toLayer: shipView.layer)
        }
    }

    func addSpriteImage(_ image: UIImage, contentRect rect: CGRect,toLayer layer: CALayer) {
        //set image
        layer.contents = image.cgImage
        //scale contents to fit
        layer.contentsGravity = .resizeAspect;
        //set contentsRect
        layer.contentsRect = rect;
    }
}

class ContentsCenterViewController: UIViewController {
    
    fileprivate let button1 = UIView.init(frame: CGRect(x: 68.5, y: 70, width: 100, height: 243))
    fileprivate let button2 = UIView.init(frame: CGRect(x: 68.5, y: 320, width: 243, height: 100))
    fileprivate let button3 = UIView.init(frame: CGRect(x: 200, y: 70, width: 100, height: 243))
    fileprivate let button4 = UIView.init(frame: CGRect(x: 68.5, y: 440, width: 243, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        self.view.addSubview(button4)
        
        if let image = R.image.button() {
            addStretchableImage(image, contentCenter: CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5), toLayer: button1.layer)
            addStretchableImage(image, contentCenter: CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5), toLayer: button2.layer)
            addStretchableImage(image, contentCenter: CGRect(x: 0, y: 0, width: 1, height: 1), toLayer: button3.layer)
            addStretchableImage(image, contentCenter: CGRect(x: 0, y: 0, width: 1, height: 1), toLayer: button4.layer)
        }
    }
    
    func addStretchableImage(_ image: UIImage, contentCenter rect: CGRect,toLayer layer: CALayer) {
        //set image
        layer.contents = image.cgImage
        //set contentsCenter
        layer.contentsCenter = rect;
    }
    
}

class DrawingViewController: UIViewController, CALayerDelegate {
    var layerView: UIView = UIView()
    let blueLayer = CALayer()
    //MARK: blueLayer.delegate必须在deinit设为nil（apple的weak不起作用）不然会崩溃
    deinit {
        print("DrawingViewController deinit")
        blueLayer.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layerView.center = self.view.center
        layerView.backgroundColor = UIColor.white
        self.view.addSubview(layerView)
        
        blueLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        blueLayer.backgroundColor = UIColor.blue.cgColor
        
        //set controller as layer delegate
        blueLayer.delegate = self;
        //ensure that layer backing image uses correct scale
        blueLayer.contentsScale = UIScreen.main.scale;
        //add layer to our view
        self.layerView.layer.addSublayer(blueLayer)
        //force layer to redraw
        blueLayer.display()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    /**
     <#Description#>
     
     - parameter layer: <#layer description#>
     - parameter ctx:   <#ctx description#>
     */
    func draw(_ layer: CALayer, in ctx: CGContext) {
        //draw a thick red circle
        ctx.setLineWidth(10.0);
        ctx.setStrokeColor(UIColor.red.cgColor);
        ctx.strokeEllipse(in: layer.bounds);
    }

}







