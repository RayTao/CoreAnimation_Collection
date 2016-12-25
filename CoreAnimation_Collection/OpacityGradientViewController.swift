//
//  OpacityGradientViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 2016/12/6.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class OpacityGradientViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let opacityView = OpacityGradientView(frame: CGRect(x: 0, y: 0, width: 200, height: 360))
        opacityView.center = view.center
        view.addSubview(opacityView)
        
        let textLabel = UILabel(frame: opacityView.bounds)
        textLabel.textColor = UIColor.yellow
        textLabel.text = poiemText()
        textLabel.numberOfLines = 0
        opacityView.addSubview(textLabel)
    }
    
    func poiemText() -> String {
        return "我喜欢你是寂静的，仿佛你消失了一样。\n" +
        
        "你从远处聆听我，我的声音却无法触及你。\n" +
        
        "好像你的双眼已经飞离远去，\n" +
        
        "如同一个吻，封缄了你的嘴。\n" +
        
        
        
        "如同所有的事物充满了我的灵魂，" +
        
        "你从所有的事物中浮现，充满了我的灵魂。\n" +
        
        "你像我灵魂，一只梦的蝴蝶，\n" +
        
        "你如同忧郁这个字。\n" +
        
        
        
        "我喜欢你是寂静的，好像你已远去。\n" +
        
        "你听起来像在悲叹，一只如鸽悲鸣的蝴蝶。\n" +
        
        "你从远处听见我，我的声音无法企及你。\n" +
        
        "让我在你的沉默中安静无声。\n"
//
//        
//        并且让我借你的沉默与你说话，
//        
//        你的沉默明亮如灯，简单如指环。
//        
//        你就像黑夜，拥有寂静与群星。
//        
//        你的沉默就是星星的沉默，遥远而明亮。
//        
//        
//        
//        我喜欢你是寂静的，仿佛你消失了一样，
//        
//        遥远且哀伤，仿佛你已经死了。
//        
//        彼时，一个字，一个微笑，已经足够。
//        
//        而我会觉得幸福，因那不是真的而觉得幸福"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
