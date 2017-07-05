//
//  NSString+TextAnimation.h
//  CoreAnimation_Collection
//
//  Created by ray on 2017/7/5.
//  Copyright © 2017年 ray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TextAnimation)
- (void)animateOnView:(UIView *)aView atRect:(CGRect)aRect forFont:(UIFont *)aFont withColor:(UIColor *)aColor andDuration:(CGFloat)aDuration;

@end
