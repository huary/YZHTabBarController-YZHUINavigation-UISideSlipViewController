//
//  UINavigationBarView.h
//  BaseDefaultUINavigationController
//
//  Created by captain on 16/8/16.
//  Copyright (c) 2016年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIBarViewStyle)
{
    UIBarViewStyleNone     = 0,
    UIBarViewStyleDefault  = UIBarStyleDefault,
    UIBarViewStyleBlack    = UIBarStyleBlack,
};

@interface UINavigationBarView : UIView

@property (nonatomic, assign) UIBarViewStyle style;

@property (nonatomic, strong, readonly) UIImageView *bottomLine;

@end
