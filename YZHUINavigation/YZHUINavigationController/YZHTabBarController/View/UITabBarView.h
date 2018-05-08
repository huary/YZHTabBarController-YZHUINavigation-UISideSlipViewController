//
//  UITabBarView.h
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarButton.h"

typedef NS_ENUM(NSInteger, UITabBarViewStyle)
{
    UITabBarViewStyleHorizontal     = 0,
    UITabBarViewStyleVertical       = 1,
};

typedef NS_ENUM(NSInteger, UITabBarViewUseFor)
{
    //默认为TabBar来使用
    UITabBarViewUseForTabBar           = 0,
    //其他不适为TabBar来使用时
    UITabBarViewUseForCustom           = 1,
};

@class UITabBarView;

@protocol UITabBarViewDelegate <NSObject>

@optional
-(BOOL)tabBarView:(UITabBarView*)tabBarView didSelectFrom:(NSInteger)from to:(NSInteger)to;
@end

@interface UITabBarView : UIView

@property (nonatomic, weak) id<UITabBarViewDelegate> delegate;

@property (nonatomic, assign) UITabBarViewStyle tabBarViewStyle;

@property (nonatomic, assign) UITabBarViewUseFor tabBarViewUseFor;

//default is NO
@property (nonatomic, assign) BOOL scrollContent;

-(UITabBarButton*)addTabBarItem:(UITabBarItem*)tabBarItem;
-(UITabBarButton*)resetTabBarItem:(UITabBarItem *)tabBarItem atIndex:(NSInteger)index;

-(void)addTabBarWithCustomView:(UIView*)customView;
-(void)resetTabBarWithCustomView:(UIView*)customView atIndex:(NSInteger)index;

-(void)doSelectTo:(NSInteger)to;

-(NSInteger)currentIndex;

@end
