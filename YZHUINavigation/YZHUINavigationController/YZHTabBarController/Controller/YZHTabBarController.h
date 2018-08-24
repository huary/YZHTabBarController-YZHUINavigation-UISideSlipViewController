//
//  YZHTabBarController.h
//  YZHTabBarControllerDemo
//
//  Created by captain on 17/2/7.
//  Copyright © 2017年 yzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZHUINavigationController.h"

UIKIT_EXTERN NSString *const YZHTabBarItemTitleTextFontKey;
UIKIT_EXTERN NSString *const YZHTabBarItemTitleNormalColorKey;
UIKIT_EXTERN NSString *const YZHTabBarItemTitleSelectedColorKey;
UIKIT_EXTERN NSString *const YZHTabBarItemSelectedBackgroundColorKey;
UIKIT_EXTERN NSString *const YZHTabBarItemHighlightedBackgroundColorKey;


@class YZHTabBarController;
@protocol YZHTabBarControllerDelegate <NSObject>

@optional
-(BOOL)tabBarController:(YZHTabBarController*)tabBarController shouldSelectFrom:(NSInteger)from to:(NSInteger)to;
-(void)tabBarController:(YZHTabBarController *)tabBarController doubleClickAtIndex:(NSInteger)index;

@end

/*
 *YZHTabBarController不是单例对象，提供了一个全局的对象shareTabBarController
 */
@interface YZHTabBarController : UITabBarController

@property (nonatomic, copy) NSDictionary *tabBarAttributes;
@property (nonatomic, weak) id<YZHTabBarControllerDelegate> tabBarDelegate;

+(YZHTabBarController*)shareTabBarController;

-(void)doSelectTo:(NSInteger)toIndex;

-(void)setupChildViewController:(UIViewController*)childVC
                      withTitle:(NSString*)title
                          image:(UIImage*)image
                  selectedImage:(UIImage*)selectedImage
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle;

-(void)setupChildViewController:(UIViewController*)childVC
                      withTitle:(NSString*)title
                      imageName:(NSString*)imageName
              selectedImageName:(NSString*)selectedImageName
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle;

-(void)setupChildViewController:(UIViewController *)childVC
                 customItemView:(UIView*)customItemView
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle;

-(void)clear;

-(void)resetChildViewController:(UIViewController*)childVC
                      withTitle:(NSString*)title
                          image:(UIImage*)image
                  selectedImage:(UIImage*)selectedImage
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
                          atIndex:(NSInteger)index;

-(void)resetChildViewController:(UIViewController*)childVC
                        withTitle:(NSString*)title
                        imageName:(NSString*)imageName
                selectedImageName:(NSString*)selectedImageName
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
                          atIndex:(NSInteger)index;

-(void)resetChildViewController:(UIViewController *)childVC
                 customItemView:(UIView*)customItemView
navigationControllerBarAndItemStyle:(UINavigationControllerBarAndItemStyle)barAndItemStyle
                        atIndex:(NSInteger)index;
@end
