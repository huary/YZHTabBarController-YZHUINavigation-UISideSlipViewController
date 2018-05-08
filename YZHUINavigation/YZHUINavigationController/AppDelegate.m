//
//  AppDelegate.m
//  YZHUINavigationController
//
//  Created by captain on 16/11/17.
//  Copyright (c) 2016年 yzh. All rights reserved.
//

#import "AppDelegate.h"
#import "YZHUINavigationController.h"

#import "YZHTabBarController.h"
#import "Style1ViewController.h"
#import "Style2ViewController.h"
#import "Style3ViewController.h"
#import "Style4ViewController.h"
#import "Style5ViewController.h"
#import "UISideSlipViewController.h"

#import "leftViewController.h"
#import "rightViewController.h"
#import "UIImage+TintColor.h"

@interface AppDelegate ()<YZHTabBarControllerDelegate>

@end

@implementation AppDelegate

-(void)setUpRootVC
{
    YZHTabBarController *rootVC = [[YZHTabBarController alloc] init];
    rootVC.tabBarDelegate = self;
    
#if 0
    Style1ViewController *style1  = [[Style1ViewController alloc] init];
    [rootVC setupChildViewController:style1 withTitle:@"系统默认" imageName:@"TarBar_home_NM" selectedImageName:@"TarBar_home_HL" navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemDefaultStyle];
    
    Style2ViewController *style2 = [[Style2ViewController alloc] init];
    [rootVC setupChildViewController:style2 withTitle:@"自定义导航栏" imageName:@"TarBar_assets_NM" selectedImageName:@"TarBar_assets_HL" navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemGlobalBarWithDefaultItemStyle];

    Style3ViewController *style3 = [[Style3ViewController alloc] init];
    [rootVC setupChildViewController:style3 withTitle:@"自定义导航栏和Item" imageName:@"TarBar_VR_NM" selectedImageName:@"TarBar_VR_HL" navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemGlobalBarItemStyle];
    
//    CGFloat itemW = SCREEN_WIDTH / 5;
//    CGFloat w = rootVC.tabBar.bounds.size.height;
//    CGFloat h = w;
//    CGFloat x = (itemW - w)/2;
//    CGFloat y = -h/2;
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    customView.layer.cornerRadius = h/2;
//    customView.layer.masksToBounds = YES;
//    customView.backgroundColor = RAND_COLOR;
//
//    [rootVC resetChildViewController:nil customItemView:customView navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemGlobalBarWithDefaultItemStyle atIndex:2];
    
    
    Style4ViewController *style4 = [[Style4ViewController alloc] init];
    [rootVC setupChildViewController:style4 withTitle:@"自定义VC导航和Item" imageName:@"TarBar_VR_NM" selectedImageName:@"TarBar_VR_HL" navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemViewControllerBarItemStyle];
    
//    w = rootVC.tabBar.bounds.size.height;
//    h = w;
//    x = (itemW - w)/2;
//    y = -h/2;
//    customView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    customView.layer.cornerRadius = h/2;
//    customView.layer.masksToBounds = YES;
//    customView.backgroundColor = RAND_COLOR;
//
//    [rootVC resetChildViewController:nil customItemView:customView navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemGlobalBarWithDefaultItemStyle atIndex:3];
//
//    [rootVC resetChildViewController:style4 withTitle:@"自定义VC导航和Item" imageName:@"TarBar_VR_NM" selectedImageName:@"TarBar_VR_HL" navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemViewControllerBarItemStyle atIndex:3];
    
    Style5ViewController *style5 = [[Style5ViewController alloc] init];
    [rootVC setupChildViewController:style5 withTitle:@"自定义VC导航和系统Item" imageName:@"TarBar_VR_NM" selectedImageName:@"TarBar_VR_HL" navigationControllerBarAndItemStyle:UINavigationControllerBarAndItemViewControllerBarWithDefaultItemStyle];
    self.window.rootViewController = rootVC;
#else
    rootVC.view.backgroundColor = RED_COLOR;
    leftViewController *leftVC = [[leftViewController alloc] init];
    leftVC.view.backgroundColor = WHITE_COLOR;//[UIColor purpleColor];

    rightViewController *rightVC = [[rightViewController alloc] init];
    rightVC.view.backgroundColor = WHITE_COLOR;//[UIColor blueColor];

    UISideSlipViewController *sideSlipVC = [[UISideSlipViewController alloc] initWithContentViewController:rootVC leftViewController:leftVC rightViewController:rightVC];

    self.window.rootViewController = sideSlipVC;
    
//    [sideSlipVC presentLeftViewController:YES];
//    [sideSlipVC presentRightViewContrller:YES];
#endif
    
}

-(void)presentLeftVC
{
    UISideSlipViewController *sideSlipVC = (UISideSlipViewController*)self.window.rootViewController;
    [sideSlipVC presentLeftViewController:YES];
}

-(void)presentRightVC
{
    UISideSlipViewController *sideSlipVC = (UISideSlipViewController*)self.window.rootViewController;
    [sideSlipVC presentRightViewContrller:YES];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:BROWN_COLOR];
    [[UINavigationBar appearance] setTintColor:WHITE_COLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR,NSFontAttributeName:NAVIGATION_ITEM_TITLE_FONT}];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self setUpRootVC];
    
    [self.window makeKeyAndVisible];
            
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)tabBarController:(YZHTabBarController*)tabBarController shouldSelectFrom:(NSInteger)from to:(NSInteger)to
{
    NSLog(@"from=%ld,to=%ld",from,to);
//    if (to == 2) {
//        return NO;
//    }
    return YES;
}
@end
