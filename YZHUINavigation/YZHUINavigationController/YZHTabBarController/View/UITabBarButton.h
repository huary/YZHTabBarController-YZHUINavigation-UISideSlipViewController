//
//  UITabBarButton.h
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarItem+UIButton.h"

typedef NS_ENUM(NSInteger,NSBadgeType)
{
    //直接hidden
    NSBadgeTypeNULL     = -1,
    //会根据需要显示的badgeValue判断是否显示(IS_AVAILABLE_NSSTRNG(realShowValue))
    NSBadgeTypeDefault  = 0,
    //直接展示小圆圈
    NSBadgeTypeDot      = 1,
};

@class UITabBarButton;

typedef void(^TabBarEventActionBlock)(UITabBarButton *button);

//返回需要显示的badgeValue和badgeType
typedef NSString*(^TabBarBadgeBlock)(UITabBarButton *button, NSString *badgeValue, NSBadgeType *badgeType);

@interface UITabBarButton : UIButton

@property (nonatomic, strong) UITabBarItem *tabBarItem;

@property (nonatomic, copy) TabBarBadgeBlock badgeBlock;

@property (nonatomic, weak) UIView *tabBarView;

@end
