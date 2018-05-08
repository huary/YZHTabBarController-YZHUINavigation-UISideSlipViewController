//
//  Style2ViewController.m
//  YZHUINavigationController
//
//  Created by captain on 17/2/14.
//  Copyright © 2017年 dlodlo. All rights reserved.
//

#import "Style2ViewController.h"
#import "YZHUINavigationController.h"
#import "Style2_2ViewController.h"


@interface Style2ViewController () <YZHUINavigationControllerDelegate>

@end

@implementation Style2ViewController

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
    
    [self addNavigationLeftItemsWithTitles:@[@"左边"] target:self action:@selector(back:)    isReset:YES];
    
    [self addNavigationRightItemsWithTitles:@[@"右边"] target:self action:@selector(back:) isReset:YES];
    
    YZHUINavigationController *nav = (YZHUINavigationController*)self.navigationController;
    nav.pushVCDelegate = self;
}

#pragma mark YZHUINavigationControllerDelegate
-(UIViewController*)YZHUINavigationController:(YZHUINavigationController *)navigationController pushNextViewControllerForViewController:(UIViewController *)viewController
{
    if (viewController == self) {
        Style2_2ViewController *style2VC = [[Style2_2ViewController alloc] init];
        return style2VC;
    }
    return nil;
}


@end
