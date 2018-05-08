//
//  AppDelegate.h
//  YZHUINavigationController
//
//  Created by captain on 16/11/17.
//  Copyright (c) 2016年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)presentLeftVC;
-(void)presentRightVC;
@end

