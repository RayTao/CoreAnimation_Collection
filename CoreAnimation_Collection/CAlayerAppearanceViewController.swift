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
        layerView1.backgroundColor = UIColor.white
        layerView1.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(layerView1)
        
        self.layerView2.layer.cornerRadius = 20.0;
        layerView2.backgroundColor = UIColor.red
        layerView2.frame = CGRect(x: -25, y: -25, width: 70, height: 70)
        self.layerView1.addSubview(layerView2)
        
        //enable clipping on the second layer
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC * 2)) / Double(NSEC_PER_SEC)) { () -> Void in
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
        layerView1.backgroundColor = UIColor.white
        layerView1.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        //边框随着图层边界变化，而不是图层内容
        layerView1.layer.borderWidth = 5.0
        self.view.addSubview(layerView1)
        
        self.layerView2.layer.cornerRadius = 20.0;
        layerView2.backgroundColor = UIColor.red
        layerView2.frame = CGRect(x: -25, y: -25, width: 70, height: 70)
        self.layerView1.addSubview(layerView2)
        
        //enable clipping on the second layer
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC * 2)) / Double(NSEC_PER_SEC)) { () -> Void in
            self.layerView1.layer.masksToBounds = true;
        }
    }
}

class MaskLayerController: UIViewController {
    let msakLayer = CALayer()
    let imageLayer = CALayer()
    let imageView = UIImageView.init(image: R.image.igloo())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageSize = R.image.cone()!.size
        msakLayer.contents = R.image.cone()?.cgImage
        msakLayer.frame = CGRect(x: 15, y: 50, width: imageSize.width, height: imageSize.height)
        self.view.layer.addSublayer(msakLayer)
        
        imageSize = R.image.igloo()!.size
        imageLayer.contents = R.image.igloo()?.cgImage
        imageLayer.frame = CGRect(x: msakLayer.frame.maxX + 5, y: 50, width: imageSize.width, height: imageSize.height)
        self.view.layer.addSublayer(imageLayer)
        
        imageView.frame = imageLayer.frame
        self.view.addSubview(imageView)
        let newMaskLayer = CALayer()
        newMaskLayer.contents = msakLayer.contents
        newMaskLayer.frame = imageView.bounds
        imageView.layer.mask = newMaskLayer
        imageView.center = CGPoint(x: self.view.center.x, y: imageView.center.y + imageSize.height + 10)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white

    }
}

class MiniAndMagnificationFilterController: UIViewController {
    
    var digitViews: [UIView] = [];
    var timer: Timer? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let digitsImage = R.image.digits()
        for index in 0...5 {
            let subview = UIView.init(frame: CGRect(x: 5.0 + CGFloat(index * 50), y: 70, width: 50, height: 100))
            
            //set contents
            subview.layer.contents = digitsImage?.cgImage;
            subview.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.1, height: 1.0);
            subview.layer.contentsGravity = kCAGravityResizeAspect;
            
            //use nearest-neighbor scaling
            view.layer.magnificationFilter = kCAFilterNearest;
            
            self.view.addSubview(subview)
            digitViews.append(subview)
        };
        
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(MiniAndMagnificationFilterController.changeFilter(_:)), for: .valueChanged)
        switcher.center = CGPoint(x: self.view.center.x, y: digitViews[0].frame.maxY + 20)
        self.view.addSubview(switcher)
        
    }
    
    deinit {
        print(self.description + " deinit");
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //start timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MiniAndMagnificationFilterController.tick), userInfo: nil, repeats: true)
        tick()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func setDigit(_ digit: Int,view: UIView) {
        view.layer.contentsRect = CGRect(x: CGFloat(digit) * 0.1, y: 0, width: 0.1, height: 1.0)
    }
    
    func changeFilter(_ switcher: UISwitch) {
        for index in 0...5 {
            //use nearest-neighbor scaling
            if switcher.isOn {
                digitViews[index].layer.magnificationFilter = kCAFilterNearest;
            } else {
                digitViews[index].layer.magnificationFilter = kCAFilterLinear;
            }
        };
        
       
    }
    
    func tick() {
        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = (calendar as NSCalendar?)?.components([.hour,.minute,.second], from: Date())
        
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
        
        containerView.backgroundColor = UIColor.clear
        containerView.alpha = 1.0

        containerView.frame = self.view.bounds
        self.view.addSubview(containerView)
        
        let button1 = helloButton()
        button1.center = CGPoint(x: 50, y: 150);
        containerView.addSubview(button1)
        
        let button2 = helloButton()
        button2.tag = 100
        button2.center = CGPoint(x: 250, y: 150);
        button2.alpha = 0.5;
//        let helloLabel = button2.viewWithTag(111)!
//        helloLabel.alpha = 0.5
        
        containerView.addSubview(button2)
        
      
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(GroupOpacityController.changeGroupOpacity(_:)), for: .valueChanged)
        switcher.center = CGPoint(x: self.view.center.x, y: button2.frame.maxY + 20)
        self.view.addSubview(switcher)
    }
    
    func changeGroupOpacity(_ switcher:UISwitch) {
        let button2: UIView = containerView.viewWithTag(100)!
        if switcher.isOn {
            //enable rasterization for the translucent button
            
            button2.layer.shouldRasterize = true;
            button2.layer.rasterizationScale = UIScreen.main.scale;
        } else {
            //enable rasterization for the translucent button
            button2.layer.shouldRasterize = true;
            button2.layer.rasterizationScale = UIScreen.main.scale;
        }
    }
    
    func helloButton() -> UIView {
        
        //create button
        var frame = CGRect(x: 0, y: 0, width: 150, height: 50);
        let button = UIView.init(frame: frame)
        button.backgroundColor = UIColor.white;
        button.layer.cornerRadius = 10;
        
        //add label
        frame = CGRect(x: 20, y: 10, width: 110, height: 30);
        let helloLabel = UILabel.init(frame: frame);
        helloLabel.text = "Hello World";
        helloLabel.backgroundColor = UIColor.white;
        helloLabel.textAlignment = .center;
        helloLabel.tag = 111;
        button.addSubview(helloLabel)

        return button
    }
    
}


class ShadowViewController: UIViewController {
    let layerView1 = UIView()
    let layerView2 = UIView()
    let shadowView = UIView()
    let cone1 = UIImageView.init(image: R.image.cone())
    let cone2 = UIImageView.init(image: R.image.cone())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //为了不受裁剪影响，添加额外的阴影视图
        //add same shadow to shadowView (not layerView1)
        self.shadowView.layer.shadowOpacity = 0.5;
        self.shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0);
        self.shadowView.layer.shadowRadius = 5.0;
        self.view.addSubview(shadowView)
        
        //set the corner radius on our layers
        self.layerView1.layer.cornerRadius = 20.0;
        layerView1.backgroundColor = UIColor.white
        layerView1.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        shadowView.frame = layerView1.bounds
        //边框随着图层边界变化，而不是图层内容
        layerView1.layer.borderWidth = 5.0
        shadowView.addSubview(layerView1)
        
        self.layerView2.layer.cornerRadius = 20.0;
        layerView2.backgroundColor = UIColor.red
        layerView2.frame = CGRect(x: -25, y: -25, width: 70, height: 70)
        layerView1.addSubview(layerView2)
        
        let switcher = UISwitch()
        switcher.addTarget(self, action: #selector(ShadowViewController.changeAnchorPoint(_:)), for: .valueChanged)
        switcher.center = CGPoint(x: self.view.center.x, y: shadowView.frame.maxY + 20)
        self.view.addSubview(switcher)
        
        cone1.center = CGPoint(x: self.view.center.x - 100, y: self.view.center.y)
        cone2.isHidden = true
        cone1.isHidden = true
        cone2.center = CGPoint(x: self.view.center.x + 100, y: self.view.center.y)
        //enable layer shadows
        cone1.layer.shadowOpacity = 0.5;
        cone2.layer.shadowOpacity = 0.5;
        //create a square shadow
        let squarePath = CGMutablePath();
        squarePath.addRect(self.cone1.bounds)
        cone1.layer.shadowPath = squarePath;
//        CGPathRelease(squarePath);
        
        //create a circular shadow
        let circlePath = CGMutablePath();
        circlePath.addEllipse(in: self.cone2.bounds)
        self.cone2.layer.shadowPath = circlePath;
//        CGPathRelease(circlePath);
        
        self.view.addSubview(cone1)
        self.view.addSubview(cone2)
        
        //enable clipping on the second layer
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC * 2)) / Double(NSEC_PER_SEC)) { () -> Void in
            self.layerView1.layer.masksToBounds = true;
        }
    }
    
    func changeAnchorPoint(_ switcher: UISwitch) {
        if (switcher.isOn) {
            cone2.isHidden = false
            cone1.isHidden = false
            shadowView.isHidden = true
        } else {
            cone2.isHidden = true
            cone1.isHidden = true
            shadowView.isHidden = false
        }
    }
}

