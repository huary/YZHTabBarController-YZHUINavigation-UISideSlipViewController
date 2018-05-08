//
//  Style4ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style4ViewController.h"
#import "YZHUINavigationController.h"
#import "Style4_2ViewController.h"

@interface Style4ViewController () <YZHUINavigationControllerDelegate>
@end

@implementation Style4ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpChildView];
}

-(void)back:(id)sender
{
    
}

-(void)setUpChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    
//    self.navigationBarViewBackgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.4 alpha:1.0];
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)    isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
}

#pragma mark YZHUINavigationControllerDelegate
-(UIViewController*)YZHUINavigationController:(YZHUINavigationController *)navigationController pushNextViewControllerForViewController:(UIViewController *)viewController
{
    if (viewController == self) {
        Style4_2ViewController *style2VC = [[Style4_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}

@end
