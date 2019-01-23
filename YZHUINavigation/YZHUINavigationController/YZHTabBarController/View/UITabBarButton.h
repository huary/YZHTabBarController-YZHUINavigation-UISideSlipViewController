//
//  UITabBarButton.h
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarItem+UIButton.h"

@class UITabBarButton;

typedef void(^TabBarEventActionBlock)(UITabBarButton *button);

//返回需要显示的badgeValue和badgeType
//typedef NSString*(^TabBarBadgeBlock)(UITabBarButton *button, UIButton *badgeButton, NSString *badgeValue, NSBadgeType *badgeType);

@interface UITabBarButton : UIButton

@property (nonatomic, strong) UITabBarItem *tabBarItem;

//同tabBarItem上的badgeValueUpdateBlock
//@property (nonatomic, copy) TabBarBadgeBlock badgeValueUpdateBlock;

@property (nonatomic, weak) UIView *tabBarView;

@property (nonatomic, weak) UITabBarController *tabBarController;

@end
