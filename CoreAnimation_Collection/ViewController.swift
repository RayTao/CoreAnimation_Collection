//
//  ViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 15/12/10.
//  Copyright © 2015年 ray. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var dataSource:[[String]] = [["CALayerViewController"],
        ["ContentsGravitysViewController","ContentsScaleViewController",
            "ContentsRectViewController","ContentsCenterViewController",
            "DrawingViewController"],
        ["AnchorPointViewController","CoordinateSystemViewController",
            "HitTestingViewController"],
        ["CornerRadiusViewController","BorderViewController","ShadowViewController",
            "MaskLayerController","MiniAndMagnificationFilterController","GroupOpacityController"],
        ["AffineTransformController","CATransform3DM34Controller",
            "SublayerTransformController","DoubleSidedController",
            "flattenController","Object3DController"],
        ["CAShapeLayerController","CATextLayerController",
            "CATransformLayerViewController","CAGradientLayerViewController",
        "CAReplicatorLayerViewController","CAScrollLayerViewController",
        "CATiledLayerViewController","CAEmitterLayerViewController",
        "CAEAGLLayerViewController","GLKViewDemoController",
        "AVPlayerLayerViewController"],
        ["CATransactionViewController","PresentationLayerViewController"],
        ["PropertyAnimationViewController","CAKeyframeAnimationViewController",
        "RotationViewController","AnimationGroupViewController",
        "TransitionViewController","LayerTreeTransitionController",
        "CustomTransitionController","StopAnimationController"],
        ["DurationRepeatCountController","AutoreversesRepeatDurationController"],
        ["WaveViewController","GooeyViewController",
            "SwitchersCollectionViewController"]]
    var titleArray = [["1.1 CALayer"],
        ["2.1 contentsGravitys\n决定内容在图片中的对齐方式","2.2 ContentsScale and MaskToBounds\n像素和点的比例 是否显示超出边界的内容",
            "2.3 contentsRect\n视图的切割","2.4 contentsCenter\n界定边框和图层的可拉伸区域",
        "2.5 Custom Drawing\n自定义绘制寄宿图"],
        ["3.1 AnchorPoint\n锚点","3.2 CoordinateSystem\n坐标系","3.3 Hit testing\n点击测试"],
        ["4.1 CornerRadius\n圆角","4.2 Broder \n图层边框","4.3 Shadow \n阴影","4.4 maskLayer \n图层蒙版",
        "4.5 MiniAndMagnificationFilter \n拉伸过滤","4.6 GroupOpacity \n组透明"],
        ["5.1 AffineTransform \n2D变换(旋转、缩放、位移)","5.2 CATransform3D \n3D变换 透视投影","5.3 SublayerTransform \n3D变换 共同变换","5.4 DoubleSided \n双面视图","5.5 flattening \n通过旋转展现扁平化特性","5.6 Object3D \n固体对象"],
        ["6.1 CAShapeLayer","6.2 CATextLayer","6.3 CATransformLayer",
        "6.4 CAGradientLayer \n 渐变图层","6.5 CAReplicatorLayer \n 重复图层",
        "6.5 CAScrollLayer \n 滚动图层","6.6 CATiledLayer \n 小片裁剪",
        "6.7 CAEmitterLayer \n 粒子图层","6.8 CAEAGLLayer \n OpenGL 图层",
        "6.9 GLKView ","6.10 AVPlayerLayer \n 视屏图层"],
        ["7.1 CATransaction \n 事务","7.2 PresentationLayer \n 呈现图层"],
        ["8.1 PropertyAnimation \n 属性动画","8.2 CAKeyframeAnimation \n 关键帧动画",
            "8.3 Rotation \n 旋转","8.4 AnimationGroup \n 组动画",
            "8.5 transition \n 转场动画","8.6 LayerTreeTransition \n 图层树转场动画",
        "8.7 CustomTransition \n 自定义转场","8.8 StopAnimation \n 取消动画"],
        ["9.1 Duration RepeatCount","9.2 Autoreverses RepeatDuration"],
        ["Waveing\n类似siri的波浪","Gooey\n橡皮筋弹性动画","SwitcherCollection\n开关动画合集"]]
    var headTitle:[String] = ["图层树CALayer",
        "寄宿图contents","图层几何学","视觉效果","图层变换","专属图层","隐式动画",
        "显式动画","图层时间 CAMediaTiming",
        "自定义动画集合"]
    
    let cellIndentifier = "cell"
    lazy var tableView:UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 45.0
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIndentifier)
        tableView.sectionHeaderHeight = 35.0
        tableView.tableHeaderView = self.titleView(0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        dataSource = dataSource.reverse()
        titleArray = titleArray.reverse()
        headTitle = headTitle.reverse()
        
        self.view.addSubview(self.tableView)
    }

    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let className = "CoreAnimation_Collection." + dataSource[indexPath.section][indexPath.row]
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let VC = aClass.init()
        VC.view.backgroundColor = UIColor.lightGrayColor()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.titleView(section)
    }
    
    func titleView(section: Int) -> UIView {
        let titleLabel = UILabel.init(frame: CGRectMake(20, 0, 280, 30))
        titleLabel.text = "  " + self.headTitle[section]
        return titleLabel
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    //MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.font = UIFont.systemFontOfSize(12.0)
        cell.textLabel?.text = titleArray[indexPath.section][indexPath.row]
        
    }
}

