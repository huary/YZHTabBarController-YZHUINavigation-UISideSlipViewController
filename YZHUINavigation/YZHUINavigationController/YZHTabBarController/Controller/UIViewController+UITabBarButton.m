//
//  UIViewController+UITabBarButton.m
//  YZHUINavigationController
//
//  Created by yuan on 2018/4/25.
//  Copyright © 2018年 dlodlo. All rights reserved.
//

#import "UIViewController+UITabBarButton.h"
#import <objc/runtime.h>

@implementation UIViewController (UITabBarButton)

-(void)setTabBarButton:(UITabBarButton *)tabBarButton
{
    objc_setAssociatedObject(self, @selector(tabBarButton), tabBarButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UITabBarButton*)tabBarButton
{
    return (UITabBarButton*)objc_getAssociatedObject(self, _cmd);
}

@end
