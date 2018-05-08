//
//  Style1ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style1ViewController.h"
#import "YZHUINavigationController.h"
#import "Style1_2ViewController.h"
#import "AppDelegate.h"

@interface Style1ViewController () <YZHUINavigationControllerDelegate>

@end

@implementation Style1ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpChildView];
}

-(void)back:(id)sender
{
    Style1_2ViewController *style2VC = [[Style1_2ViewController alloc] init];
    [self.navigationController pushViewController:style2VC animated:YES];
}

-(void)setUpChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    self.navigationBarBottomLineColor = nil;
    
    UIView *subView = [[UIView alloc] init];
    subView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    subView.frame = CGRectMake(100, 100, 150, 40);
    subView.backgroundColor = BLUE_COLOR;
    [self.view addSubview:subView];
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:) isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
}


#pragma mark YZHUINavigationControllerDelegate
-(UIViewController*)YZHUINavigationController:(YZHUINavigationController *)navigationController pushNextViewControllerForViewController:(UIViewController *)viewController
{
    if (viewController == self) {
        Style1_2ViewController *style2VC = [[Style1_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}


@end
