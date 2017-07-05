//
//  UIBezierPath+TextPath.h
//  CoreAnimation_Collection
//
//  Created by ray on 2017/7/5.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (TextPath)
+ (UIBezierPath *)bezierPathWithText:(NSString *)text font:(UIFont *)font;

@end
